/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///单列选择器
/// Author: fangluyao
/// Date: 2021-01-06

import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:ebank_mobile/generated/l10n.dart';

//点击响应函数
typedef StringClickCallback = void Function(int selectIndex, Object selectStr);

class SinglePicker {
  static void showStringPicker<T>(
    BuildContext context, {
    @required List<T> data,
    String title,
    int normalIndex,
    PickerDataAdapter adapter,
    @required StringClickCallback clickCallBack,
  }) {
    openModalPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: false),
        clickCallBack: (Picker picker, List<int> selecteds) {
      clickCallBack(selecteds[0], data[selecteds[0]]);
    }, selecteds: [normalIndex ?? 0], title: title);
  }

  static void openModalPicker(
    BuildContext context, {
    @required PickerAdapter adapter,
    String title,
    String name,
    List<int> selecteds,
    @required PickerConfirmCallback clickCallBack,
  }) {
    new Picker(
            adapter: adapter,
            title: new Text(title ?? name,
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            selecteds: selecteds,
            cancelText: S.of(context).cancel,
            confirmText: S.of(context).confirm,
            cancelTextStyle: TextStyle(color: Colors.black, fontSize: 16),
            confirmTextStyle: TextStyle(color: Colors.black, fontSize: 16),
            textAlign: TextAlign.right,
            itemExtent: 40,
            height: 200,
            selectedTextStyle: TextStyle(color: Colors.black),
            onConfirm: clickCallBack)
        .showModal(context);
  }
}
