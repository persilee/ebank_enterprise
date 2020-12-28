import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget TransferPayeeWidget(
  Function(String inputStr) nameChange,
  Function(String inputStr) accountChange,
) {
  return SliverToBoxAdapter(
      child: Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.fromLTRB(0, 20, 15, 0),
    child: Column(
      children: [
        Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  S.current.receipt_side,
                  style: TextStyle(color: HsgColors.describeText, fontSize: 13),
                  textAlign: TextAlign.right,
                ),
              ),
            ])),

        Container(
          child: Row(
            children: [
              _fiveRowLeft(S.current.name),
              _fiveRowRight(nameChange, S.current.hint_input_receipt_name),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              ),
              Image(
                image: AssetImage('images/login/login_input_account.png'),
                width: 20,
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            )),
        //账号
        Container(
          child: Row(
            children: [
              //获取账户
              _fiveRowLeft(S.current.account_num),

              _fiveRowRight(
                  accountChange, S.current.hint_input_receipt_account),

              Container(
                padding: EdgeInsets.fromLTRB(65, 0, 0, 0),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            )),
      ],
    ),
  ));
}

Widget _fiveRowLeft(String name) {
  return Container(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Text(
      name,
      style: TextStyle(
        color: HsgColors.firstDegreeText,
        fontSize: 14,
      ),
    ),
  );
}

Widget _fiveRowRight(Function nameChanges, String hintText) {
  return Expanded(
    child: Container(
      child: TextField(
          //是否自动更正
          autocorrect: false,
          //是否自动获得焦点
          autofocus: false,
          onChanged: (payeeName) {
            nameChanges(payeeName);
            print("这个是 onChanged 时刻在监听，输出的信息是：$payeeName");
          },
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: HsgColors.textHintColor,
            ),
          )),
    ),
  );
}
