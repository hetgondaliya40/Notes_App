import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/notes_modal.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  var name = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var pickedImage = Rx<File?>(null);
  var password = ''.obs;
  var notes = <Note>[].obs;

  // Method to pick an image (from gallery or camera)
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
    }
  }

  // Method to save user data into SharedPreferences
  void saveUserData() {
    box.write('name', name.value);
    box.write('email', email.value);
    box.write('phoneNumber', phoneNumber.value);
    box.write('password', password.value);
  }

  void setUserData(String name, String phone, String email, String password) {
    this.name.value = name;
    this.phoneNumber.value = phone;
    this.email.value = email;
    this.password.value = password;
    saveUserData();
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Load user data on initialization
    loadNotes(); // Load notes when the controller is initialized
  }

  // Method to load user data from SharedPreferences
  void loadUserData() {
    name.value = box.read('name') ?? '';
    email.value = box.read('email') ?? '';
    phoneNumber.value = box.read('phoneNumber') ?? '';
    password.value = box.read('password') ?? '';
  }

  // Add a new note
  void addNote(String title, String content) {
    final newNote = Note(
      id: DateTime.now().toString(),
      title: title,
      content: content,
    );
    notes.add(newNote);
    saveNotes();
  }

  // Edit a note
  void editNote(String id, String title, String content) {
    final index = notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      notes[index] = Note(
        id: id,
        title: title,
        content: content,
      );
      saveNotes();
    }
  }

  // Delete a note
  void deleteNote(String id) {
    notes.removeWhere((note) => note.id == id);
    saveNotes();
  }

  // Save notes to GetStorage
  void saveNotes() {
    final notesJson = notes.map((e) => e.toJson()).toList();
    box.write('notes', jsonEncode(notesJson)); // Store the notes in JSON format
  }

  // Load notes from GetStorage
  void loadNotes() {
    final notesData = box.read('notes');
    if (notesData != null) {
      final List<dynamic> decodedData = jsonDecode(notesData);
      notes.value = decodedData.map((e) => Note.fromJson(e)).toList();
    }
  }

  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}
