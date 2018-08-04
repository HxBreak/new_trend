import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:new_trend/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'New Trend',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MainScreen(),
    );
  }
}

enum MainScreenPage {
  INDEX,
  NEWS,
  GROUP,
  PROFILE,
}

class MainScreenStateModel extends Model {
  MainScreenPage mainScreenPage = MainScreenPage.INDEX;
  int currentIndex = 0;
  List<String> tabs;

  changePage(int i) {
    currentIndex = i.clamp(0, 3);
    if (currentIndex == 0) {
      mainScreenPage = MainScreenPage.INDEX;
    } else if (currentIndex == 1) {
      mainScreenPage = MainScreenPage.NEWS;
    } else if (currentIndex == 2) {
      mainScreenPage = MainScreenPage.GROUP;
    } else if (currentIndex == 3) {
      mainScreenPage = MainScreenPage.PROFILE;
    }
    notifyListeners();
  }
}

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _index_controller;
  List<String> tabs;

  @override
  void initState() {
    super.initState();
    http
        .read("http://www.dashixiuxiu.cn/app_init")
        .then(json.decode)
        .then((resp) {
      _index_controller =
          TabController(length: resp['Tab'].length, vsync: this);
      tabs = List.castFrom<dynamic, String>(resp['Tab']);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainScreenStateModel>(
      model: MainScreenStateModel(),
      child: new ScopedModelDescendant<MainScreenStateModel>(
        builder: (context, widget, state) {
          return Scaffold(
            appBar: state.mainScreenPage == MainScreenPage.INDEX
                ? buildIndexAppbar(controller: _index_controller, tabs: tabs)
                : AppBar(
                    title: Text("Not Complete..."),
                  ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: state.currentIndex,
              onTap: state.changePage,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.place), title: Text("data")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.place), title: Text("data")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.place), title: Text("data")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.place), title: Text("data")),
              ],
            ),
          );
        },
      ),
    );
  }
}
