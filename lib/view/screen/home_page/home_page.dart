import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../color.dart';
import '../../../controllers/image_controller.dart';
import '../../../models/notes_modal.dart';
import '../notes_detail_page/notes_detail_page.dart';

class HomePage extends StatelessWidget {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddNoteDialog(context), // Add note on click
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 370,
              width: double.infinity,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => authController.pickedImage.value != null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  FileImage(authController.pickedImage.value!),
                            )
                          : const CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.person),
                            ),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Text(
                        "Name : ${authController.name.value}",
                        style: const TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Obx(
                      () => Text(
                        "Email : ${authController.email.value}",
                        style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Obx(
                      () => Text(
                        "Phone Number: ${authController.phoneNumber.value}",
                        style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Edit profile button to show the edit dialog
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                      ),
                      onPressed: () => _showEditProfileDialog(context),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 21,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: authController.notes.length,
          itemBuilder: (context, index) {
            final note = authController.notes[index];
            return Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () => Get.to(() => NotesDetailPage(),
                    arguments: note), // Navigate to detailed page
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditNoteDialog(context, note),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          authController.deleteNote(note.id), // Delete note
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: Container(
            height: 400,
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty) {
                          authController.addNote(
                              titleController.text, contentController.text);
                          Get.back();
                        }
                      },
                      child: const Text("Save"),
                    ),
                    TextButton(
                      onPressed: () => Get.back(), // Cancel action
                      child: const Text("Cancel"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: Container(
            height: 400,
            width: 300,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty) {
                          authController.editNote(note.id, titleController.text,
                              contentController.text);
                          Get.back();
                        }
                      },
                      child: const Text("Save"),
                    ),
                    TextButton(
                      onPressed: () => Get.back(), // Cancel action
                      child: const Text("Cancel"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController =
        TextEditingController(text: authController.name.value);
    final emailController =
        TextEditingController(text: authController.email.value);
    final phoneController =
        TextEditingController(text: authController.phoneNumber.value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            authController.pickedImage.value != null
                                ? FileImage(authController.pickedImage.value!)
                                : null,
                        child: authController.pickedImage.value == null
                            ? const Icon(Icons.camera_alt)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: IconButton(
                            onPressed: () => _showImagePicker(context),
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save the edited details
                authController.name.value = nameController.text;
                authController.email.value = emailController.text;
                authController.phoneNumber.value = phoneController.text;

                authController
                    .saveUserData(); // Save updated data to SharedPreferences

                Get.back(); // Close the dialog
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Get.back(), // Close the dialog without saving
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take Photo'),
              onTap: () {
                authController.pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                authController.pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
