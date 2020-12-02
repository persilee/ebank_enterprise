/**
  @desc   修改登录密码
  @author hlx
 */
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class ChangeLoPS extends StatefulWidget {
  @override
  _ChangeLoPSState createState() => _ChangeLoPSState();
}

class _ChangeLoPSState extends State<ChangeLoPS> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('修改登录密码'),
          elevation: 15.0,
        ),
        body: Container(
            color: HsgColors.commonBackground,
            child: Text('修改登录密码')
    )
    );
  }
}