import 'package:flutter/material.dart';
import 'dart:async';

class ReleaseScreen extends StatefulWidget {
  @override
  _ReleaseScreenState createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen> {
  TextEditingController _titleController,
      _descriptionController,
      _rewardController;
  String title, description;
  int reward;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _rewardController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(width / 8),
          child: AppBar(
            leading: BackButton(),
            title: Text('发布任务'),
            elevation: 0.0,
            centerTitle: true,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: _buildTextField(_titleController, '设置任务标题', 1),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: width / 1.5,
                  child:
                      _buildTextField(_descriptionController, '描述您即将发布的任务', 5),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(8.0),
//                  color: Colors.black12,
                  child: GestureDetector(
                    onTap: _inputReward,
                    child: ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text(
                        '价格',
//                    maxLines: 1,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black26),
                      ),
                      trailing: Container(
                        child: Text(
                          reward.toString(),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, int maxLines,
      [TextInputType type]) {
    return TextField(
      controller: controller,
      keyboardType: type == null ? TextInputType.multiline : type,
      maxLines: maxLines,
      decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black26)),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('真的要放弃发布任务吗?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  Future<Null> _inputReward() {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Center(
                child: Text(
                  '奖励金额',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextField(_rewardController, '请输入奖励金', 1,
                      TextInputType.numberWithOptions()),
                ),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        reward =
                            int.parse(_rewardController.value.text.toString());
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      '确认',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.lightBlue),
                    ))
              ],
            ));
  }
}
