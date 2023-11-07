import 'package:comepaga/exception/internal_exception.dart';
import 'package:comepaga/model/user/cliente.dart';
import 'package:comepaga/service/call_service.dart';

import '../model/user/usuario.dart';

class FieldValidator {
  static String? emptyValidation(String? value) => null;

  static String? phoneNumberValidation(String? value) {
    if (value?.length != 9) {
      return 'Incorrect format';
    }

    return null;
  }

  static String? emailValidation(String? value) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value!)) {
      return 'Incorrect format';
    }

    return null;
  }

  static Future<String?> userNameValidation(String? value) async {
    CallService<Usuario> call =
        CallService<Usuario>(uri: 'usuario', fromJson: Cliente.fromJson);
    Usuario? u = await call.get({}, '/$value');

    if (u == null) {
      return null;
    }

    return 'Username in use';
  }

  static String? passwordValidator(String? value) {
    RegExp regExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!+@#$&*~]).{8,}$',
    );

    if (!regExp.hasMatch(value!)) {
      return 'Unfulfilled requirements';
    }

    return null;
  }

  static String? repeatPasswordValidator(String? value) {
    List<String> pssws = value!.split(' ');

    if (pssws.length < 2) {
      throw InternalException(
          'Only one password provided in FieldValidator.repeatPasswordValidator()');
    } else if (pssws.length != 2) {
      throw InternalException(
          'Bad password provided in FieldValidator.repeatPasswordValidator()');
    }

    if (pssws[0] != pssws[1]) {
      return 'Repetición incorrecta';
    }

    return null;
  }

  static String? userDateValidator(String? value) {
    DateTime date = DateTime.parse(value!);
    DateTime requiredDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    Duration difference = requiredDate.difference(date);
    int age = (difference.inDays / 365).floor();

    if (age >= 18) {
      return null;
    }

    return "It's required to be of legal age";
  }

  static String? requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }

    return null;
  }
}
