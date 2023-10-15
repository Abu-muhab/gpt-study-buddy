// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/common/dialogs.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/common/retry_widget.dart';
import 'package:gpt_study_buddy/features/navigation/app_views.dart';
import 'package:gpt_study_buddy/features/notes/providers/notes_provider.dart';
import 'package:gpt_study_buddy/features/notes/views/create_notes_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/note.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  : notesProvider.notes.isEmpty
                      ? SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              context.go(AppViews.createNotes);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: const Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notes_sharp,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "You don't have any\nnotes yet",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: notesProvider.notes.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                context.go(
                                  AppViews.createNotes,
                                  extra: CreateNotesViewRouteArgs(
                                    note: notesProvider.notes[index],
                                  ),
                                );
                              },
                              onLongPress: () async {
                                bool delete =
                                    await showDeleteConfirmationDialog(
                                  context: context,
                                  title:
                                      "Delete Note ${notesProvider.notes[index].title?.isNotEmpty == true ? "\"${notesProvider.notes[index].title}\"" : "Untitled"}",
                                  message:
                                      "Are you sure you want to delete this note?",
                                );

                                if (delete) {
                                  try {
                                    await notesProvider.deleteNote(
                                      id: notesProvider.notes[index].id ?? "",
                                    );
                                    showToast(
                                      context,
                                      "Note deleted successfully",
                                    );
                                  } on DomainException catch (e) {
                                    showToast(context, e.message);
                                  } catch (_) {
                                    showUnexpectedErrorToast(context);
                                  }
                                }
                              },
                              child: NotesPreview(
                                note: notesProvider.notes[index],
                              ),
                            );
                          },
                        )),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
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
            DateFormat('dd MMM kk:mm').format(note.updatedAt),
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
