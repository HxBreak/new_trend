import 'package:flutter/material.dart';

enum CommonPageStatus { READY, RUNNING, DONE, ERROR }

class BottomNavigationItem {
  final String text;
  final Widget icon;
  final BottomNavigationBarItem item;

  BottomNavigationItem({@required String text, @required Widget icon})
      : text = text,
        icon = icon,
        item = BottomNavigationBarItem(title: Text(text), icon: icon);
}
