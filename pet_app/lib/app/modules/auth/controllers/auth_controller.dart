import 'package:get/get.dart';
import '../../../data/api_client.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _apiClient.login(email, password);
      Get.offAllNamed(Routes.PET_LIST);
    } catch (e) {
      error.value = 'Failed to login: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _apiClient.register(email, password);
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      error.value = 'Failed to register: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiClient.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
