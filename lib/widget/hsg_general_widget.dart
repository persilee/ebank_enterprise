/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///常用选择框和输入框
/// Author: fangluyao
/// Date: 2021-01-13

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//选择框
class SelectInkWell extends StatelessWidget {
  final String title;
  final String item;
  final void Function() onTap;
  SelectInkWell({Key key, @required this.title, this.item, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        // padding: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
        ),
        child: _getSelectRow(context),
      ),
    );
  }

  Widget _getSelectRow(context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Text(title),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.only(right: 12),
                child: item == ''
                    ? Text(
                        S.current.please_select,
                        style: TextStyle(color: HsgColors.textHintColor),
                        textAlign: TextAlign.end,
                      )
                    : Text(
                        item,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
              ),
              Image(
                color: HsgColors.firstDegreeText,
                image:
                    AssetImage('images/home/listIcon/home_list_more_arrow.png'),
                width: 7,
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//输入框
class TextFieldContainer extends StatelessWidget {
  final String title;
  final String hintText;
  final Widget widget;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final VoidCallback callback;
  final bool isWidget;
  final int length;
  final bool isRegEXp;
  final String regExp;
  final bool isUpperCase;
  TextFieldContainer({
    Key key,
    @required this.title,
    this.hintText,
    this.widget,
    this.keyboardType,
    this.controller,
    this.callback,
    this.isWidget = false,
    this.length = 140,
    this.isRegEXp = false,
    this.regExp,
    this.isUpperCase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              autocorrect: false,
              autofocus: false,
              textAlign: TextAlign.end,
              style: FIRST_DEGREE_TEXT_STYLE,
              keyboardType: keyboardType,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: HINET_TEXT_STYLE,
              ),
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(length),
                isRegEXp
                    ? FilteringTextInputFormatter.allow(RegExp(regExp))
                    : LengthLimitingTextInputFormatter(length),
                if (isUpperCase) UpperCaseTextFormatter(),
              ],
              onChanged: (text) {
                callback();
              },
            ),
          ),
          isWidget ? widget : Container(),
        ],
      ),
    );
  }
}
