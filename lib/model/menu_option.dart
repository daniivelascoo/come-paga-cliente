import 'package:flutter/material.dart';

class MenuOption {
  
  final String route;
  final Widget? icon;
  final String name;
  final Widget screen;

  MenuOption({
    this.icon,
    required this.route, 
    required this.name, 
    required this.screen});
}
