import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:provider/provider.dart';

class SelectTraitTab extends StatefulWidget {
  const SelectTraitTab({
    super.key,
  });

  @override
  State<SelectTraitTab> createState() => _SelectTraitTabState();
}

class _SelectTraitTabState extends State<SelectTraitTab> {
  String? selection;

  @override
  void initState() {
    selection = context.read<CreateBotViewmodel>().trait;
    super.initState();
  }

  void setSelection(String? value) {
    setState(() {
      context.read<CreateBotViewmodel>().trait = value;
      selection = value;
    });
  }

  List<Map<String, dynamic>> traits = [
    {
      "text": "Professional",
      "subText":
          "The AI assistant speaks in a formal and respectful tone, using appropriate titles and language in business and work-related contexts.",
    },
    {
      "text": "Witty",
      "subText":
          "The AI assistant has a quick and clever sense of humor, using puns, jokes, and pop culture references to entertain and engage the user",
    },
    {
      "text": "Informative",
      "subText":
          "The AI assistant has a serious and informative personality, providing detailed and accurate information on a variety of topics",
    },
    {
      "text": "Supportive",
      "subText":
          "The AI assistant has a nurturing and empathetic personality, providing encouragement and emotional support to the user.",
    },
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
          ...traits.map(
            (trait) => CustomRadioButton<String?>(
              value: trait["text"],
              groupValue: selection,
              onChanged: (String? value) {
                setSelection(value);
              },
              text: trait["text"],
              subText: trait["subText"],
            ),
          ),
        ],
      ),
    );
  }
}
