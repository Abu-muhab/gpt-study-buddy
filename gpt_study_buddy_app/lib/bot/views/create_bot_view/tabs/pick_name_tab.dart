import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/views/create_bot_view/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:provider/provider.dart';

class PickNameTab extends StatefulWidget {
  const PickNameTab({
    super.key,
  });

  @override
  State<PickNameTab> createState() => _PickNameTabState();
}

class _PickNameTabState extends State<PickNameTab> {
  late final TextEditingController _nameController;
  late final CreateBotViewmodel viewmodel;

  @override
  void initState() {
    viewmodel = context.read<CreateBotViewmodel>();
    _nameController = TextEditingController(text: viewmodel.name);
    super.initState();
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
            "Pick a name for your assistant",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _nameController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            onChanged: (value) {
              context.read<CreateBotViewmodel>().name = value;
            },
          ),
        ],
      ),
    );
  }
}
