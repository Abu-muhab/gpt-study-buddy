import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class SelectInterestsTab extends StatefulWidget {
  const SelectInterestsTab({
    super.key,
  });

  @override
  State<SelectInterestsTab> createState() => _SelectInterestsTabState();
}

class _SelectInterestsTabState extends State<SelectInterestsTab> {
  List<String>? interests;

  @override
  void initState() {
    interests = context.read<CreateBotViewmodel>().interests;
    super.initState();
  }

  void toggleSelection(String? value) {
    setState(() {
      if (interests!.contains(value)) {
        interests!.remove(value);
      } else {
        interests!.add(value!);
      }
      context.read<CreateBotViewmodel>().interests = interests!;
    });
  }

  List<String> interestsList = [
    "Art",
    "Movies",
    "Music",
    "Sports",
    "Books",
  ];

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
          ...interestsList.map(
            (interest) => CustomCheckBox(
              value: interests!.contains(interest),
              onChanged: (bool? value) {
                toggleSelection(interest);
              },
              text: interest,
            ),
          ),
        ],
      ),
    );
  }
}
