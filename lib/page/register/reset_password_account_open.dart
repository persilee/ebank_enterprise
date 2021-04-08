import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/mine_checInformantApi.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/real_name_auth_by_three_factor.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/forexTrading/forex_trading_page.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记密码--已开户页面
/// Author: pengyikang

class ResetPasswordAccountOpen extends StatefulWidget {
  ResetPasswordAccountOpen({Key key}) : super(key: key);

  @override
  ResetPasswordAccountOpenState createState() =>
      ResetPasswordAccountOpenState();
}

class ResetPasswordAccountOpenState extends State<ResetPasswordAccountOpen> {
  TextEditingController _userName = TextEditingController(); //用户真实姓名
  TextEditingController _cardNumber = TextEditingController();
  String _userNameListen;
  String _cardNumberListen;
  String _certType = '';
  String _userPhone;
  List<IdType> idInformationList = []; //证件类型信息
  String _certTypeKey; //身份校验的key
  String _accountName; //前面传过来用户登录名

  Map listData = new Map();
  @override
  void initState() {
    setState(() {
      _userName.addListener(() {
        setState(() {
          _userNameListen = _userName.text;
        });
      });
      _cardNumber.addListener(() {
        setState(() {
          _cardNumberListen = _cardNumber.text;
        });
      });
    });
    super.initState();
    _getIdCardList();
  }

  @override
  Widget build(BuildContext context) {
    listData = ModalRoute.of(context).settings.arguments;
    _accountName = listData['userAccount'];
    _userPhone = listData['userPhone'];
    print("$_accountName>>>>>>>>>>>>>>>>>>>>>>");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //修改颜色
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  //标题
                  getRegisterTitle(
                      '${S.current.fotget_password}-${S.current.placeIdNumber}'),
                  //姓名
                  getRegisterRow(
                    S.current.please_input_name,
                    _userName,
                    false,
                    <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(
                          "[a-zA-Z0-9,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]")),
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),
                  //  证件类型
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFFF5F7F9)),
                    child: Container(
                      child: InkWell(
                        onTap: _idCardListBottomSheet,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: HsgColors.divider, width: 0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _certType == ''
                                  ? Text(
                                      S.current.register_select_documents,
                                    )
                                  : Text(_certType),
                              Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Text('')),
                                  Container(
                                      child: Icon(
                                    Icons.expand_more,
                                    color: Colors.black,
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //证件号码
                  getRegisterRow(
                    S.current.placeIdNumber,
                    _cardNumber,
                    false,
                    <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ), //确定按钮
                  //按钮
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1775BA),
                          Color(0xFF3A9ED1),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      child: Text(S.of(context).next_step),
                      onPressed: _submit()
                          ? () {
                              _realNameAuth();
                            }
                          : null,
                      textColor: Colors.white,
                      disabledTextColor: Colors.white,
                      disabledColor: Color(0xFFD1D1D1),
                    ),
                  )
                ],
              ),
            )));
  }

  //获取证件类型
  _getIdCardList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('CICID'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        print('data.publicCodeGetRedisRspDtoList222222');
        print(data);
        idInformationList = data.publicCodeGetRedisRspDtoList;
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //证件类型选择弹窗
  void _idCardListBottomSheet() async {
    List<String> obj = [];
    List<String> indList = [];

    if (idInformationList != null) {
      idInformationList.forEach((element) {
        obj.add(element.cname);
        indList.add(element.code);
      });
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: S.of(context).idType,
            items: obj,
          );
        });
    print('result$indList');
    if (result != null && result != false) {
      if (mounted) {
        setState(() {
          _certType = obj[result];
          _certTypeKey = indList[result];
          print('$_certType>>>>>>>>>>>>>>>>>>');
        });
      }
    }
  }

  //验证身份信息 提交数据
  _realNameAuth() async {
    print('$_cardNumberListen>>>>>>>>>>>>>>>>>');
    //调用三要素验证，成功后进入人脸识别，识别成功后进入设置密码阶段
    if (_cardNumber.text.length <= 0) {
      Fluttertoast.showToast(
        msg: '请输入证件号!',
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    print(_cardNumber.text +
        '-' +
        _certTypeKey +
        '-' +
        _userPhone +
        '-' +
        _userName.text);
    // Navigator.pushNamed(context, setPayPage);
    HSProgressHUD.show();
    ChecInformantApiRepository()
        .realNameAuth(
            RealNameAuthByThreeFactorReq(
                _cardNumber.text, _certTypeKey, _userPhone, _userName.text),
            'realNameAuthByThreeFactor')
        .then((data) {
      HSProgressHUD.dismiss();
      print(_cardNumber.text +
          '-' +
          _certTypeKey +
          '-' +
          _userPhone +
          '-' +
          _userName.text);
      if (data.enabled) {
        Navigator.pushNamed(context, pageResetPasswordNoAccount,
            arguments: listData);
      }
      HSProgressHUD.dismiss();
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    });
  }

  bool _submit() {
    if (_userName.text != '' &&
        _cardNumber.text != '' &&
        _certType.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
