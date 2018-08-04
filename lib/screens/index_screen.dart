import 'package:flutter/material.dart';
import 'package:new_trend/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class IndexScreen extends StatefulWidget {
  final List data;

  const IndexScreen(this.data);

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
    final data = List.castFrom<dynamic, NewsItem>(widget.data);
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text("${data[i].cn_title}"),
          subtitle: Text("${data[i].cn_brief}"),
          onTap: () async {
            launch("${data[i].content}");
          },
        );
      },
    );
  }
}

AppBar buildIndexAppbar(
    {List<dynamic> tabs, ValueChanged<int> changed, TabController controller}) {
  return AppBar(
    title: Text("New Tread"),
    bottom: tabs == null
        ? null
        : TabBar(
            controller: controller,
            tabs: tabs.map((e) => new Tab(text: e['name'])).toList(),
          ),
  );
}
