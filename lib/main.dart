import 'package:flutter/material.dart';
import 'package:new_trend/screens/task_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:new_trend/screens/screens.dart';
import 'package:new_trend/models/models.dart';

void main() => runApp(new TrendApp());

class TrendApp extends StatelessWidget {
  final model = MainStateModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainStateModel>(
      model: model,
      child: new MaterialApp(
        title: 'New Trend',
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        home: new MainScreen(),
        routes: {
          "login": (context) => LoginScreen(),
          "register": (context) => RegisterScreen(),
          "addTask": (context) => AddTaskScreen(),
        },
      ),
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
    final model = ScopedModel.of<MainStateModel>(context);
    await model.basicInited.future; //阻塞初始化状态，等待网络请求完成后初始化TabController
    model.basicScreenNavItems.forEach((e) {
      if ("${e['pageType']}".toLowerCase() == 'tabs') {
        final tab = TabController(
            length: e['tabItems'].length, vsync: this, initialIndex: 0);
        tab.addListener(() => setState(() {}));
        _tabMaps.putIfAbsent(e['name'], () => tab);
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
    return state.basicIsCurrentPageFromNetwork || !state.basicInited.isCompleted
        ? _buildNetworkBody(state)
        : state.basicCurrentSelNav == 3
            ? TaskScreen(state)
            : state.basicCurrentSelNav == 4
                ? ProfileScreen(state)
                : Center(
                    child: Text("Not Ready"),
                  ); //正常状态下当前不应当存在没有处理的页面, 保险起见处理一下
  }

  Widget _buildNetworkBody(BasicScreenStateModel state) {
    return state.basicCurrentHasTabbar
        ? _buildTabView(state)
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  ///构建可左右滑动的Body
  Widget _buildTabView(BasicScreenStateModel state) {
    return TabBarView(
        controller: _tabMaps[state.basicCurrentTitleString],
        children: List.generate(
            state.basicScreenNavItems[state.basicCurrentSelNav]['tabItems']
                .length, (i) {
          final e = state.basicScreenNavItems[state.basicCurrentSelNav]
              ['tabItems'][i];
          final page = state.basicGetCurrentData(e['bodyUrl'], i);
          return GeneralContentBody(
            key: PageStorageKey<String>("${e['bodyUrl']}-$i"),
            data: page.networkData,
            loadMore: () => state.basicCurrentLoadMoreData(e['bodyUrl'], i),
            retry: () {},
            onRefresh: () async {
              await state.basicCurrentLoadMoreData(e['bodyUrl'], i,
                  refresh: true);
            },
            status: page.currentStatus,
          );
        }));
  }

  ///构建TabBar
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
            floatingActionButton: state.basicCurrentSelNav == 3 &&
                    (state as MainStateModel).isLogin
                ? FloatingActionButton(
                    child: Icon(Icons.send),
                    onPressed: () {
                      Navigator.of(context).pushNamed("addTask");
                    },
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
                                  .map((e) => e.item)
                                  .toList()),
                      )
                    : null);
      },
    );
  }
}
