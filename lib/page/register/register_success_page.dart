/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册成功页面
/// Author: pengyikang

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterSuccessPage extends StatefulWidget {
  RegisterSuccessPage({Key key}) : super(key: key);

  @override
  _RegisterSuccessPageState createState() => _RegisterSuccessPageState();
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {
  var _isLoading = false;
  String _account;
  String password;
  Map listDataLogin = new Map();
  @override
  Widget build(BuildContext context) {
    listDataLogin = ModalRoute.of(context).settings.arguments;
    _account = listDataLogin['accountName'];
    password = listDataLogin['password'];
    print('$_account >>>>>>>>>loginaccount');
    print('$password >>>>>>>>>loginpassword');

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            //欢迎注册
            getRegisterTitle(
                '${S.current.welcome_to_register}-${S.current.register_success}'),
            Container(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Image.asset(
                'images/time_depost/time_deposit_contract_succeed.png',
                width: 64.0,
                height: 64.0,
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      S.current.register_success,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            //完成按钮
            CustomButton(
              margin: EdgeInsets.only(left: 37.5, right: 37.5, top: 125),
              height: 50,
              // borderRadius: BorderRadius.circular(50.0),
              text: Text(
                S.current.complete,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              clickCallback: () {
                print('开户申请');
                _login();
              },
            ),
          ],
        ),
      ),
    );
  }

  ///保存数据
  _saveUserConfig(BuildContext context, LoginResp resp) async {
    ///登录页面清空数据
    HsgHttp().clearUserCache();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.USER_ACCOUNT, resp.userAccount);
    prefs.setString(ConfigKey.USER_ID, resp.userId);
    prefs.setString(ConfigKey.USER_PHONE, resp.userPhone);
    prefs.setString(ConfigKey.USER_AREACODE, resp.areaCode);
    if (resp.custId == null || resp.custId == '') {
      prefs.setString(ConfigKey.CUST_ID, '');
    } else {
      prefs.setString(ConfigKey.CUST_ID, resp.custId);
    }

    _showMainPage(context);
  }

  ///登录成功-跳转操作
  _showMainPage(BuildContext context) async {
    setState(() {
      _isLoading = false;
    });
    //跳转至首页，并关闭前面页面
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) {
      return IndexPage();
    }), (Route route) {
      //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
      print(route.settings?.name);
      //跳转至首页
      if (route.settings?.name == "/") {
        return true; //停止关闭
      }
      return false; //继续关闭
    });
  }

  //登录操作
  _login() {
    print('$_account >>>>>>>>>loginMethodaccount');
    print('$password >>>>>>>>>loginMethodpassword');
    HSProgressHUD.show();
    UserDataRepository()
        .login(LoginReq(username: _account, password: password), 'login')
        .then((value) {
      if (mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          _saveUserConfig(context, value);
          _isLoading = false;
        });
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    });
  }
}
