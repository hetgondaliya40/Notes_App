import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color.dart';
import '../../../models/notes_modal.dart';

class NotesDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Note note = Get.arguments; // Get the note from arguments

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(note.content),
          ],
        ),
      ),
    );
  }
}
