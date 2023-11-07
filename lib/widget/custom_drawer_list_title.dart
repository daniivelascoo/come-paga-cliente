import 'package:flutter/material.dart';

class CustomDrawerListTitle extends StatelessWidget {
  final void Function() onTap;
  final String label;
  final IconData icon;

  const CustomDrawerListTitle(
      {super.key,
      required this.onTap,
      required this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 30),
      splashColor: Colors.red,
    );
  }
}
