/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 密码管理
/// Author: 李家伟
/// Date: 2021-03-10

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordManagementPage extends StatefulWidget {
  @override
  _PasswordManagementPageState createState() => _PasswordManagementPageState();
}

class _PasswordManagementPageState extends State<PasswordManagementPage> {
  var _belongCustStatus = ''; //用户状态 -拦截交易密码操作
  // bool _passwordEnabled = false; //用户状态 -拦截交易密码操作

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    // String userID = prefs.getString(ConfigKey.USER_ID);
    //  bool passwordEnabled = prefs.getBool(ConfigKey.USER_PASSWORDENABLED);
    String belongCustStatusStr =
        prefs.getString(ConfigKey.USER_BELONGCUSTSTATUS);

    if (mounted) {
      setState(() {
        _belongCustStatus = belongCustStatusStr ?? '';
        // _passwordEnabled = passwordEnabled ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // String argument = ModalRoute.of(context).settings.arguments;
    // _belongCustStatus = argument != null ? argument : '';
    ScrollController _sctrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).password_management),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: CustomScrollView(
          controller: _sctrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: _mineContendView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 中间内容的内容
  Widget _mineContendView(context) {
    return Container(
      child: Column(
        children: [
          //登录密码
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            // padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _flatBtnNuitWidget(S.of(context).resetLoginPsw, true, () {
                  Navigator.pushNamed(context, changeLgPs);
                }),
              ],
            ),
          ),
          //交易密码
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            // padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _flatBtnNuitWidget(S.of(context).changPayPws, true, () {
                  //修改交易密码
                  (['0', '1', '2', '3', ''].contains(_belongCustStatus))
                      ? _notOpenAccountTip()
                      : Navigator.pushNamed(context, changePayPS);
                }),
                // _flatBtnNuitWidget(S.of(context).changPayPws, true, () {
                //   Navigator.pushNamed(context, changePayPS);
                // }),
                // _flatBtnNuitWidget(S.of(context).resetPayPwd, true, () {
                //   Navigator.pushNamed(context, pageResetPayPwdOtp);
                // }),
                _flatBtnNuitWidget(S.of(context).resetPayPwd, true, () {
                  //重置交易密码
                  (['0', '1', '2', '3', ''].contains(_belongCustStatus))
                      ? _notOpenAccountTip()
                      : Navigator.pushNamed(context, pageResetPayPwdOtp);
                }),
              ],
            ),
          ),
          Container(
            height: 15,
          ),
        ],
      ),
    );
  }

  _notOpenAccountTip() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.current.prompt,
            message: S.current.openAccount_notOpen_content,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        });
  }

  ///按钮单元格，左文字，有箭头图标
  Widget _flatBtnNuitWidget(
      String leftString, bool isShowLine, VoidCallback onClick) {
    return Column(
      children: [
        FlatButton(
          height: 50.0,
          onPressed: onClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftString,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.navigate_next,
                  color: HsgColors.nextPageIcon,
                ),
              ),
            ],
          ),
        ),
        isShowLine
            ? Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                    height: 1,
                    color: HsgColors.divider,
                    indent: 3,
                    endIndent: 3),
              )
            : Container(),
      ],
    );
  }
}
