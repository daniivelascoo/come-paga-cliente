import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:comepaga/widget/login_actions.dart';
import 'package:comepaga/widget/login_title.dart';
import 'package:flutter/material.dart';
import 'package:comepaga/widget/custom_input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final Map<String, String?> formvalues = {};

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: LoginTitle(),
              ),
              Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset('assets/ComeYPaga.png',
                      opacity: const AlwaysStoppedAnimation(.2)),
                  Padding(
                    padding: const EdgeInsets.only(right: 40, left: 40),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          CustomInputField(
                            icon: Icons.person,
                            hintText: 'Username',
                            formvalues: formvalues,
                            hasNext: true,
                            jsonKey: Constants.nombreUsuarioKey,
                            isRequired: true,
                          ),
                          CustomInputField(
                            icon: Icons.lock,
                            obscureText: true,
                            hintText: 'Password',
                            formvalues: formvalues,
                            jsonKey: Constants.passwordKey,
                            isRequired: true,
                          ),
                          LoginActions(formvalues: formvalues, formkey: formkey)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
