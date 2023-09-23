import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/custom_radio_button.dart';

import '../../main.dart';

class SelectTraitTab extends StatelessWidget {
  const SelectTraitTab({
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
            "What personality do you want your assistant to have?",
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
            onChanged: (int? value) {},
            text: "Professional",
            subText:
                "The AI assistant speaks in a formal and respectful tone, using appropriate titles and language in business and work-related contexts.",
          ),
          CustomRadioButton<int>(
            value: 2,
            groupValue: 1,
            onChanged: (int? value) {},
            text: "Witty",
            subText:
                "The AI assistant has a quick and clever sense of humor, using puns, jokes, and pop culture references to entertain and engage the user",
          ),
          CustomRadioButton<int>(
            value: 3,
            groupValue: 1,
            onChanged: (int? value) {},
            text: "Informative",
            subText:
                "The AI assistant has a serious and informative personality, providing detailed and accurate information on a variety of topics",
          ),
          CustomRadioButton<int>(
            value: 4,
            groupValue: 1,
            onChanged: (int? value) {},
            text: "Supportive",
            subText:
                "The AI assistant has a nurturing and empathetic personality, providing encouragement and emotional support to the user.",
          ),
        ],
      ),
    );
  }
}
