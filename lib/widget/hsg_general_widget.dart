/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///常用选择框和输入框
/// Author: fangluyao
/// Date: 2021-01-13

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
        ),
        child: _getSelectRow(),
      ),
    );
  }

  Row _getSelectRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: item == ''
                  ? Text(S.current.please_select,
                      style: TextStyle(color: HsgColors.textHintColor))
                  : Text(item),
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
    );
  }
}

//输入框
class TextFieldContainer extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final VoidCallback callback;
  TextFieldContainer(
      {Key key,
      @required this.title,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.callback})
      : super(key: key);

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
          Text(title),
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
              onChanged: (text) {
                callback();
              },
            ),
          ),
        ],
      ),
    );
  }
}
