import 'package:flutter/material.dart';

class CustomHomeOption extends StatelessWidget {
  final Image optionImage;
  final String route;
  final Object args;

  const CustomHomeOption(
      {super.key,
      required this.optionImage,
      required this.route,
      required this.args});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ClipOval(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, route, arguments: args);
          },
          child: FittedBox(
            child: optionImage,
          ),
        ),
      ),
    );
  }
}
