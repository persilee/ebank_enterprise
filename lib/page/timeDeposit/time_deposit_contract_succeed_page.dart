/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 操作成功页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';

// import 'package:ebank_mobile/feature_demo/time_deposit_record_page.dart';

import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class DepositContractSucceed extends StatefulWidget {
  DepositContractSucceed({Key key}) : super(key: key);

  @override
  _DepositContractSucceed createState() => _DepositContractSucceed();
}

class _DepositContractSucceed extends State<DepositContractSucceed> {
  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.operation_successful),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
            child: Image.asset(
              'images/time_depost/time_deposit_contract_succeed.png',
              width: 64.0,
              height: 64.0,
              // fit: BoxFit.cover,
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    S.current.operation_successful,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 75, 30, 0),
            child: ButtonTheme(
                minWidth: 5,
                height: 45,
                child: FlatButton(
                  onPressed: () {
                    //行内转账跳转
                    //pageTransfer
                    if (_arguments == '0') {
                      Navigator.of(context)
                          .pushReplacementNamed(pageTransferInternal);
                    }
                    //定期开立跳转
                    if (_arguments == 'timeDepositProduct') {
                      Navigator.pushReplacementNamed(
                          context, pageTimeDepostProduct);
                    }
                    //任务审批跳转
                    if (_arguments == 'taskApproval') {
                      Navigator.pop(context);
                      NotificationCenter.instance
                          .postNotification('refresh', true);
                    }
                  },
                  color: HsgColors.accent,
                  child: (Text(S.current.complete,
                      style: TextStyle(color: Colors.white))),
                )),
          )
        ],
      ),
    );
  }
}
