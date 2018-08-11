import 'package:flutter/material.dart';

enum CommonPageStatus { READY, RUNNING, DONE, ERROR }

class BottomNavigationItem {
  final String text;
  final Widget icon;
  final BottomNavigationBarItem item;

  const BottomNavigationItem(String text, Widget icon)
      : text = text,
        icon = icon;
  // item = const BottomNavigationBarItem(title: Text(text), icon: icon);
}
