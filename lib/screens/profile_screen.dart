import 'package:flutter/material.dart';
import 'dart:ui' hide Image;
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
        return Stack(
          children: <Widget>[
            Image.network("https://www.baidu.com/img/bd_logo1.png?where=super"),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Column(
                  children: <Widget>[
                    Text("${state.isLogin}"),
                    Text("${state.token}")
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
