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
  bool _onSubmit;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _rewardController = TextEditingController();
    reward = 0;
    _onSubmit = false;
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
                _buildShowRewardTile(),
                Divider(),
                _buildSubmitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return MaterialButton(
      height: 60.0,
      elevation: 4.0,
      color: Colors.lightGreen,
      onPressed: () {
        title = _titleController.value.text;
        description = _descriptionController.value.text;
        //TODO:添加提交网络部分逻辑
        setState(() {
          _onSubmit = true;
          print(_onSubmit);
        });
        Future.delayed(Duration(seconds: 3)).then((_) {
          setState(() {
            _onSubmit = false;
            print(_onSubmit);
          });
        });
      },
      child: _onSubmit
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : Text(
        '发布',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildShowRewardTile() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _inputReward,
        child: ListTile(
          leading: Icon(Icons.attach_money),
          title: Text(
            '价格',
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
              fontSize: 18.0,
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
              style: TextStyle(color: Colors.blue),
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
                  if (_rewardController.value.text != "") {
                    setState(() {
                      reward = int.parse(
                          _rewardController.value.text.toString());
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  '确认',
                  style: TextStyle(
                      color: Colors.lightBlue, fontWeight: FontWeight.bold),
                ))
          ],
        ));
  }
}