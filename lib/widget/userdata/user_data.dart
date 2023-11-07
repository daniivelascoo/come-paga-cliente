import 'package:comepaga/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../utils/field_validator.dart';
import '../custom_input_field.dart';

class UserData extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formValues;

  const UserData({super.key, required this.formKey, required this.formValues});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 45 / 100,
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 10 / 100,
          left: MediaQuery.of(context).size.width * 10 / 100),
      child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 25 / 100,
                child: Expanded(
                    child: CustomInputField(
                  hintText: 'Username',
                  jsonKey: Constants.nombreUsuarioKey,
                  formvalues: formValues,
                  hasNext: true,
                  isRequired: true,
                  validateMode: AutovalidateMode.disabled,
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 25 / 100,
                child: Expanded(
                    child: CustomInputField(
                  hintText: 'Password',
                  formvalues: formValues,
                  jsonKey: Constants.passwordKey,
                  helperText:
                      r'Must contain at least one capital letter, one special character (!+@#\$&*~), one number, and a minimum of 8 characters.',
                  obscureText: true,
                  hasNext: true,
                  validator: FieldValidator.passwordValidator,
                  textInputType: TextInputType.visiblePassword,
                  isRequired: true,
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 25 / 100,
                child: Expanded(
                    child: CustomInputField(
                  hintText: 'Repeat Password',
                  obscureText: true,
                  formvalues: formValues,
                  isRequired: true,
                  jsonKey: 'repeat_password',
                )),
              ),
            ],
          )),
    );
  }
}
