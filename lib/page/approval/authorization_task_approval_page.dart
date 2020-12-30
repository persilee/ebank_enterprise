/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task_detail.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class AuthorizationTaskApprovalPage extends StatefulWidget {
  final Rows history;
  AuthorizationTaskApprovalPage({Key key, this.history}) : super(key: key);

  @override
  _AuthorizationTaskApprovalPageState createState() =>
      _AuthorizationTaskApprovalPageState(history);
}

class _AuthorizationTaskApprovalPageState
    extends State<AuthorizationTaskApprovalPage> {
  Rows history;
  _AuthorizationTaskApprovalPageState(this.history);
  //转账信息
  bool _transfer = false;
  var _fromAccount = "";
  var _fromCcy = "";
  var _payeeName = "";
  //付款信息
  bool _pay = false;
  var _accountNumber = "";
  var _accountName = "";
  var _payBank = "";
  var _toCcy = "";
  var _toaccount = "";
  var _remark = "";

  @override
  void initState() {
    super.initState();
    _loadHistoryData(history.processId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务审批'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _tansferInfo(),
          _payInfo(),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      '审批历史',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SizedBox(
                child: Column(
                  children: [
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Column(
                          children: [
                            _getHintLine(),
                            //发起人
                            _getRow('审批人', '77664564548'),
                            //待办任务名称
                            _getRow('审批时间', '一对一转账审批'),
                            //创建时间
                            _getRow('审批意见', '2020-11-11 14:16:24'),
                            //审批结果
                            _getRow('审批结果', 'ok'),
                          ],
                        ))
                  ],
                ),
              );
            },
            childCount: 4,
          ))
        ],
      ),

      // child: child,
    );
  }

//转账信息
  _tansferInfo() {
    return SliverToBoxAdapter(
      child: !_transfer
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              '转账信息',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )),
                  _getHintLine(),
                  _fromAccount == ""
                      ? Container()
                      : _getRow("收款账户", _fromAccount),
                  _getHintLine(),
                  _payeeName == "" ? Container() : _getRow("账户名称", _payeeName),
                  _getHintLine(),
                  _fromCcy == "" ? Container() : _getRow("转入货币", _fromCcy),
                ],
              ),
            ),
    );
  }

//付款信息
  _payInfo() {
    return SliverToBoxAdapter(
      child: !_pay
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              '付款信息',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )),
                  _getHintLine(),
                  _accountNumber == ""
                      ? Container()
                      : _getRow("付款账户", _accountNumber),
                  _getHintLine(),
                  _accountName == ""
                      ? Container()
                      : _getRow("账户名称", _accountName),
                  _getHintLine(),
                  _payBank == "" ? Container() : _getRow("付款银行", _payBank),
                  _getHintLine(),
                  _toCcy == "" ? Container() : _getRow("转出货币", _toCcy),
                  _getHintLine(),
                  _toaccount == "" ? Container() : _getRow("转出金额", _toaccount),
                  _getHintLine(),
                  _remark == "" ? Container() : _getRow("附言", _remark),
                ],
              ),
            ),
    );
  }

  _getRow(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(leftText),
          ),
          Container(
            child: Text(rightText),
          )
        ],
      ),
    );
  }

  _getHintLine() {
    return Container(
        child: Divider(
      color: HsgColors.divider,
      height: 0.5,
    ));
  }

  void _loadHistoryData(String processId) {
    Future.wait({
      NeedToBeDealtWithRepository()
          .findUserFinishedDetail(
              GetFindUserFinishedDetailReq(processId), 'findUserFinishedDetail')
          .then((data) {
        setState(() {
          if (data.operateEndValue != null) {
            _pay = true;
            _transfer = true;
            _accountNumber = data.operateEndValue.payerCardNo;
            _accountName = data.operateEndValue.payerName;
            _payBank = data.operateEndValue.payerBankCode;
            _toCcy = data.operateEndValue.debitCurrency;
            _toaccount = data.operateEndValue.amount;
            _remark = data.operateEndValue.remark;
            _fromAccount = data.operateEndValue.payeeBankCode;
            _fromCcy = data.operateEndValue.debitCurrency;
            _payeeName = data.operateEndValue.payeeName;
          }
        });
        print(data.commentList.toString());
      })
    });
  }
}
