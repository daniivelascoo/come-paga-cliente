import 'package:comepaga/utils/field_validator.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final String? Function(String? value) validator;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? textInputType;
  final bool obscureText;
  final Map<String, dynamic> formvalues;
  final bool hasNext;
  final bool isRequired;
  final String jsonKey;
  final AutovalidateMode validateMode;
  final Function()? setState;
  final TextEditingController? controller;
  final bool autofocus;
  final bool enabled;

  const CustomInputField(
      {Key? key,
      required this.hintText,
      required this.jsonKey,
      this.autofocus = false,
      this.controller,
      this.setState,
      this.labelText,
      this.helperText,
      this.enabled = true,
      this.icon,
      this.suffixIcon,
      this.textInputType,
      this.obscureText = false,
      this.validator = FieldValidator.emptyValidation,
      this.hasNext = false,
      this.validateMode = AutovalidateMode.onUserInteraction,
      required this.formvalues,
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: TextFormField(
        enabled: enabled,
        autofocus: autofocus,
        controller: controller,
        textInputAction: hasNext ? TextInputAction.next : TextInputAction.done,
        initialValue: labelText ?? (formvalues[jsonKey]),
        keyboardType: textInputType,
        obscureText: obscureText,
        textCapitalization: TextCapitalization.words,
        validator: validator == FieldValidator.emptyValidation
            ? (isRequired
                ? FieldValidator.requiredFieldValidator
                : FieldValidator.emptyValidation)
            : validator,
        autovalidateMode: validateMode,
        onChanged: (value) {
          formvalues[jsonKey] = value;
          if (setState != null) setState!();
        },
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          iconColor: Colors.black,
          hintStyle: const TextStyle(color: Colors.black),
          hintText: isRequired ? '$hintText *' : hintText,
          labelText: labelText,
          helperText: helperText,
          helperMaxLines: 3,
          suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
          icon: icon == null ? null : Icon(icon),
        ),
      ),
    );
  }
}
