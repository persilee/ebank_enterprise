/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 转账附言
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget transferOtherWidget(BuildContext context, String remark,
    Function(String inputStr) transferChange,
    [TextEditingController _remarkController]) {
  remark = transferChange(remark) == null
      ? transferChange('${S.current.transfer}')
      : transferChange(remark);

  return SliverToBoxAdapter(
      child: Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    width: MediaQuery.of(context).size.width,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Text(
            S.current.transfer_postscript,
            style: TextStyle(
              color: HsgColors.firstDegreeText,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: TextField(
              // onChanged: (remark) {
              //   transferChange(remark);
              // },
              controller: _remarkController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.current.transfer,
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: HsgColors.textHintColor,
                ),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        )
      ],
    ),
  ));
}
