// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/common/dialogs.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/features/notes/data/note.dart';
import 'package:gpt_study_buddy/features/notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class CreateNotesViewRouteArgs {
  const CreateNotesViewRouteArgs({
    required this.note,
  });

  final Note? note;
}

class CreateNotesView extends StatefulWidget {
  const CreateNotesView({
    super.key,
    this.args,
  });

  final CreateNotesViewRouteArgs? args;

  @override
  State<CreateNotesView> createState() => _CreateNotesViewState();
}

class _CreateNotesViewState extends State<CreateNotesView> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.args?.note != null) {
      titleController.text = widget.args?.note!.title ?? '';
      contentController.text = widget.args?.note!.content ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.args?.note != null;
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, _) {
        return AppScaffold(
          isLoading: notesProvider.isLoading,
          appBar: AppBar(
            title: Text(isEditing ? 'Edit Note' : 'Add Note'),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (contentController.text.isNotEmpty) {
                      try {
                        if (!isEditing) {
                          await notesProvider.addNote(
                            title: titleController.text,
                            content: contentController.text,
                          );
                          Navigator.pop(context);
                        } else {
                          await notesProvider.updateNote(
                            title: titleController.text,
                            content: contentController.text,
                            id: widget.args?.note?.id ?? "",
                          );
                          showToast(
                            context,
                            'Note updated.',
                          );
                        }
                      } on DomainException catch (e) {
                        showToast(
                          context,
                          e.message,
                        );
                      } catch (_) {
                        showUnexpectedErrorToast(context);
                      }
                    }
                  },
                  child: Text(
                    isEditing ? 'Update' : 'Save',
                    style: const TextStyle(
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
