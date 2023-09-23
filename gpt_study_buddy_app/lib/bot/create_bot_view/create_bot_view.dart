import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/pick_name_tab.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/select_interests_tab.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/select_language_tab.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/select_traits_tab.dart';
import 'package:gpt_study_buddy/bot/create_bot_view/select_usefullness_tab.dart';
import 'package:gpt_study_buddy/bot/progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'create_bot_viewmodel.dart';

class CreateAssistantView extends StatefulWidget {
  const CreateAssistantView({super.key});

  @override
  State<CreateAssistantView> createState() => _CreateAssistantViewState();
}

class _CreateAssistantViewState extends State<CreateAssistantView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateBotViewmodel>(builder: (context, controller, _) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (!context.read<CreateBotViewmodel>().previousStep()) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.chevron_left, size: 40),
            ),
            title: const Text('Create Assistant'),
            centerTitle: false,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: AnimatedLinearProgressIndicator(
                progress: controller.completionPercentage,
              ),
            )),
        body: Container(
          width: double.infinity,
          color: primaryColor[100],
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: controller.step == CreateAssistantStep.name
                      ? const PickNameTab()
                      : controller.step == CreateAssistantStep.usefulness
                          ? const SelectUsefullnessTab()
                          : controller.step == CreateAssistantStep.trait
                              ? const SelectTraitTab()
                              : controller.step == CreateAssistantStep.language
                                  ? const SelectLanguageTab()
                                  : controller.step ==
                                          CreateAssistantStep.interests
                                      ? const SelectInterestsTab()
                                      : const SizedBox(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CreateBotViewmodel>().nextStep();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      controller.isLastStep ? "Create Assistant" : "Next Step",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    });
  }
}
