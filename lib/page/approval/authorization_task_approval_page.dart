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
  var commentList = <CommentList>[];
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
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                children: [
                  _getHintLine(),
                  _getRow('账号名称', 'mike'),
                  _getHintLine(),
                  _getRow('转入货币', 'EUR')
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
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
                  _getRow('付款账户', history.processId),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                ],
              ),
            ),
          ),
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
          commentList.length > 0
              ? SliverList(
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
                                  _getRow('审批人', commentList[index].userName),
                                  //待办任务名称
                                  _getRow('审批时间', commentList[index].time),
                                  //创建时间
                                  _getRow('审批意见', commentList[index].comment),
                                  //审批结果
                                  _getRow('审批结果',
                                      commentList[index].result.toString()),
                                ],
                              ))
                        ],
                      ),
                    );
                  },
                  childCount: commentList.length,
                ))
              : SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: Text('无内容'),
                  ),
                ),
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
                  (_fromAccount == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("收款账户", _fromAccount),
                  _getHintLine(),
                  (_payeeName == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("账户名称", _payeeName),
                  _getHintLine(),
                  (_fromCcy == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("转入货币", _fromCcy),
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
                  (_accountNumber == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("付款账户", _accountNumber),
                  _getHintLine(),
                  (_accountName == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("账户名称", _accountName),
                  _getHintLine(),
                  (_payBank == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("付款银行", _payBank),
                  _getHintLine(),
                  (_toCcy == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("转出货币", _toCcy),
                  _getHintLine(),
                  (_toaccount == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("转出金额", _toaccount),
                  _getHintLine(),
                  (_remark == "" || _fromAccount == null)
                      ? Container()
                      : _getRow("附言", _remark),
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
          if (data != null) {
            commentList.clear();
            commentList.addAll(data.commentList);
          }
        });
      })
    });
  }
}
