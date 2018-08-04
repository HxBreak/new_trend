import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:new_trend/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'package:new_trend/models/models.dart';
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
      home: ScopedModel<MainScreenStateModel>(
        model: MainScreenStateModel(),
        child: new MainScreen(),
      ),
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
  List<dynamic> tabs;
  Map<String, List> index_data = Map();

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

  addIndexData(String key, List items) {
    index_data.putIfAbsent(key, () => items);
    notifyListeners();
  }
}

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController _index_controller;

  @override
  void initState() {
    super.initState();

    _page_change() {
      final model = ModelFinder<MainScreenStateModel>().of(context);
      final key = model.tabs[_index_controller.index]['name'];
      final has = model.index_data.containsKey(key);
      if (has) {
        final data = model.index_data[key];
        if (data.length < 1) {}
      } else {
        http
            .read(
                "http://www.dashixiuxiu.cn/query_cointelegraph?crawltime=2018-07-28")
            .then(json.decode)
            .then((resp) {
          final List<NewsItem> d =
              resp['data'].map<NewsItem>((e) => NewsItem(e)).toList();
          model.addIndexData(key, d);
        });
      }
    }

    http
        .read("http://www.dashixiuxiu.cn/app_init")
        .then(json.decode)
        .then((resp) {
      _index_controller =
          TabController(length: resp['Tab'].length, vsync: this);
      final model = ModelFinder<MainScreenStateModel>().of(context);
      model.tabs = resp['Tab'];
      _index_controller.addListener(_page_change);
      _page_change();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _index_controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainScreenStateModel>(
      builder: (context, widget, state) {
        return Scaffold(
          appBar: state.mainScreenPage == MainScreenPage.INDEX
              ? buildIndexAppbar(
                  controller: _index_controller, tabs: state.tabs)
              : state.mainScreenPage == MainScreenPage.PROFILE
                  ? AppBar(title: Text("Profile"))
                  : AppBar(title: Text('Not Complete...')),
          body: state.mainScreenPage == MainScreenPage.INDEX
              ? _index_controller == null || state.tabs == null
                  ? Container()
                  : TabBarView(
                      controller: _index_controller,
                      children: state.tabs
                          .map<Widget>((e) =>
                              IndexScreen(state.index_data[e['name']] ?? []))
                          .toList(),
                    )
              // IndexScreen(state.index_data[
              //         state.tabs[_index_controller.index]['name']] ??
              //     [])
              : state.mainScreenPage == MainScreenPage.PROFILE
                  ? ProfileScreen()
                  : Center(child: Text("Not Complete...")),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.currentIndex,
            onTap: state.changePage,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("Index")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.place), title: Text("data")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.place), title: Text("data")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Profile")),
            ],
          ),
        );
      },
    );
  }
}
