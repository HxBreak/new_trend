import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// enum MainScreenPage {
//   INDEX,
//   NEWS,
//   GROUP,
//   PROFILE,
// }

class MainStateModel extends Model
    with BaseModel, IndexScreenStateModel, BasicScreenStateModel {
  MainStateModel() {
    initApp();
  }
}

class BaseModel extends Model {}

abstract class IndexScreenStateModel extends BaseModel {}

abstract class BasicScreenStateModel extends BaseModel {
  CommonPageStatus basicScreenStatus = CommonPageStatus.READY;
  List basicScreenNavItems = [];
  int _currentSelNav = 0;
  static const List<BottomNavigationItem> basicLocalNavItems = const [
    // BottomNavigationItem(icon: Icon(Icons.forum), title: "社区"),
    // BottomNavigationBarItem(
    //     icon: Icon(Icons.account_circle), title: Text("用户")),
  ];
  int get basicCurrentSelNav => _currentSelNav;

  int get basicNavItemCount =>
      basicScreenNavItems.length + basicLocalNavItems.length;

  set basicCurrentSelNav(int i) {
    _currentSelNav = i.clamp(0, basicNavItemCount - 1);
    notifyListeners();
  }

  String get basicCurrentTitleString {
    return _currentSelNav < basicScreenNavItems.length
        ? basicScreenNavItems[_currentSelNav]['name']
        : "$basicNavItemCount";
  }

  Future initApp() {
    basicScreenStatus = CommonPageStatus.RUNNING;
    notifyListeners();
    return read(Constant.APP_INIT).then(json.decode).then((resp) {
      basicScreenNavItems = resp['BottomBarItem'];
      basicScreenStatus = CommonPageStatus.DONE;
    }).catchError((o) {
      print(o);
      basicScreenStatus = CommonPageStatus.ERROR;
    }).whenComplete(this.notifyListeners);
  }
}
