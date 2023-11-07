import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:comepaga/utils/field_validator.dart';
import 'package:comepaga/widget/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalData extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formValues;

  const PersonalData(
      {super.key, required this.formKey, required this.formValues});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    if (widget.formValues[Constants.fechaNacimientoKey] == null) {
      dateinput.text = DateFormat(Constants.defaultDateFormat)
          .format(DateTime.now().subtract(const Duration(days: 6574)));
      widget.formValues[Constants.fechaNacimientoKey] = dateinput.text;
    } else {
      dateinput.text = widget.formValues[Constants.fechaNacimientoKey]!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 45 / 100,
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 10 / 100,
          left: MediaQuery.of(context).size.width * 10 / 100),
      child: Form(
          key: widget.formKey,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 20 / 100,
                child: Expanded(
                    child: CustomInputField(
                  hintText: 'Name',
                  formvalues: widget.formValues,
                  hasNext: true,
                  isRequired: true,
                  jsonKey: Constants.nombreKey,
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 20 / 100,
                child: Expanded(
                    child: CustomInputField(
                  hintText: 'Surname',
                  formvalues: widget.formValues,
                  hasNext: true,
                  isRequired: true,
                  jsonKey: Constants.primerApellidoKey,
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 20 / 100,
                child: Expanded(
                    child: CustomInputField(
                  hintText: 'Second Surname',
                  formvalues: widget.formValues,
                  hasNext: true,
                  jsonKey: Constants.segundoApellidoKey,
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 20 / 100,
                child: Expanded(
                    child: TextFormField(
                  readOnly: true,
                  controller: dateinput,
                  validator: FieldValidator.userDateValidator,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 0, 0),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppTheme
                                    .primaryColor, // establece el color primario
                                onPrimary: Colors
                                    .white, // establece el color del texto del botón
                              ),
                              dialogBackgroundColor: Colors
                                  .white, // establece el color de fondo del diálogo
                            ),
                            child: child ?? const SizedBox.shrink(),
                          );
                        },
                        context: context,
                        initialDate:
                            widget.formValues[Constants.fechaNacimientoKey] ==
                                    null
                                ? DateTime.now()
                                    .subtract(const Duration(days: 6574))
                                : DateTime.parse(widget
                                    .formValues[Constants.fechaNacimientoKey]!),
                        lastDate:
                            DateTime.now().add(const Duration(days: 29950)),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 29950)));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat(Constants.defaultDateFormat)
                              .format(pickedDate);
                      widget.formValues[Constants.fechaNacimientoKey] =
                          formattedDate;

                      setState(() {
                        dateinput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                )),
              )
            ],
          )),
    );
  }
}
