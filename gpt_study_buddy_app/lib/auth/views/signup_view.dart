import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_study_buddy/auth/auth_service_provider.dart';
import 'package:gpt_study_buddy/auth/data/dtos.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/app_validators.dart';
import 'package:gpt_study_buddy/common/dialogs.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/main.dart';
import 'package:gpt_study_buddy/navigation/app_views.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const formElementsColor = Colors.blueGrey;
    return Consumer<AuthServiceProvider>(
      builder: (context, authProvider, _) {
        return AppScaffold(
          isLoading: authProvider.isLoading,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Container(
                color: primaryColor, // Change the background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          fillColor:
                              formElementsColor, // Lighter background color
                          filled: true,
                        ),
                        validator: AppValidators.requiredString(
                            'Please enter your email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                fillColor:
                                    formElementsColor, // Lighter background color
                                filled: true,
                              ),
                              validator: AppValidators.requiredString(
                                  'Please enter your first name'),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                fillColor:
                                    formElementsColor, // Lighter background color
                                filled: true,
                              ),
                              validator: AppValidators.requiredString(
                                  'Please enter your last name'),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          fillColor:
                              formElementsColor, // Lighter background color
                          filled: true,
                        ),
                        validator: AppValidators.requiredString(
                            'Please enter your password'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: true,
                      ),
                      const SizedBox(height: 48.0), // Increased button height
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: formElementsColor,
                          minimumSize:
                              const Size(200, 50), // Button width and height
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await authProvider.signup(
                                SignupRequest(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                ),
                              );
                            } on DomainException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                ),
                              );
                            } catch (_) {
                              showUnexpectedErrorToast(context);
                            }
                          }
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor[100]),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          context.go(AppViews.login);
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
