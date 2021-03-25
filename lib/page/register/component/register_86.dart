import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册账号拿去手机地区号
/// Author: pengyikang
Widget getRegisterRegion(
  BuildContext context,
  TextEditingController _phoneNum,
  String _officeAreaCodeText,
  Function _selectRegionCode,
) {
  _officeAreaCodeText = _officeAreaCodeText == '' ? '86' : _officeAreaCodeText;
  // print("${_phoneNum.text}");
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
            },
            child: Row(
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 6.8,
                    child: Text('+$_officeAreaCodeText')),
                Container(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 18,
                  child: Icon(
                    Icons.expand_more,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.8,
            padding: EdgeInsets.only(left: 5),
            child: TextField(
              // //是否自动更正
              // autocorrect: false,
              // //是否自动获得焦点
              // autofocus: true,

              controller: _phoneNum,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.current.please_input_mobile_num,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: HsgColors.textHintColor,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    ),
  );
}
