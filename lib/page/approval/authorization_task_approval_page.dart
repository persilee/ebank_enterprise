/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 授权记录任务审批页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task_detail.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class AuthorizationTaskApprovalPage extends StatefulWidget {
  final FinishTaskDetail history;

  AuthorizationTaskApprovalPage({Key key, this.history}) : super(key: key);

  @override
  _AuthorizationTaskApprovalPageState createState() =>
      _AuthorizationTaskApprovalPageState(history);
}

class _AuthorizationTaskApprovalPageState
    extends State<AuthorizationTaskApprovalPage> {
  FinishTaskDetail history;

  _AuthorizationTaskApprovalPageState(this.history);
  var commentList = <CommentList>[];
  //转账信息
  bool _transfer = true;
  var _fromAccount = "";
  var _fromCcy = "";
  var _payeeName = "";
  //付款信息
  bool _pay = true;
  var _accountNumber = "";
  var _accountName = "";
  var _payBank = "";
  var _toCcy = "";
  var _toaccount = "";
  var _remark = "";
  //基本信息
  bool _base = false;
  var _userId = "";

  var _processKey = "";

  var _processTitle = "";

  String _servCtr = "";

  @override
  void initState() {
    super.initState();
    _loadHistoryData(history.processId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.task_approval),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _baseInformation(),
          //  _transferInfo(),
          _payInfo(),
          _historyHeader(),
          _historyContent(),
        ],
      ),
    );
  }

  //历史记录标题
  _historyHeader() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            Container(
              child: Text(
                S.current.approval_histroy,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //授权历史记录
  _historyContent() {
    return commentList.length > 0
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SizedBox(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Column(
                          children: [
                            _getHintLine(),
                            _getRow(S.current.approver,
                                commentList[index].userName),
                            _getRow(S.current.approver_time,
                                commentList[index].time),
                            _getRow(S.current.approver_opinion,
                                commentList[index].comment),
                            _getRow(
                                S.current.approver_result,
                                commentList[index].result
                                    ? S.current.success
                                    : S.current.failed),
                          ],
                        ))
                  ],
                ),
              );
            },
            childCount: commentList.length,
          ))
        : SliverToBoxAdapter();
  }

  //基本信息
  _baseInformation() {
    return SliverToBoxAdapter(
      child: _base
          ? Container()
          : Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [_getTitle('基本信息')],
                      )),
                  _getHintLine(),
                  (_userId == "" || _userId == null)
                      ? Container()
                      : _getRow('用户账号', _userId),
                  _getHintLine(),
                  (_processKey == "" || _fromAccount == null)
                      ? Container()
                      : _getRow('任务名称', _processKey),
                  _getHintLine(),
                  (_processTitle == "" || _processTitle == null)
                      ? Container()
                      : _getRow('任务标题', _processTitle),
                  (_servCtr == "" || _servCtr == null)
                      ? Container()
                      : _getRow('服务', _servCtr),
                ],
              ),
            ),
    );
  }

  //转账信息
  // ignore: unused_element
  _transferInfo() {
    return SliverToBoxAdapter(
      child: _transfer
          ? Container()
          : Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [_getTitle(S.current.transfer_info)],
                      )),
                  _getHintLine(),
                  (_fromAccount == "" || _fromAccount == null)
                      ? Container()
                      : _getRow(S.current.transfer_to_account, _fromAccount),
                  _getHintLine(),
                  (_payeeName == "" || _payeeName == null)
                      ? Container()
                      : _getRow(S.current.userName, _payeeName),
                  _getHintLine(),
                  (_fromCcy == "" || _fromCcy == null)
                      ? Container()
                      : _getRow(S.current.from_ccy, _fromCcy),
                ],
              ),
            ),
    );
  }

//付款信息
  _payInfo() {
    return SliverToBoxAdapter(
      child: _pay
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [_getTitle(S.current.payment_info)],
                      )),
                  _getHintLine(),
                  (_accountNumber == "" || _accountNumber == null)
                      ? Container()
                      : _getRow(S.current.payment_account, _accountNumber),
                  _getHintLine(),
                  (_accountName == "" || _accountName == null)
                      ? Container()
                      : _getRow(S.current.userName, _accountName),
                  _getHintLine(),
                  (_payBank == "" || _payBank == null)
                      ? Container()
                      : _getRow(S.current.payment_bank, _payBank),
                  _getHintLine(),
                  (_toCcy == "" || _toCcy == null)
                      ? Container()
                      : _getRow(S.current.to_ccy, _toCcy),
                  _getHintLine(),
                  (_toaccount == "" || _toaccount == null)
                      ? Container()
                      : _getRow(S.current.to_amount, _toaccount),
                  _getHintLine(),
                  (_remark == "" || _remark == null)
                      ? Container()
                      : _getRow(S.current.postscript, _remark),
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

  _getTitle(title) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
          if (data != null) {
            commentList.clear();
            commentList.addAll(data.commentList);
          }
          if (data.operateEndValue != null) {
            _pay = false;
            _transfer = false;
            // _base = false;
            _accountNumber = data.operateEndValue.payerCardNo;
            _accountName = data.operateEndValue.payerName;
            _payBank = data.operateEndValue.payerBankCode;
            _toCcy = data.operateEndValue.debitCurrency;
            _toaccount = data.operateEndValue.amount;
            _remark = data.operateEndValue.remark;
            _fromAccount = data.operateEndValue.payeeBankCode;
            _fromCcy = data.operateEndValue.debitCurrency;
            _payeeName = data.operateEndValue.payeeName;
            _userId = data.userId;
            _processKey = data.processKey;
            _processTitle = data.processTitle;
            // _result = data.result;
            _servCtr = data.servCtr;
          }
        });
      })
    });
  }
}
