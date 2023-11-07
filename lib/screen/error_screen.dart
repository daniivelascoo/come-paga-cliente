import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, 'login');
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            )),
      );
    });

    return Scaffold(
      body: GestureDetector(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          child: Image.asset('assets/ComeYPaga.png'),
        ),
      ),
    );
  }
}
