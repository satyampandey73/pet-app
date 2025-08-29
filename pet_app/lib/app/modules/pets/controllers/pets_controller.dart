import 'package:get/get.dart';
import '../../../data/api_client.dart';
import '../../auth/controllers/auth_controller.dart';

class PetsController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxList pets = [].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPets();
  }

  Future<void> fetchPets() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _apiClient.getPets();
      pets.value = response.data;
    } catch (e) {
      error.value = 'Failed to fetch pets: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPet(String name, String type, int age, String notes) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _apiClient.addPet({
        'name': name,
        'type': type,
        'age': age,
        'notes': notes,
      });
      Get.back();
      fetchPets();
    } catch (e) {
      error.value = 'Failed to add pet: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
