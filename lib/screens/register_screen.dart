import 'dart:convert';
import 'dart:io';
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
  String _userName = "";
  String _password = "";
  String _rePassword = "";

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
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLength: 32,
                    decoration: InputDecoration(
                      hintText: "用户名",
                      border: UnderlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) => _userName = value,
                  ),
                  TextFormField(
                    maxLength: 24,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "密码",
                      border: UnderlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) => _password = value,
                  ),
                  TextFormField(
                    maxLength: 24,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "重复密码",
                      border: UnderlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) => _rePassword = value,
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
                            // _form.currentState.validate();
                            _register();
                          }),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _register() async {
    // if(_userName.trim()!=""&&_password.trim()!=""&&_rePassword.trim()!="") {
    // if (_password.trim() != _rePassword.trim()) {
    //   Scaffold.of(_form.currentContext).showSnackBar(
    //       SnackBar(content: Text("两次密码不一致!")));
    //   return;
    // }

    post("http://www.dashixiuxiu.cn/register_action", body: {
      "username": "$_userName",
      "password": "$_password",
      "mobile": "10086",
      "email": "7777777@qq.com"
    }).then((response) {
      var res = json.decode(response.body);
      print(res["status"]);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(res["status"]),
              content: Text("$res"),
            );
          });
      // if (res["status"] == "success") {
      //   Scaffold.of(_form.currentContext)
      //       .showSnackBar(SnackBar(content: Text("注册成功!")));
      // } else {
      //   Scaffold.of(_form.currentContext)
      //       .showSnackBar(SnackBar(content: Text("注册失败!")));
      // }
    });
    // }else{
    //   Scaffold.of(_form.currentContext).showSnackBar(
    //       SnackBar(content: Text("用户名/密码不能为空!")));
    // }
  }
}
