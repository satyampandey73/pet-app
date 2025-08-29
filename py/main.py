from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from typing import List, Optional
from pymongo import MongoClient
import hashlib
import secrets
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# Allow CORS (useful for local development / preflight OPTIONS requests)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # change to a list of origins in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MongoDB setup
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
client = MongoClient(MONGO_URI)
db = client["pet_platform"]
users_col = db["users"]
pets_col = db["pets"]

# --------------------
# MODELS
# --------------------
class UserCreate(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class PetCreate(BaseModel):
    name: str
    type: str
    age: int
    notes: Optional[str] = None

class PetOut(BaseModel):
    id: str
    name: str
    type: str
    age: int
    notes: Optional[str]


# --------------------
# UTILS
# --------------------
def hash_password(password: str) -> str:
    """Simple SHA256 hash"""
    return hashlib.sha256(password.encode()).hexdigest()

def verify_password(password: str, hashed: str) -> bool:
    return hash_password(password) == hashed

def create_token() -> str:
    """Generate random token"""
    return secrets.token_hex(32)

def get_user(email: str):
    return users_col.find_one({"email": email})

def get_current_user(request: Request):
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        raise HTTPException(status_code=401, detail="Missing token")
    # Accept both raw token and 'Bearer <token>' formats
    token = auth_header
    if isinstance(auth_header, str) and auth_header.lower().startswith("bearer "):
        token = auth_header.split(" ", 1)[1]
    user = users_col.find_one({"token": token})
    if not user:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return user


# --------------------
# ENDPOINTS
# --------------------
@app.post("/auth/register", status_code=201)
def register(user: UserCreate):
    if get_user(user.email):
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_pw = hash_password(user.password)
    users_col.insert_one({"email": user.email, "password": hashed_pw, "token": None})
    return {"msg": "User registered"}

@app.post("/auth/login", response_model=Token)
def login(user: UserCreate):
    db_user = get_user(user.email)
    if not db_user or not verify_password(user.password, db_user["password"]):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    token = create_token()
    users_col.update_one({"email": user.email}, {"$set": {"token": token}})
    return {"access_token": token, "token_type": "bearer"}

@app.get("/pets", response_model=List[PetOut])
def list_pets(current_user: dict = Depends(get_current_user)):
    pets = pets_col.find({"owner": current_user["email"]})
    return [
        PetOut(
            id=str(p["_id"]),
            name=p["name"],
            type=p["type"],
            age=p["age"],
            notes=p.get("notes"),
        )
        for p in pets
    ]

@app.post("/pets", status_code=201)
def add_pet(pet: PetCreate, current_user: dict = Depends(get_current_user)):
    pet_doc = {
        "name": pet.name,
        "type": pet.type,
        "age": pet.age,
        "notes": pet.notes,
        "owner": current_user["email"],
    }
    result = pets_col.insert_one(pet_doc)
    return {"id": str(result.inserted_id), "msg": "Pet added"}
