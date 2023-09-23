import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class SelectLanguageTab extends StatefulWidget {
  const SelectLanguageTab({
    super.key,
  });

  @override
  State<SelectLanguageTab> createState() => _SelectLanguageTabState();
}

class _SelectLanguageTabState extends State<SelectLanguageTab> {
  String? selection;

  @override
  void initState() {
    selection = context.read<CreateBotViewmodel>().language;
    super.initState();
  }

  void setSelection(String? value) {
    setState(() {
      context.read<CreateBotViewmodel>().language = value;
      selection = value;
    });
  }

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
          CustomRadioButton<String?>(
            value: "english",
            groupValue: selection,
            onChanged: (String? value) {
              setSelection(value);
            },
            text: "English",
            subText:
                "The AI assistant speaks English, using American English spelling and grammar",
          ),
          CustomRadioButton<String?>(
            value: "nigerian pidgin",
            groupValue: selection,
            onChanged: (String? value) {
              setSelection(value);
            },
            text: "Nigerian pidgin",
            subText:
                "The AI assistant speaks Nigerian pidgin, using Nigerian pidgin spelling and grammar",
          ),
        ],
      ),
    );
  }
}
