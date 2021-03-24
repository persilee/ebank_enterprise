import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/forexTrading/forex_trading_page.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
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
  TextEditingController _userName = TextEditingController();
  TextEditingController _cardNumber = TextEditingController();
  String _userNameListen;
  String _cardNumberListen;
  String _certType = '';
  List<IdType> idInformationList = []; //证件类型信息
  String _certTypeKey; //身份校验的key

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
                  getRegisterRow(S.current.please_input_name, _userName, false),
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
                      S.current.placeIdNumber, _cardNumber, false), //确定按钮
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
                              Navigator.pushNamed(
                                  context, pageResetPasswordNoAccount);
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
      Fluttertoast.showToast(msg: e.toString());
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
      setState(() {
        _certType = obj[result];
        _certTypeKey = indList[result];
        print('$_certType>>>>>>>>>>>>>>>>>>');
      });
    }
  }

  bool _submit() {
    if (_userNameListen != '' &&
        _cardNumberListen != '' &&
        _certType.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
