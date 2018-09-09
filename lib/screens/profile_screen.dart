import 'package:flutter/material.dart';
// import 'dart:ui' hide Image, TextStyle;
import 'package:scoped_model/scoped_model.dart';
import 'package:new_trend/models/models.dart';

class ProfileScreen extends StatefulWidget {
  final MainStateModel model;

  ProfileScreen(this.model);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: CircleAvatar(
                          minRadius: 32.0,
                          child: Text("k", style: TextStyle(fontSize: 24.0)),
                        ),
                        onTap: () {
                          if (state.isLogin) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("是否退出?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("退出"),
                                          onPressed: () {
                                            state.logout();
                                            if (Navigator.of(context)
                                                .canPop()) {
                                              Navigator.of(context).pop();
                                            }
                                          }),
                                      FlatButton(
                                        child: Text("取消"),
                                        onPressed: () {
                                          if (Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else {
                            Navigator.of(context).pushNamed("login");
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${state.token ?? '点击图标登录'}",
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
