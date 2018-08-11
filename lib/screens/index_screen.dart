import 'package:flutter/material.dart';
import 'package:new_trend/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_trend/widgets/widgets.dart';

class GeneralContentBody extends StatefulWidget {
  final VoidCallback loadMore;
  final VoidCallback retry;
  final List data;
  final CommonPageStatus status;
  final PageStorageKey<String> key;

  const GeneralContentBody(
      {this.data, this.loadMore, this.retry, this.status, this.key});

  @override
  _GeneralContentBodyState createState() => _GeneralContentBodyState();
}

class _GeneralContentBodyState extends State<GeneralContentBody>
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
    return ListView.builder(
      key: widget.key,
      itemBuilder: (context, i) {
        if (i < widget.data.length) {
          return ListTile(
            // key: Key("${widget.data[i]['url']}"),
            isThreeLine: true,
            title: Text("${widget.data[i]['cn_title']}"),
            subtitle: Text("${widget.data[i]['cn_brief']}"),
            onTap: () => launch("${widget.data[i]['url']}"),
          );
        }
        if (widget.status == CommonPageStatus.READY) {
          widget.loadMore();
        }
        return StatusListTile(
          status: widget.status,
          retry: widget.retry,
        );
      },
      itemCount: widget.data.length + 1,
    );
  }
}
