/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///金额校验
/// Author: fangluyao
/// Date: 2021-04-06

import 'package:flutter/services.dart';

class MoneyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate

    String newValueText = newValue.text;

    if (newValueText == ".") {
      //第一个数为.
      newValueText = "0.";
    } else if (newValueText.contains(".")) {
      //包含.
      if (newValueText.lastIndexOf(".") != newValueText.indexOf(".")) {
        //输入两个小数点
        newValueText = newValueText.substring(0, newValueText.lastIndexOf("."));
      } else if (newValueText.length - 1 - newValueText.indexOf(".") > 2) {
        //输入一个小数点，小数点后两位
        newValueText = newValueText.substring(0, newValueText.indexOf(".") + 3);
      }
    }
    return TextEditingValue(
        text: newValueText,
        selection: new TextSelection.collapsed(offset: newValueText.length));
  }
}
