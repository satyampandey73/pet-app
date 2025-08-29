import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/pets_controller.dart';

class PetListView extends GetView<PetsController> {
  const PetListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.error.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchPets,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.pets.isEmpty) {
          return const Center(
            child: Text('No pets found. Add your first pet!'),
          );
        }

        return ListView.builder(
          itemCount: controller.pets.length,
          itemBuilder: (context, index) {
            final pet = controller.pets[index];
            return ListTile(
              title: Text(pet['name']),
              subtitle: Text('${pet['type']} • ${pet['age']} years old'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(Routes.PET_DETAIL, arguments: pet),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_PET),
        child: const Icon(Icons.add),
      ),
    );
  }
}
