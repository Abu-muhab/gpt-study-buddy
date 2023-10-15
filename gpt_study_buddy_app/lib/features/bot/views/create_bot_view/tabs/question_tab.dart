import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/bot/data/question.dart';
import 'package:gpt_study_buddy/features/bot/providers/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/features/bot/views/create_bot_view/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

import '../../../../../common/colors.dart';

class QuestionTab extends StatefulWidget {
  const QuestionTab({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<QuestionTab> createState() => _QuestionTabState();
}

class _QuestionTabState extends State<QuestionTab> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreateBotViewmodel>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      color: AppColors.primaryColor[100],
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.question.question,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.question.isRadio)
                ...widget.question.options.map(
                  (option) {
                    QuestionOption? selected;
                    try {
                      selected = viewModel
                          .getQuestionSelectedOptions(widget.question.id)
                          .first;
                    } catch (_) {}

                    return CustomRadioButton<QuestionOption?>(
                      value: option,
                      groupValue: selected,
                      onChanged: (value) {
                        viewModel.setRadioSelectedOption(
                            widget.question, option);
                      },
                      text: option.label,
                      subText: option.description,
                    );
                  },
                )
              else
                ...widget.question.options.map(
                  (option) {
                    return CustomCheckBox(
                      value: viewModel
                          .getQuestionSelectedOptions(widget.question.id)
                          .contains(option),
                      onChanged: (bool? value) {
                        viewModel.setCheckboxSelectedOption(
                            widget.question, option);
                      },
                      text: option.label,
                      subText: option.description,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
