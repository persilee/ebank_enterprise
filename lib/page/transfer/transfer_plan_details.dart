import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_plan_details.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_plan_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferPlanDetailsPage extends StatefulWidget {
  final TransferPlan transferPlan;
  TransferPlanDetailsPage({Key key, this.transferPlan}) : super(key: key);

  @override
  _TransferPlanDetailsPageState createState() =>
      _TransferPlanDetailsPageState(transferPlan);
}

class _TransferPlanDetailsPageState extends State<TransferPlanDetailsPage> {
  TransferPlan transferPlan;
  _TransferPlanDetailsPageState(this.transferPlan);
  // String planId = '';
  String planName = '';
  String transferType = '';
  String transferTypeCode = '';
  String payeeName = '';
  String payeeCardNo = '';
  String payerCardNo = '';
  String frequency = '';
  String frequencyCode = '';
  String startDate = '';
  String endDate = '';
  String nextDate = '';
  String debitCurrency = '';
  String amount = '';
  String remark = '';

  @override
  void initState() {
    super.initState();
    _getTransferPlan();
  }

  //文本样式
  Widget _textStyle(String text, Color textColor, double textSize,
      FontWeight textWeight, TextAlign align) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          color: textColor, fontSize: textSize, fontWeight: textWeight),
    );
  }

  //分割线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Divider(height: 0.5, color: HsgColors.divider),
    );
  }

//显示一行信息
  Widget _showOneLine(
    String leftText,
    String rightText,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 30) / 2,
                child: _textStyle(leftText, HsgColors.aboutusTextCon, 14.0,
                    FontWeight.normal, TextAlign.left),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 30) / 2,
                child: _textStyle(rightText, HsgColors.describeText, 14.0,
                    FontWeight.normal, TextAlign.right),
              ),
            ],
          ),
        ),
        _line(),
      ],
    );
  }

//计划详情
  Widget _transferPlanDetails(
      String planName,
      String transferType,
      String payeeName,
      String payeeCardNo,
      String payerCardNo,
      String frequency,
      String startDate,
      String endDate,
      String nextDate,
      String debitCurrency,
      String amount,
      String remark) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _showOneLine(S.current.plan_name, planName),
          _showOneLine(S.current.transfer_type, transferType),
          _showOneLine(S.current.payee_company, payeeName),
          _showOneLine(S.current.transfer_to_account, payeeCardNo),
          _showOneLine(S.current.transfer_from_account, payerCardNo),
          _showOneLine(S.current.transfer_frequency, frequency),
          _showOneLine(S.current.first_time_of_transfer, startDate),
          _showOneLine(S.current.stop_time, endDate),
          _showOneLine(S.current.next_transfer_time, nextDate),
          _showOneLine(S.current.transfer_currency, debitCurrency),
          _showOneLine(S.current.transfer_amount_each_time, amount),
          _showOneLine(S.current.remark, remark),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (frequencyCode) {
      case '0':
        frequency = '仅1次';
        break;
      case '1':
        frequency = '每日';
        break;
      case '2':
        frequency = '每月';
        break;
      default:
        frequency = '每年';
    }
    switch (transferTypeCode) {
      case '0':
        transferType = '行内转账';
        break;
      case '1':
        frequency = '跨行转账';
        break;
      default:
        frequency = '国际转账';
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.transfer_plan_detail),
      ),
      body: _transferPlanDetails(
          planName,
          transferType,
          payeeName,
          FormatUtil.formatSpace4(payeeCardNo),
          FormatUtil.formatSpace4(payerCardNo),
          frequency,
          startDate,
          endDate,
          nextDate,
          debitCurrency,
          amount,
          remark),
    );
  }

  void _getTransferPlan() {
    Future.wait({
      TransferDataRepository().getTransferPlanDetails(
          GetTransferPlanDetailsReq(transferPlan.planId),
          'getTransferPlanDetails')
    }).then(
      (data) {
        data.forEach((value) {
          if (value is GetTransferPlanDetailsResp) {
            setState(() {
              planName = value.planName;
              transferTypeCode = value.transferType;
              payeeName = value.payeeName;
              payeeCardNo = value.payeeCardNo;
              payerCardNo = value.payerCardNo;
              frequencyCode = value.frequency;
              startDate = value.startDate;
              endDate = value.endDate;
              nextDate = value.nextDate;
              debitCurrency = value.debitCurrency;
              amount = value.amount;
              remark = value.remark;
            });
          }
        });
      },
    );
  }
}
