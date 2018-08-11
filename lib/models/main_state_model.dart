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

///主数据模型，需要全局使用的数据在这里添加模型
class MainStateModel extends Model
    with BaseModel, IndexScreenStateModel, BasicScreenStateModel //, AModel
{
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
  static final List<BottomNavigationItem> basicLocalNavItems = [
    BottomNavigationItem(icon: Icon(Icons.forum), text: "社区"),
    BottomNavigationItem(icon: Icon(Icons.account_circle), text: "用户"),
  ];

  ///当前选中的索引
  int get basicCurrentSelNav => _currentSelNav;

  int get basicNavItemCount =>
      basicScreenNavItems.length + basicLocalNavItems.length;

  set basicCurrentSelNav(int i) {
    _currentSelNav = i.clamp(0, basicNavItemCount - 1);
    notifyListeners();
  }

  ///当前页面的标题文字
  String get basicCurrentTitleString {
    return _currentSelNav < basicScreenNavItems.length
        ? basicScreenNavItems[_currentSelNav]['name']
        : basicLocalNavItems[_currentSelNav - basicScreenNavItems.length]?.text;
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

///继承自BaseModel的 类
class AModel extends BaseModel {
  ///变量命名规范
  double amodelXXX = 0.0;
}
