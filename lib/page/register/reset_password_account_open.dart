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
  String _certType = '';
  List<IdType> idInformationList = []; //证件类型信息
  String _certTypeKey; //身份校验的key

  @override
  void initState() {
    super.initState();
    _getIdCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: [
              //标题
              getRegisterTitle('忘记密码'),
              //姓名
              getRegisterRow('输入姓名', _userName),
              //  证件类型
              Container(
                margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color(0xFFF5F7F9)),
                child: SelectInkWell(
                  title: '证件类型',
                  item: _certType,
                  onTap: _idCardListBottomSheet,
                ),
              ),
              //证件号码
              getRegisterRow('输入证件号码', _cardNumber), //确定按钮
              Container(
                margin: EdgeInsets.all(40), //外边距
                height: 44.0,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  child: Text(S.of(context).next_step),
                  onPressed: _submit()
                      ? () {
                          Navigator.pushNamed(
                              context, pageResetPasswordNoAccount);
                        }
                      : null,
                  color: HsgColors.accent,
                  textColor: Colors.white,
                  disabledTextColor: Colors.white,
                  disabledColor: Color(0xFFD1D1D1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5) //设置圆角
                      ),
                ),
              )
            ],
          ),
        ));
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
      });
    }
  }

  bool _submit() {
    if (_userName.text.length > 0 && _cardNumber.text.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
