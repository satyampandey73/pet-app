import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/pets/bindings/pets_binding.dart';
import '../modules/pets/views/pet_list_view.dart';
import '../modules/pets/views/add_pet_view.dart';
import '../modules/pets/views/pet_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.PET_LIST,
      page: () => const PetListView(),
      binding: PetsBinding(),
    ),
    GetPage(
      name: Routes.ADD_PET,
      page: () => const AddPetView(),
      binding: PetsBinding(),
    ),
    GetPage(
      name: Routes.PET_DETAIL,
      page: () {
        final pet = Get.arguments as Map<String, dynamic>;
        return PetDetailView(pet: pet);
      },
      binding: PetsBinding(),
    ),
  ];
}
