import 'package:comepaga/utils/constants.dart';
import 'package:comepaga/utils/field_validator.dart';
import 'package:comepaga/widget/custom_input_field.dart';
import 'package:flutter/material.dart';

class ContactData extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formValues;

  const ContactData(
      {super.key, required this.formKey, required this.formValues});

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
                child: Row(
                  children: [
                    Expanded(
                        child: CustomInputField(
                      hintText: 'Address',
                      formvalues: formValues,
                      hasNext: true,
                      isRequired: true,
                      jsonKey: Constants.direccionKey,
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 5 / 100),
                      child: CustomInputField(
                        hintText: 'Location',
                        formvalues: formValues,
                        hasNext: true,
                        isRequired: true,
                        jsonKey: Constants.localizacionKey,
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 25 / 100,
                child: Expanded(
                        child: CustomInputField(
                      hintText: 'Phone number',
                      formvalues: formValues,
                      hasNext: true,
                      validator: FieldValidator.phoneNumberValidation,
                      textInputType: TextInputType.phone,
                      isRequired: true,
                      jsonKey: Constants.numeroTelefonoKey,
                    )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 25 / 100,
                child: Expanded(
                        child: CustomInputField(
                      hintText: 'E-mail',
                      formvalues: formValues,
                      validator: FieldValidator.emailValidation,
                      textInputType: TextInputType.emailAddress,
                      isRequired: true,
                      jsonKey: Constants.correoKey,
                    )),
              ),
            ],
          )),
    );
  }
}
