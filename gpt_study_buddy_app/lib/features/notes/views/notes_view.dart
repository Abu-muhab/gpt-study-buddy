import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/common/retry_widget.dart';
import 'package:gpt_study_buddy/features/notes/providers/notes_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/note.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, _) {
        return AppScaffold(
          isLoading: notesProvider.isLoading,
          body: Container(
              color: AppColors.primaryColor[100],
              child: notesProvider.failedFetch
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RetryWidget(
                          onRetry: () {
                            notesProvider.fetchNotes();
                          },
                        )
                      ],
                    )
                  : ListView.builder(
                      itemCount: notesProvider.notes.length,
                      itemBuilder: (context, index) {
                        return NotesPreview(
                          note: notesProvider.notes[index],
                        );
                      },
                    )),
        );
      },
    );
  }
}

class NotesPreview extends StatelessWidget {
  const NotesPreview({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            note.title ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            note.content ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            DateFormat('dd MMM kk:mm').format(note.lastUpdated),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Divider(
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}
