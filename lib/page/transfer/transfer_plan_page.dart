/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///转账计划列表页面
/// Author: wangluyao
/// Date: 2021-01-15

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/delete_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_plan_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransferPlanPage extends StatefulWidget {
  TransferPlanPage({Key key}) : super(key: key);

  @override
  _TransferPlanPageState createState() => _TransferPlanPageState();
}

class _TransferPlanPageState extends State<TransferPlanPage> {
  bool btnOne = true;
  bool btnTwo = false;
  String groupValue = '0';
  List<String> _statusList = ['P'];
  List<TransferPlan> transferPlanList = [];
  TransferPlan transferPlan;
  String frequency = '';
  String transferType = '';
  String planId = '';
  String btnTitle = S.current.cancel_plan;
  Color btnColor = HsgColors.accent;

  List state = [
    {
      "title": S.current.in_progress,
      "type": "0",
    },
    {
      "title": S.current.already_finished,
      "type": "1",
    },
  ];

  @override
  void initState() {
    super.initState();
    _getTransferPlanList();
  }

  //改变groupValue
  void updateGroupValue(String value) {
    setState(() {
      groupValue = value;
    });
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

  //提示对话框
  _alertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: "提示",
            message: "确认取消转账计划？",
            positiveButton: '确定',
            negativeButton: '取消',
          );
        }).then((value) {
      if (value == true) {
        _delTransferPlan();
      }
    });
  }

//显示一行信息
  Widget _showOneLine(
    String leftText,
    String rightText,
  ) {
    return Container(
      padding: EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 2,
            child: _textStyle(leftText, Color(0xff9a9a9a), 12.0,
                FontWeight.normal, TextAlign.left),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 2,
            child: _textStyle(rightText, Color(0xff9a9a9a), 12.0,
                FontWeight.normal, TextAlign.right),
          ),
        ],
      ),
    );
  }

  //转账计划信息
  Widget _planInfo(String amountAndCcy, String frequency, String startDate,
      String endDate, String nextDate, String transferType) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 7),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          _showOneLine(S.current.transfer_amount_each_time, amountAndCcy),
          _showOneLine(S.current.transfer_frequency, frequency),
          _showOneLine(S.current.first_time_of_transfer_with_value, startDate),
          _showOneLine(S.current.stop_time, endDate),
          _showOneLine(S.current.next_transfer_time, nextDate),
          _showOneLine(S.current.transfer_type_with_value, transferType),
        ],
      ),
    );
  }

  //按钮样式
  Widget _btnStyle(String btnTitle, String btnType, Color btnColor,
      Color textColor, BorderSide borderSide, double textSize) {
    BorderRadius borderRadius;
    if (btnTitle == S.current.in_progress) {
      borderRadius = BorderRadius.horizontal(left: Radius.circular(5));
    } else if (btnTitle == S.current.already_finished) {
      borderRadius = BorderRadius.horizontal(right: Radius.circular(5));
    } else {
      borderRadius = BorderRadius.all(Radius.circular(50));
    }
    return FlatButton(
      padding: EdgeInsets.zero,
      color: btnColor,
      shape:
          RoundedRectangleBorder(side: borderSide, borderRadius: borderRadius),
      onPressed: () {
        if (btnTitle == S.current.in_progress) {
          _statusList = ['P'];
          updateGroupValue(btnType);
          _getTransferPlanList();
          print(btnTitle);
        } else if (btnTitle == S.current.already_finished) {
          _statusList = ['A'];
          updateGroupValue(btnType);
          _getTransferPlanList();
          print(btnTitle);
        } else if (btnTitle == S.current.cancel_plan) {
          _alertDialog();
        } else if (btnTitle == S.current.finished) {}
      },
      child: _textStyle(
          btnTitle, textColor, textSize, FontWeight.normal, TextAlign.center),
    );
  }

  //切换按钮
  Widget _toggleButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: GridView.count(
        padding: EdgeInsets.only(left: 75, right: 75),
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1 / 0.25,
        children: state.map((value) {
          return groupValue == value['type']
              ? _btnStyle(value['title'], value['type'], HsgColors.primary,
                  HsgColors.aboutusText, BorderSide.none, 14.0)
              : _btnStyle(
                  value['title'],
                  value['type'],
                  Color(0xFFFFFFFF),
                  Color(0xFF8B8B8B),
                  BorderSide(color: HsgColors.divider),
                  14.0);
        }).toList(),
      ),
    );
  }

//计划名称
  Widget _planName(String name) {
    return Container(
      color: Colors.white,
      height: 40,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        children: [
          _transferRecordImage(
              'images/transferIcon/transfer_plan.png', 15, 13, 13),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: ((MediaQuery.of(context).size.width - 30) * 3.3 / 4.3) - 15,
            child: _textStyle(S.current.plan_name_with_value + name,
                Colors.black, 12.0, FontWeight.normal, TextAlign.left),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 4.3,
            child: _btnStyle(
                btnTitle, null, btnColor, Colors.white, BorderSide.none, 13.0),
          ),
        ],
      ),
    );
  }

  //图标
  Widget _transferRecordImage(
      String imgurl, double width, double imageWidth, double imageHeight) {
    return Container(
      width: width,
      child: Image.asset(
        imgurl,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }

//虚线
  Widget _dottedLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(19.5, 15, 19.5, 15),
      child: DottedLine(),
    );
  }

//付款银行和收款银行
  Widget _bank(String bankName, String cardNo) {
    return Container(
      width: (MediaQuery.of(context).size.width -
              50 -
              (MediaQuery.of(context).size.width / 7)) /
          2,
      child: Column(
        children: [
          _textStyle(
              bankName, Colors.black, 18.0, FontWeight.bold, TextAlign.center),
          SizedBox(
            height: 10,
          ),
          _textStyle(cardNo, HsgColors.aboutusTextCon, 16.0, FontWeight.normal,
              TextAlign.center),
        ],
      ),
    );
  }

  //转账计划列表
  List<Widget> _transferPlanList() {
    List<Widget> section = [];
    section.add(
      SliverToBoxAdapter(
        child: _toggleButton(),
      ),
    );
    section.add(
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          planId = transferPlanList[index].planId;
          switch (transferPlanList[index].frequency) {
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
          switch (transferPlanList[index].transferType) {
            case '0':
              transferType = '行内转账';
              break;
            case '1':
              frequency = '跨行转账';
              break;
            default:
              frequency = '国际转账';
          }
          return FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              go2Detail(transferPlanList[index]);
            },
            child: Column(
              children: [
                _planName(transferPlanList[index].planName),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    children: [
                      _bank(
                          transferPlanList[index].payerName,
                          FormatUtil.formatSpace4(
                              transferPlanList[index].payerCardNo)),
                      _transferRecordImage(
                          'images/transferIcon/transfert_to.png',
                          MediaQuery.of(context).size.width / 7,
                          25,
                          25),
                      _bank(
                          transferPlanList[index].payeeName,
                          FormatUtil.formatSpace4(
                              transferPlanList[index].payeeCardNo)),
                    ],
                  ),
                ),
                _dottedLine(),
                _planInfo(
                    transferPlanList[index].debitCurrency +
                        ' ' +
                        transferPlanList[index].amount,
                    frequency,
                    transferPlanList[index].startDate,
                    transferPlanList[index].endDate,
                    transferPlanList[index].nextDate,
                    transferType),
              ],
            ),
          );
        }, childCount: transferPlanList.length),
      ),
    );
    return section;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.transfer_plan),
      ),
      body: CustomScrollView(
        slivers: _transferPlanList(),
      ),
    );
  }

  void _getTransferPlanList() {
    Future.wait({
      TransferDataRepository().getTransferPlanList(
          GetTransferPlanListReq(1, 10, '', _statusList, '0'),
          'getTransferPlanList')
    }).then((data) {
      data.forEach((value) {
        if (value is GetTransferPlanListResp) {
          setState(() {
            if (value.rows != null) {
              transferPlanList.clear();
              transferPlanList.addAll(value.rows);
            }
            if (groupValue == '0') {
              btnTitle = S.current.cancel_plan;
              btnColor = HsgColors.accent;
            } else {
              btnTitle = S.current.finished;
              btnColor = Color(0xFF00C16C);
            }
          });
        }
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

//页面跳转
  void go2Detail(TransferPlan transferPlan) {
    Navigator.pushNamed(context, pageTransferPlanDetails,
        arguments: transferPlan);
  }

  void _delTransferPlan() {
    Future.wait({
      TransferDataRepository().deleteTransferPlan(
          DeleteTransferPlanReq(planId), 'deleteTransferPlan')
    }).then((data) {
      setState(() {
        _statusList = ['P'];
        _getTransferPlanList();
      });
    });
  }
}
