/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 交易详情
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_pay_collect_detail.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DetailInfoPage extends StatefulWidget {
  DetailInfoPage({Key key}) : super(key: key);

  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  DdFinHisDTOList ddFinHist;
  String _language = Intl.getCurrentLocale();
  String _statusName = '';

  @override
  void initState() {
    super.initState();
    _getType();
  }

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
                      //交易金额
                      ddFinHist.drCrFlg == 'C'
                          ? '+ ' +
                              ddFinHist.txCcy +
                              ' ' +
                              FormatUtil.formatSringToMoney(ddFinHist.txAmt)
                          : '- ' +
                              ddFinHist.txCcy +
                              ' ' +
                              FormatUtil.formatSringToMoney(ddFinHist.txAmt),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: HsgColors.aboutusTextCon,
                      ),
                    ),
                  ),
                ),
                //交易流水号
                ContentRow(
                  label: S.current.msgId,
                  item: ddFinHist.msgId,
                ),
                //交易账号
                ContentRow(
                  label: S.current.transaction_account,
                  item: ddFinHist.acNo,
                ),
                //交易时间
                ContentRow(
                  label: S.current.transaction_time,
                  item: ddFinHist.txDateTime,
                ),
                // 交易类型
                ContentRow(
                  label: S.current.transaction_type,
                  item: _statusName,
                ),

                //备注
                ContentRow(
                  label: S.current.remarks,
                  item: ddFinHist.narrative,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// 获取状态
  Future _getType() async {
    HSProgressHUD.show();
    GetIdTypeResp getIdTypeResp = await ApiClientOpenAccount()
        .getIdType(GetIdTypeReq('TRANSFERTYPE'))
        .then((data) {
      List<IdType> _tenorList = data.publicCodeGetRedisRspDtoList;
      if (_tenorList.isNotEmpty) {
        _tenorList.forEach((element) {
          if (ddFinHist.txMmo == element.code) {
            if (this.mounted) {
              setState(() {
                _statusName =
                    _language == 'zh_CN' ? element.cname : element.name;
              });
            }
          }
        });
        HSProgressHUD.dismiss();
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      print(e.toString());
    });
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text(
              label,
              style: TextStyle(color: HsgColors.aboutusTextCon),
            ),
          ),
          Expanded(
            child: Text(
              item != '' && item != null ? item : '',
              style: TextStyle(color: HsgColors.describeText),
              maxLines: 3,
              textAlign: TextAlign.right,
            ),

            //  alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}
