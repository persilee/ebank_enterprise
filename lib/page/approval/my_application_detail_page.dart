/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///我的申请详情页面
/// Author: fangluyao
/// Date: 2020-12-30

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_application_task_detail.dart';
import 'package:ebank_mobile/data/source/model/approval/get_my_application.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:flutter/material.dart';

class MyApplicationDetailPage extends StatefulWidget {
  final MyApplicationDetail history;
  final title;
  MyApplicationDetailPage({Key key, this.history, this.title})
      : super(key: key);

  @override
  _MyApplicationDetailPageState createState() =>
      _MyApplicationDetailPageState(history);
}

class _MyApplicationDetailPageState extends State<MyApplicationDetailPage> {
  MyApplicationDetail history;
  _MyApplicationDetailPageState(this.history);
  var commentList = [];
  // var processId = "";

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
  var title = "";

  var _listDetail = [
    {
      'title': '转账信息',
      'rowList': [
        {'leftText': '用户账号', 'rightText': '5241548521225210'},
        {'leftText': '付款账户', 'rightText': '5241548521225210'},
        {'leftText': '服务', 'rightText': '5241548521225210'},
      ]
    },
    {
      'title': '付款信息',
      'rowList': [
        {'leftText': '用户账号11', 'rightText': '5241548521225210'},
        {'leftText': '付款账户11', 'rightText': '5241548521225210'},
        {'leftText': '服务11', 'rightText': '5241548521225210'},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadHistoryData(history.processId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          //  _sliverFixed(),
          _transferInfo(),
          _payInfo(),
          _historyHeader(),
          _historyContent(),
        ],
      ),
    );
  }

  // ignore: unused_element
  _sliverFixed() {
    return SliverFixedExtentList(
      delegate: SliverChildBuilderDelegate(
        _buildListItem,
        childCount: _listDetail.length,
      ),
      itemExtent: 200.5,
    );
  }

  ///底下列表
  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: _getFeatures(_listDetail[index]),
    );
  }

  ///列表单元格
  Widget _getFeatures(Map data) {
    //单元格详情
    Column _featuresDeatil = Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['title'],
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // _getRow(data['leftText'], data['rightText']),
        Container(
          // height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _craphicBtns(data),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        shadowColor: Color(0x46529F2E),
        child: _featuresDeatil,
      ),
    );
  }

  List<Widget> _craphicBtns(Map data) {
    List<Widget> btns = [];
    List dataList = data['rowList'];

    for (var i = 0; i < dataList.length; i++) {
      Map btnData = dataList[i];
      btns.add(
        Container(
          child: Column(
            children: [_getRow(btnData['leftText'], btnData['rightText'])],
          ),
        ),
      );
    }
    return btns;
  }

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
                  color: HsgColors.firstDegreeText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _historyContent() {
    return commentList.length > 0
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

//转账信息
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
                  _getTitle(S.current.transfer_info),
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
                  _getTitle(S.current.payment_info),
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
            child: Text(
              leftText,
              style: FIRST_DEGREE_TEXT_STYLE,
            ),
          ),
          Container(
            child: Text(
              rightText,
              style: TRANSFER_RECORD_POP_TEXT_STYLE,
            ),
          )
        ],
      ),
    );
  }

  _getTitle(String title) {
    return Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: HsgColors.firstDegreeText,
                ),
              ),
            )
          ],
        ));
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
      // NeedToBeDealtWithRepository()
      ApiClient()
          .findUserApplicationDetail(FindUserApplicationDetailReq(processId))
          .then((data) {
        setState(() {
          if (data != null) {
            commentList.clear();
            commentList.addAll(data.commentList);
          }
          if (data.operateEndValue != null) {
            _pay = false;
            _transfer = false;
            _accountNumber = data.operateEndValue.payAcNo;
            _accountName = data.operateEndValue.payAcNo;
            _payBank = data.operateEndValue.prdtCode;
            _toCcy = data.operateEndValue.ccy;
            _toaccount = data.operateEndValue.intentAmt;
            _remark = data.operateEndValue.remark;
            _fromAccount = data.operateEndValue.repaymentAcNo;
            _fromCcy = data.operateEndValue.ccy;
            _payeeName = data.operateEndValue.repaymentAcNo;
          }
        });
      })
    });
  }
}
