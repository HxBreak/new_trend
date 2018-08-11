import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:new_trend/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'package:new_trend/models/models.dart';
import 'dart:convert';

void main() => runApp(new TrendApp());

class TrendApp extends StatelessWidget {
  final model = MainStateModel();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'New Trend',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ScopedModel<MainStateModel>(
        model: model,
        child: new MainScreen(),
      ),
      routes: {
        "login": (context) => LoginScreen(),
        "register": (context) => RegisterScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, BasicScreenStateModel state) {
        return Scaffold(
            appBar: state.basicScreenStatus == CommonPageStatus.DONE
                ? AppBar(
                    title: Text("${state.basicCurrentTitleString}"),
                  )
                : null,
            bottomNavigationBar:
                state.basicScreenStatus == CommonPageStatus.DONE
                    ? BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        fixedColor: Theme.of(context).primaryColor,
                        currentIndex: state.basicCurrentSelNav,
                        onTap: (i) => state.basicCurrentSelNav = i,
                        items: state.basicScreenNavItems
                            .map((e) => BottomNavigationBarItem(
                                icon: Icon(Icons.swap_calls),
                                title: Text("${e['name']}")))
                            .toList()
                              ..addAll(BasicScreenStateModel.basicLocalNavItems
                                  .map((e) => BottomNavigationBarItem(
                                      icon: Icon(Icons.table_chart),
                                      title: Text("data")))
                                  .toList()),
                      )
                    : null);
      },
    );
  }
}

// class BottomNavigationBarItemNetwork {
//   final String name;
//   final String iconUrl;
//   final String entityUrl;
//   final int urlType; //保留字段，标识此Url的处理类型，有无子Tab之类的
// }

// class TabBarItemNetwork {
//   final String name;
//   final String optIconUrl;
//   final String bodyUrl;
//   final int urlType; //保留字段，标识此Url的处理类型，有无子Tab之类的
// }
