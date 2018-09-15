import 'package:flutter/material.dart';
import 'package:new_trend/models/models.dart';
import 'package:new_trend/widgets/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskScreen extends StatefulWidget {
  final MainStateModel model;

  TaskScreen(this.model);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
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
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, state) {
        return ListView.builder(
          itemCount: state.taskList.length + 1,
          itemBuilder: (context, i) {
            if (i < state.taskList.length) {
              return ListTile(
                title: Text("${state.taskList[i]['task_name']}"),
                subtitle:
                    Text("${state.taskList[i]['task_desc']}", maxLines: 3),
                leading: CircleAvatar(
                  child: Text(
                    "${state.taskList[i]['reward']}",
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                ),
              );
            }
            if (state.taskStatus == CommonPageStatus.READY) {
              state.tasksLoadMore(state.token);
            }
            return StatusListTile(
              retry: () => state.tasksLoadMore(state.token),
              status: state.taskStatus,
            );
          },
        );
      },
    );
  }
}
