import 'dart:convert';
import 'package:new_trend/models/models.dart';
import 'package:new_trend/utils/constants.dart' as constants;
import 'package:http/http.dart';

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey<FormState> _form = new GlobalKey();
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _rePassword = TextEditingController();
  CommonPageStatus status = CommonPageStatus.READY;

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
    Widget _buildForm() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _userName,
                  maxLength: 32,
                  decoration: InputDecoration(
                    hintText: "用户名",
                    border: UnderlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _password,
                  maxLength: 24,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "密码",
                    border: UnderlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _rePassword,
                  maxLength: 24,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "重复密码",
                    border: UnderlineInputBorder(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton.icon(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        icon: Icon(Icons.hd),
                        label: Text("注册"),
                        onPressed: () {
                          _register();
                        }),
                  ],
                )
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: status == CommonPageStatus.RUNNING
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildForm()),
    );
  }

  void _register() async {
    if (_userName.value.text.trim() != "" &&
        _password.value.text.trim() != "") {
      if (_password.value.text.trim() != _rePassword.value.text.trim()) {
        _showMessage("两次密码不一致,请核对后再次输入!");
        return;
      }
      setState(() {
        status = CommonPageStatus.RUNNING;
      });
      post(constants.registerAction, body: {
        constants.username: "${_userName.value.text}",
        constants.password: "${_password.value.text}",
        constants.mobile: "10086",
        constants.email: "7777777@qq.com"
      }).then((response) {
        var res = json.decode(response.body);
        print(res[constants.status]);
        var registerStatus = res["status"];
        if (registerStatus == constants.success) {
          Navigator.of(context).pop();
          _showMessage("注册成功!");
        } else
          _showMessage("注册失败!");
      }).whenComplete(() {
        setState(() {
          status = CommonPageStatus.DONE;
        });
      });
    } else {
      _showMessage("用户名/密码不能为空!");
    }
  }

  void _showMessage(String message) {
    if (_form.currentContext != null)
      Scaffold.of(_form.currentContext)
          .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}
