import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/providers/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/widgets/custom_radio_button.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:provider/provider.dart';

class SelectUsefullnessTab extends StatefulWidget {
  const SelectUsefullnessTab({
    super.key,
  });

  @override
  State<SelectUsefullnessTab> createState() => _SelectUsefullnessTabState();
}

class _SelectUsefullnessTabState extends State<SelectUsefullnessTab> {
  String? selection;

  @override
  void initState() {
    selection = context.read<CreateBotViewmodel>().helfulness;
    super.initState();
  }

  void setSelection(String? value) {
    setState(() {
      context.read<CreateBotViewmodel>().helfulness = value;
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
          CustomRadioButton<String?>(
            value: "helpful",
            groupValue: selection,
            onChanged: (value) {
              setSelection(value);
            },
            text: "Helpful",
          ),
          CustomRadioButton<String?>(
            value: "sometimes helpful",
            groupValue: selection,
            onChanged: (value) {
              setSelection(value);
            },
            text: "Sometimes helpful",
          ),
          CustomRadioButton<String?>(
            value: "painfully useless",
            groupValue: selection,
            onChanged: (value) {
              setSelection(value);
            },
            text: "Painfully useless",
          ),
        ],
      ),
    );
  }
}
