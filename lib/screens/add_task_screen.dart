import 'package:flutter/material.dart';
import 'package:new_trend/models/models.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _ReleaseScreenState createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<AddTaskScreen> {
  TextEditingController _titleController, _descriptionController;
  String title, description;
  int reward, time = DateTime.now().millisecondsSinceEpoch;
  AddTaskStateModel taskStateModel;

  AddTaskStateModel getTaskStateModel(String token) {
    if (taskStateModel == null) {
      taskStateModel = new AddTaskStateModel(token);
    }
    return taskStateModel;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formater = DateFormat("yyyy-MM-dd HH-mm-ss");
    final textStyle = TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black38);

    final textStyleBlack = TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black);
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, state) {
        return ScopedModel<AddTaskStateModel>(
          model: getTaskStateModel(state.token),
          child: WillPopScope(
            onWillPop: _onBackPressed,
            child: ScopedModelDescendant<AddTaskStateModel>(
              builder: (context, widget, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('发布任务'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                _buildTextField(_titleController, '设置任务标题', 1),
                          ),
                          SizedBox(height: 16.0),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  helperText: "描述你想要完成的任务",
                                  labelText: "任务描述",
                                ),
                                maxLines: 10,
                                maxLength: 1024,
                                controller: _descriptionController,
                                keyboardType: TextInputType.multiline,
                              )
                            ],
                          ),
                          ListTile(
                            onTap: () async {
                              final int i = await _inputReward();
                              setState(() {
                                if (i != null) {
                                  reward = i;
                                }
                              });
                            },
                            leading: Icon(Icons.attach_money),
                            title: Text(
                              '价格',
                              style: textStyle,
                            ),
                            trailing: Text(
                              "${reward ?? 0}",
                              maxLines: 1,
                              style: textStyleBlack,
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              final now = DateTime.now();
                              time = (await showDatePicker(
                                context: context,
                                firstDate: now,
                                initialDate: now,
                                lastDate: now.add(Duration(days: 64)),
                              ))
                                  ?.millisecondsSinceEpoch;
                            },
                            leading: Icon(Icons.timeline),
                            title: Text("截止日期", style: textStyle),
                            trailing: Text(
                              "${DateTime.now()}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          FlatButton.icon(
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).accentColor,
                            ),
                            label: Text(
                              "发布",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            onPressed: () {
                              state.taskAdd(title, description, reward, time);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, int maxLines,
      [TextInputType type]) {
    return TextField(
      controller: controller,
      keyboardType: type == null ? TextInputType.multiline : type,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        hintStyle: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black26),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return true;
  }

  Future<int> _inputReward() async {
    return await showDialog(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: Text('奖励金额'),
            contentPadding: const EdgeInsets.all(16.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("确认"),
                onPressed: () {
                  Navigator.of(context).pop(int.tryParse(controller.text));
                },
              )
            ],
          );
        });
  }
}
