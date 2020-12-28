/**
  @desc   修改登录密码
  @author hlx
 */
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class ChangeLoPS extends StatefulWidget {
  @override
  _ChangeLoPSState createState() => _ChangeLoPSState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ChangeLoPSState extends State<ChangeLoPS> {
  String oldPwd = '';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).setChangLoginPasd),
          elevation: 15.0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(S.of(context).plaseSetPsd),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).oldPwd),
                              
                            ],
                          ),
                        ),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        Container(
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).newPwd),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      //调整关于我们
                                      // Navigator.pushNamed(context, aboutUs);
                                    },
                                    child: Icon(
                                      Icons.navigate_next,
                                      color: HsgColors.nextPageIcon,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        Container(
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).confimPwd),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      //调整关于我们
                                      // Navigator.pushNamed(context, aboutUs);
                                    },
                                    child: Icon(
                                      Icons.navigate_next,
                                      color: HsgColors.nextPageIcon,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        Container(
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).SMS),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      //调整关于我们
                                      // Navigator.pushNamed(context, aboutUs);
                                    },
                                    child: Icon(
                                      Icons.navigate_next,
                                      color: HsgColors.nextPageIcon,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text(S.of(context).sumit),
                      onPressed: () => print("提交"),
                      color: HsgColors.accent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5) //设置圆角
                          ),
                    ),
                  )
                ],
              )),
        ));
  }
}
