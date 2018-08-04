import 'package:flutter/material.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen>
    with SingleTickerProviderStateMixin {
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
    return Container();
  }
}

AppBar buildIndexAppbar(
    {List<String> tabs, ValueChanged<int> changed, TabController controller}) {
  return AppBar(
    title: Text("New Tread"),
    bottom: tabs == null
        ? null
        : TabBar(
            controller: controller,
            tabs: tabs.map((e) => new Tab(text: e)).toList(),
          ),
  );
}
