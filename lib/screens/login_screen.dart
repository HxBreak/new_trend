import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:new_trend/utils/constants.dart' as constants;
import 'package:new_trend/models/models.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey<FormState> _form = new GlobalKey();
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();

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
    Widget _buildLogout(UserAuthModel state) {
      return Center(
        child: FlatButton(
          child: Text("退出"),
          onPressed: state.logout,
        ),
      );
    }

    Widget _buildLogin(UserAuthModel state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  FlutterLogo(size: 64.0),
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
                          label: Text("登录"),
                          onPressed: () {
                            _login(state);
                            _form.currentState.validate();
                          }),
                      FlatButton.icon(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(4.0)),
                          icon: Icon(Icons.hd),
                          label: Text("注册"),
                          onPressed: () {
                            Navigator.of(context).pushNamed("register");
                          }),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(appBar: AppBar(
      title: new ScopedModelDescendant<MainStateModel>(
        builder: (context, widget, state) {
          return Text("data");
        },
      ),
    ), body: ScopedModelDescendant<MainStateModel>(
      builder: (context, weiget, state) {
        return state.isLogin ? _buildLogout(state) : _buildLogin(state);
      },
    ));
  }

  void _login(UserAuthModel model) async {
    if (_userName.text.trim() != "" && _password.text.trim() != "") {
      post(constants.loginAction, body: {
        "username": _userName.text,
        constants.password: _password.text
      })
          .then((response) {
            if (response.statusCode != 200) {
              throw Exception("登录失败 code:${response.statusCode}");
            } else {
              var result = json.decode(response.body);
              if (result[constants.status] == constants.success) {
                _showMessage("登录成功");
                model.login(result['token']);
                Navigator.of(context).pop();
              } else
                _showMessage("用户名/密码错误!");
            }
          })
          .catchError((e) => _showMessage("错误: $e"))
          .whenComplete(() {});
    } else {
      if (_userName.text.trim() == "")
        _showMessage("用户名不能为空!");
      else
        _showMessage("密码不能为空!");
    }
  }

  void _showMessage(String message) {
    Scaffold.of(_form.currentState.context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
