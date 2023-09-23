// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/dialogs.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../providers/create_bot_viewmodel.dart';
import 'tabs/pick_name_tab.dart';
import 'tabs/select_interests_tab.dart';
import 'tabs/select_language_tab.dart';
import 'tabs/select_traits_tab.dart';
import 'tabs/select_usefullness_tab.dart';
import 'widgets/progress_indicator.dart';

class CreateBotView extends StatefulWidget {
  const CreateBotView({super.key});

  @override
  State<CreateBotView> createState() => _CreateBotViewState();
}

class _CreateBotViewState extends State<CreateBotView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<CreateBotViewmodel>().reset();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateBotViewmodel>(builder: (context, viewmodel, _) {
      return AppScaffold(
        isLoading: viewmodel.loading,
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
                progress: viewmodel.completionPercentage,
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
                  child: viewmodel.step == CreateAssistantStep.name
                      ? const PickNameTab()
                      : viewmodel.step == CreateAssistantStep.usefulness
                          ? const SelectUsefullnessTab()
                          : viewmodel.step == CreateAssistantStep.trait
                              ? const SelectTraitTab()
                              : viewmodel.step == CreateAssistantStep.language
                                  ? const SelectLanguageTab()
                                  : viewmodel.step ==
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
                    onPressed: () async {
                      try {
                        if (viewmodel.canGoToNextStep) {
                          if (viewmodel.isLastStep) {
                            await context
                                .read<CreateBotViewmodel>()
                                .createBot();
                            await showInfoDialog(
                              context: context,
                              title: "Assistant Created",
                              message: "Your assistant has been created.",
                            );
                            Navigator.of(context).pop();
                          } else {
                            context.read<CreateBotViewmodel>().nextStep();
                          }
                        }
                      } on DomainException catch (e) {
                        showToast(context, e.message);
                      } catch (_) {
                        showUnexpectedErrorToast(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          viewmodel.canGoToNextStep ? Colors.blue : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      viewmodel.isLastStep ? "Create Assistant" : "Next Step",
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
