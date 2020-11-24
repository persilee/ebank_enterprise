import 'dart:async';

import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/linear_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  var _loginText = 'LOGIN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Login"),
          bottom: LinearLoading(
            isLoading: _isLoading,
          )),
      body: Center(
        child: RaisedButton(
          child: Text(
            _loginText,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _isLoading ? null : () => _login(context),
          color: Colors.pinkAccent,
        ),
      ),
    );
  }

  _login(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    UserDataRepository().login(LoginReq(), 'login').then((value) {
      Fluttertoast.showToast(msg: "Login Success. User: ${value.actualName}");
      _showMainPage(context);
      _saveUserConfig(value);
    }).catchError((e) {
      Fluttertoast.showToast(msg: "Login Failed. Message: ${e.toString()}");
    });
  }

  _showMainPage(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(context, pageCardList);
  }

  _saveUserConfig(LoginResp resp) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.USER_ACCOUNT, resp.userPhone);
    prefs.setString(ConfigKey.USER_ID, resp.userId);
  }
}
