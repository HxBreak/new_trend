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
  Map<String, TabController> _tabMaps = Map();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    initTabController();
  }

  void initTabController() async {
    final model = ModelFinder<MainStateModel>().of(context);
    await model.basicInited.future;
    model.basicScreenNavItems.forEach((e) {
      if ("${e['pageType']}".toLowerCase() == 'tabs') {
        _tabMaps.putIfAbsent(
            e['name'],
            () => TabController(
                length: e['tabItems'].length, vsync: this, initialIndex: 0));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabMaps.values.forEach((e) => e.dispose());
    _controller.dispose();
  }

  _buildMainBody(BasicScreenStateModel state) {
    return state.basicIsCurrentPageFromNetwork
        ? _buildNetworkBody(state)
        : Center(child: Text("Local Page"));
  }

  Widget _buildNetworkBody(BasicScreenStateModel state) {
    return state.basicCurrentHasTabbar
        ? _buildTabView(state)
        : Center(
            child: Text("Network Page"),
          );
  }

  Widget _buildTabView(BasicScreenStateModel state) {
    return TabBarView(
        controller: _tabMaps[state.basicCurrentTitleString],
        children: state.basicScreenNavItems[state.basicCurrentSelNav]
            ['tabItems'].map<Widget>((e) {
          final currentIndex =
              _tabMaps[state.basicCurrentTitleString]?.index ?? 0;
          final page = state.basicGetCurrentData(e['bodyUrl'], currentIndex);
          return GeneralContentBody(
            key: PageStorageKey<String>("${e['bodyUrl']}-$currentIndex"),
            data: page.networkData,
            loadMore: () =>
                state.basicCurrentLoadMoreData(e['bodyUrl'], currentIndex),
            retry: () {},
            status: page.currentStatus,
          );
        }).toList());
  }

// Text(e['bodyUrl'])
  PreferredSizeWidget _buildBottomBar(BasicScreenStateModel state) {
    return TabBar(
      tabs: state.basicScreenNavItems[state.basicCurrentSelNav]['tabItems']
          .map<Tab>((e) => Tab(text: e['name']))
          .toList(),
      controller: _tabMaps[state.basicCurrentTitleString],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, BasicScreenStateModel state) {
        return Scaffold(
            appBar: state.basicScreenStatus == CommonPageStatus.DONE
                ? AppBar(
                    title: Text("${state.basicCurrentTitleString}"),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.account_box),
                        onPressed: () {
                          Navigator.of(context).pushNamed("login");
                        },
                      )
                    ],
                    bottom: state.basicCurrentHasTabbar
                        ? _buildBottomBar(state)
                        : null,
                  )
                : null,
            body: _buildMainBody(state),
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
                                  .map((e) => e.item)
                                  .toList()),
                      )
                    : null);
      },
    );
  }
}
