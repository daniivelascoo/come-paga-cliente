import 'package:flutter/material.dart';

class ResumeField extends StatelessWidget {
  final IconData icon;
  final String text;

  const ResumeField({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black,),
        Text(text, style: const TextStyle(color: Colors.black),)
      ],
    );
  }
}
