import 'package:flutter/material.dart';

enum CreateAssistantStep { name, usefulness, trait, language, interests }

class CreateBotViewmodel extends ChangeNotifier {
  int _stepIndex = 0;
  CreateAssistantStep get step => CreateAssistantStep.values[_stepIndex];

  String _name = '';
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  double get completionPercentage {
    return (_stepIndex + 1) / CreateAssistantStep.values.length;
  }

  bool get isLastStep => _stepIndex == CreateAssistantStep.values.length - 1;

  bool nextStep() {
    if (_stepIndex < CreateAssistantStep.values.length - 1) {
      _stepIndex++;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool previousStep() {
    if (_stepIndex > 0) {
      _stepIndex--;
      notifyListeners();
      return true;
    }

    return false;
  }
}
