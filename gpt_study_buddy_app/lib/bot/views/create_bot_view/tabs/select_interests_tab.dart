import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';

import '../../../../main.dart';

class SelectInterestsTab extends StatelessWidget {
  const SelectInterestsTab({
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
            "You want your assistant to be interested in...",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomCheckBox(
            value: false,
            onChanged: (bool? value) {},
            text: "Art",
          ),
          CustomCheckBox(
            value: false,
            onChanged: (bool? value) {},
            text: "Movies",
          ),
          CustomCheckBox(
            value: false,
            onChanged: (bool? value) {},
            text: "Music",
          ),
          CustomCheckBox(
            value: false,
            onChanged: (bool? value) {},
            text: "Sports",
          ),
          CustomCheckBox(
            value: false,
            onChanged: (bool? value) {},
            text: "Books",
          ),
        ],
      ),
    );
  }
}
