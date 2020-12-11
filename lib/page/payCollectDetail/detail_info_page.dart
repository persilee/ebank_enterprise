/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 交易详情
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_pay_collect_detail.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class DetailInfoPage extends StatefulWidget {
  DetailInfoPage({Key key}) : super(key: key);

  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  DdFinHistDOList ddFinHist;

  @override
  Widget build(BuildContext context) {
    ddFinHist = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transaction_info),
      ),
      body: Container(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 20, 17, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  S.current.transaction_amount,
                  style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 40),
                  child: Text(
                    ddFinHist.drCrFlg == 'C'
                        ? '+ ' + ddFinHist.txCcy + ' ' + ddFinHist.txAmt
                        : '- ' + ddFinHist.txCcy + ' ' + ddFinHist.txAmt,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.msgId,
                    style: TextStyle(fontSize: 14, color: Color(0xFF262626)),
                  ),
                  Text(
                    ddFinHist.msgId,
                    style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(height: 0.5, color: HsgColors.divider),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.transaction_account,
                    style: TextStyle(fontSize: 14, color: Color(0xFF262626)),
                  ),
                  Text(
                    ddFinHist.acNo,
                    style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(height: 0.5, color: HsgColors.divider),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.transaction_time,
                    style: TextStyle(fontSize: 14, color: Color(0xFF262626)),
                  ),
                  Text(
                    ddFinHist.txDateTime,
                    style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(height: 0.5, color: HsgColors.divider),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.remarks,
                    style: TextStyle(fontSize: 14, color: Color(0xFF262626)),
                  ),
                  Text(
                    ddFinHist.narrative,
                    style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(height: 0.5, color: HsgColors.divider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
