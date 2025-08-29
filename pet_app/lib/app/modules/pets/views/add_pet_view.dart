import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/pets_controller.dart';

class AddPetView extends GetView<PetsController> {
  const AddPetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final ageController = TextEditingController();
    final notesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Pet Type',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Dog, Cat, Bird',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  hintText: 'Any additional information',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.error.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      controller.error.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.addPet(
                      nameController.text,
                      typeController.text,
                      int.parse(ageController.text),
                      notesController.text,
                    );
                  }
                },
                child: Obx(() {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Add Pet');
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
