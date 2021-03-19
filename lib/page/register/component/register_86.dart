import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册账号拿去手机地区号
/// Author: pengyikang
Widget getRegisterRegion(BuildContext context, TextEditingController _phoneNum,
    String _officeAreaCodeText, Function _selectRegionCode) {
  _officeAreaCodeText = _officeAreaCodeText == '' ? '86' : _officeAreaCodeText;
  print("${_phoneNum.text}");
  return Container(
    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
    width: MediaQuery.of(context).size.width / 2,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xFFF5F7F9)),
    child: Container(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _selectRegionCode();
              print('点击86');
              print("$_officeAreaCodeText  ++++++");
            },
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 20),
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 10,
                  child: Text('+$_officeAreaCodeText'),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 14,
                  child: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: TextField(
              //是否自动更正
              autocorrect: false,
              //是否自动获得焦点
              autofocus: true,
              controller: _phoneNum,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '输入手机号',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
