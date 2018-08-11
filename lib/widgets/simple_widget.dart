import 'package:flutter/material.dart';
import 'package:new_trend/models/models.dart';

class StatusListTile extends StatelessWidget {
  final VoidCallback retry;
  final CommonPageStatus status;

  const StatusListTile({
    this.retry,
    this.status,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Center(
          child: Text(
            status == CommonPageStatus.RUNNING
                ? "加载中"
                : status == CommonPageStatus.DONE
                    ? "加载完成"
                    : status == CommonPageStatus.ERROR ? "加载失败..." : "就绪",
          ),
        ),
        onTap: status == CommonPageStatus.ERROR ? retry : null);
  }
}
