import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey<FormState> _form = new GlobalKey();

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
                  ),
                  TextFormField(
                    maxLength: 24,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "密码",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  TextFormField(
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
                            _form.currentState.validate();
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
}
