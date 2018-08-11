import 'package:scoped_model/scoped_model.dart';
import 'models.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class SimplePageDataModel {
  final start = DateTime.now().subtract(Duration(days: 1));
  List networkData = [];
  CommonPageStatus currentStatus = CommonPageStatus.READY;
}

abstract class BasicScreenStateModel extends BaseModel {
  CommonPageStatus basicScreenStatus = CommonPageStatus.READY;
  List basicScreenNavItems = [];
  int _currentSelNav = 0;
  Completer<Null> basicInited = Completer();
  Map<String, SimplePageDataModel> basicScreenData = Map();
  static final List<BottomNavigationItem> basicLocalNavItems = [
    BottomNavigationItem(icon: Icon(Icons.forum), text: "社区"),
    BottomNavigationItem(icon: Icon(Icons.account_circle), text: "用户"),
  ];

  SimplePageDataModel basicGetCurrentData(String url, int index) {
    return basicScreenData['$url-$index'] ?? SimplePageDataModel();
  }

  void _basicSetCurrentData(String url, int index, SimplePageDataModel data) {
    basicScreenData['$url-$index'] = data;
  }

  Future basicCurrentLoadMoreData(String url, int index) {
    final data = basicGetCurrentData(url, index);
    _basicSetCurrentData(url, index, data);
    data.currentStatus = CommonPageStatus.RUNNING;
    notifyListeners();
    final formator = DateFormat("yyyy-MM-dd");
    print("$url" + "?crawltime=${formator.format(data.start)}");
    return http
        .read("$url" + "?crawltime=${formator.format(data.start)}")
        .then(json.decode)
        .then((resp) {
      data.networkData.addAll(resp['data']);
      if (resp['data'].length == 0) {
        data.currentStatus = CommonPageStatus.DONE;
      } else {
        data.start.subtract(Duration(days: 1)); //往上调整一天，暂时没有数据支撑
        data.currentStatus = CommonPageStatus.READY;
      }
    }).catchError(() {
      data.currentStatus = CommonPageStatus.ERROR;
    }).whenComplete(this.notifyListeners);
  }

  ///当前选中的索引
  int get basicCurrentSelNav => _currentSelNav;

  int get basicNavItemCount =>
      basicScreenNavItems.length + basicLocalNavItems.length;

  String get basicCurrentScrType =>
      "${basicScreenNavItems[basicCurrentSelNav]['pageType']}".toLowerCase();

  bool get basicCurrentHasTabbar =>
      basicIsCurrentPageFromNetwork && basicCurrentScrType == 'tabs';

  set basicCurrentSelNav(int i) {
    _currentSelNav = i.clamp(0, basicNavItemCount - 1);
    notifyListeners();
  }

  bool get basicIsCurrentPageFromNetwork =>
      basicCurrentSelNav < basicScreenNavItems.length;

  ///当前页面的标题文字
  String get basicCurrentTitleString {
    return _currentSelNav < basicScreenNavItems.length
        ? basicScreenNavItems[_currentSelNav]['name']
        : basicLocalNavItems[_currentSelNav - basicScreenNavItems.length]?.text;
  }

  Future initApp() {
    basicScreenStatus = CommonPageStatus.RUNNING;
    notifyListeners();
    return http.read(Constant.APP_INIT).then(json.decode).then((resp) {
      basicScreenNavItems = resp['BottomBarItem'];
      basicScreenStatus = CommonPageStatus.DONE;
      basicInited.complete(null);
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
