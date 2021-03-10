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
        centerTitle: true,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 20, 17, 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    S.current.transaction_amount,
                    style: TextStyle(color: HsgColors.describeText),
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
                        color: HsgColors.aboutusTextCon,
                      ),
                    ),
                  ),
                ),
                ContentRow(
                  label: S.current.msgId,
                  item: ddFinHist.msgId,
                ),
                ContentRow(
                  label: S.current.transaction_account,
                  item: ddFinHist.acNo,
                ),
                ContentRow(
                  label: S.current.transaction_time,
                  item: ddFinHist.txDateTime,
                ),
                ContentRow(
                  label: S.current.remarks,
                  item: ddFinHist.remark, //narrative,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContentRow extends StatelessWidget {
  final String label;
  final String item;
  ContentRow({Key key, this.label, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              label,
              style: TextStyle(color: HsgColors.aboutusTextCon),
            ),
          ),
          Container(
            child: Text(
              item != '' && item != null ? item : '',
              style: TextStyle(color: HsgColors.describeText),
            ),
          ),
        ],
      ),
    );
  }
}
