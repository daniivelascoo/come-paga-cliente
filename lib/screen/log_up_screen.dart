import 'package:comepaga/exception/waiting_exception.dart';
import 'package:comepaga/screen/log_up_resume_screen.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/field_validator.dart';
import 'package:comepaga/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';

import '../model/menu_option.dart';
import '../utils/constants.dart';
import '../widget/userdata/contact_data.dart';
import '../widget/userdata/personal_data.dart';
import '../widget/userdata/user_data.dart';

class LogUpScreen extends StatefulWidget {
  final Map<String, String?> initformvalues;

  const LogUpScreen({
    super.key,
    this.initformvalues = const {},
  });

  @override
  State<LogUpScreen> createState() => _LogUpScreenState();
}

class _LogUpScreenState extends State<LogUpScreen> {
  int dataPart = 0;
  Map<String, dynamic> formvalues = {};
  bool firstbuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstbuild) {
      if (widget.initformvalues.isNotEmpty) {
        formvalues = widget.initformvalues;
        firstbuild = false;
      }
    }

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final userDataRoutes = <MenuOption>[
      MenuOption(
          route: 'personal_data',
          name: 'Personal data',
          screen: PersonalData(
            formKey: formkey,
            formValues: formvalues,
          )),
      MenuOption(
          route: 'contact_data',
          name: 'Datos de contacto',
          screen: ContactData(
            formKey: formkey,
            formValues: formvalues,
          )),
      MenuOption(
          route: 'user_data',
          name: 'User data',
          screen: UserData(formKey: formkey, formValues: formvalues))
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/ComeYPaga.png'),
              userDataRoutes[dataPart].screen,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (dataPart == 0) {
                            Navigator.pop(context);
                            return;
                          }
                          dataPart--;
                        });
                      },
                      child: const SizedBox(
                        child: Text(
                          Constants.previous,
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      )),
                  TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      try {
                        if (!formkey.currentState!.validate()) {
                          final validationError = CustomSnackBar(
                            content: const Text(
                              'Errors have been found in the form!',
                              style: TextStyle(color: AppTheme.primaryColor),
                            ),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(validationError.build());
                          return;
                        }
                      } on WaitingException {
                        return;
                      }

                      setState(() {
                        if (dataPart != userDataRoutes.length - 1) {
                          dataPart++;
                        } else {
                          if (formvalues[Constants.passwordKey] !=
                              formvalues['repeat_password']) {
                            final validationError = CustomSnackBar(
                              content: const Text(
                                'Passwords are not the same',
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(validationError.build());
                            return;
                          }

                          FieldValidator.userNameValidation(
                                  formvalues[Constants.nombreUsuarioKey])
                              .then((value) {
                            if (value == null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LogUpResumeScreen(
                                      formvalues: formvalues)));
                            } else {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: ((context) => AlertDialog(
                                        content: Text(
                                            '$value. Please try with another.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ))
                                        ],
                                      )));
                            }
                          });
                        }
                      });
                    },
                    child: Row(children: [
                      Text(
                        dataPart == userDataRoutes.length - 1
                            ? Constants.ok
                            : Constants.next,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      )
                    ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
