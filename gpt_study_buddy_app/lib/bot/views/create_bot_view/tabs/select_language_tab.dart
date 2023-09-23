import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';

import '../../../../main.dart';

class SelectLanguageTab extends StatelessWidget {
  const SelectLanguageTab({
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
            "What language do you want your assistant to speak?",
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
            text: "English",
            subText:
                "The AI assistant speaks English, using American English spelling and grammar",
          ),
          CustomRadioButton<int>(
            value: 2,
            groupValue: 1,
            onChanged: (int? value) {},
            text: "Nigerian pidgin",
            subText:
                "The AI assistant speaks Nigerian pidgin, using Nigerian pidgin spelling and grammar",
          ),
        ],
      ),
    );
  }
}
