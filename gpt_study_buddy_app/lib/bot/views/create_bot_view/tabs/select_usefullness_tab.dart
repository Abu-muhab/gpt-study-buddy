import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';
import 'package:gpt_study_buddy/main.dart';

class SelectUsefullnessTab extends StatelessWidget {
  const SelectUsefullnessTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      color: primaryColor[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "How helpful do you want your assistant to be?",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRadioButton<int>(
            value: 1,
            groupValue: 1,
            onChanged: (value) {},
            text: "Helpful",
          ),
          CustomRadioButton<int>(
            value: 2,
            groupValue: 1,
            onChanged: (value) {},
            text: "Sometimes helpful",
          ),
          CustomRadioButton<int>(
            value: 3,
            groupValue: 1,
            onChanged: (value) {},
            text: "Painfully useless",
          ),
        ],
      ),
    );
  }
}
