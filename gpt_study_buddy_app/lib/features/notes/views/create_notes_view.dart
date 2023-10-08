// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/common/dialogs.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/features/notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class CreateNotesView extends StatelessWidget {
  CreateNotesView({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, _) {
        return AppScaffold(
          isLoading: notesProvider.isLoading,
          appBar: AppBar(
            title: const Text('Add Note'),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (contentController.text.isNotEmpty) {
                      try {
                        await notesProvider.addNote(
                          title: titleController.text,
                          content: contentController.text,
                        );
                        Navigator.pop(context);
                      } on DomainException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message),
                          ),
                        );
                      } catch (_) {
                        showUnexpectedErrorToast(context);
                      }
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ))
            ],
          ),
          body: Container(
            color: AppColors.primaryColor[100],
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      expands: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Content',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
