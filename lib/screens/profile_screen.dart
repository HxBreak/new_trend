import 'package:flutter/material.dart';
import 'dart:ui' hide Image;

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
    return Stack(
      children: <Widget>[
        Image.network("https://www.baidu.com/img/bd_logo1.png?where=super"),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              width: 500.0,
              height: 700.0,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
