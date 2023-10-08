// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/common/dialogs.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/create_event_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateEventViewModel>(builder: (contex, viewmodel, _) {
      return AppScaffold(
        isLoading: viewmodel.isLoading,
        appBar: AppBar(
          title: const Text('Create Event'),
          actions: [
            TextButton(
              onPressed: () async {
                if (viewmodel.event.validEntries) {
                  try {
                    await viewmodel.save();
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
              child: Text(
                'Save',
                style: TextStyle(
                  color:
                      viewmodel.event.validEntries ? Colors.white : Colors.grey,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        body: Container(
          color: AppColors.primaryColor[100],
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Event Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                minLines: 1,
                maxLines: 3,
                expands: false,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
                onChanged: (value) {
                  viewmodel.updateEvent(
                    viewmodel.event.copyWith(name: value),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  CupertinoSwitch(
                    value: viewmodel.event.isAllDay,
                    onChanged: (value) {
                      viewmodel.updateEvent(
                        viewmodel.event.copyWith(isAllDay: value),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _DateTimePicker(
                value: viewmodel.event.startTime,
                showTimePicker: !viewmodel.event.isAllDay,
                onDateTimeChanged: (dateTime) {
                  viewmodel.updateEvent(
                    viewmodel.event.copyWith(startTime: dateTime),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _DateTimePicker(
                value: viewmodel.event.endTime,
                showTimePicker: !viewmodel.event.isAllDay,
                firstDate: viewmodel.event.startTime,
                onDateTimeChanged: (dateTime) {
                  viewmodel.updateEvent(
                    viewmodel.event.copyWith(endTime: dateTime),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DateTimePicker extends StatefulWidget {
  const _DateTimePicker({
    required this.onDateTimeChanged,
    required this.value,
    this.showTimePicker = true,
    this.firstDate,
  });

  final void Function(DateTime) onDateTimeChanged;
  final DateTime value;
  final bool showTimePicker;
  final DateTime? firstDate;

  @override
  State<_DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<_DateTimePicker> {
  DateTime get firstDate => widget.firstDate ?? DateTime(1900);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: widget.value,
              firstDate: firstDate,
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() {
                widget.onDateTimeChanged(
                  widget.value.copyWith(
                      year: picked.year, month: picked.month, day: picked.day),
                );
              });
            }
          },
          child: Text(
            DateFormat('EEEE, MMM d, yyyy').format(widget.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(child: Container()),
        if (widget.showTimePicker)
          GestureDetector(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(widget.value),
              );
              if (picked != null) {
                setState(() {
                  if (widget.value.isBefore(firstDate)) {
                    widget.onDateTimeChanged(
                      firstDate,
                    );
                  } else {
                    widget.onDateTimeChanged(
                      widget.value.copyWith(
                        hour: picked.hour,
                        minute: picked.minute,
                      ),
                    );
                  }
                });
              }
            },
            child: Text(
              DateFormat('hh:mm a').format(widget.value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
      ],
    );
  }
}
