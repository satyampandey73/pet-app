# FastAPI Pet Platform Backend

This project is a FastAPI backend for a pet listing platform. It provides authentication and pet management endpoints, using MongoDB Atlas for storage.

## Endpoints
- `POST /auth/register` — Register a new user (email, password)
- `POST /auth/login` — Login and receive JWT token
- `GET /pets` — List pets for authenticated user
- `POST /pets` — Add a pet (name, type, age, notes)

## Storage
- MongoDB Atlas

## Setup
1. Install dependencies: `pip install fastapi uvicorn pymongo python-dotenv`
2. Set up a `.env` file with your MongoDB Atlas URI and JWT secret.
3. Run the server: `uvicorn main:app --reload`

## Notes
- All pet endpoints require authentication via JWT.
- Replace placeholder values in `.env` with your actual credentials.
