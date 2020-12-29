import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget TransferOtherWidget(
    String remark, Function(String inputStr) transferChange) {
  remark = transferChange(remark) == null
      ? transferChange('${S.current.transfer}')
      : transferChange(remark);

  return SliverToBoxAdapter(
      child: Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Row(
      children: [
        Container(
          child: Text(S.current.transfer_postscript),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 200),
            child: TextField(
                onChanged: (remark) {
                  transferChange(remark);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: S.current.transfer,
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: HsgColors.textHintColor,
                  ),
                )),
          ),
        )
      ],
    ),
  ));
}
