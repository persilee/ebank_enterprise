import 'package:ebank_mobile/data/source/model/loan/get_schedule_detail_list.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_detail_modelList.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 还款计划页面
/// Author: zhangqirong
/// Date: 2020-12-10

import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class RepayPlanPage extends StatefulWidget {
  final LnAcMastAppDOList loanDetail; //上界面传回来的模型
  RepayPlanPage({Key key, this.loanDetail}) : super(key: key);

  @override
  _RepayPlanState createState() => _RepayPlanState();
}

class _RepayPlanState extends State<RepayPlanPage> {
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<GetLnAcScheduleRspDetlsDTOList> lnScheduleList =
      List<GetLnAcScheduleRspDetlsDTOList>();
  //贷款账号
  String acNo;
  //页码
  String page;
  //一页数据条数
  String pageSize;
  //还款状态
  String repaymentStatus;
  // GetLnAcScheduleRspDetlsDTOList _list1 = new GetLnAcScheduleRspDetlsDTOList(
  //   "50000085",
  //   "0",
  //   "30",
  //   0,
  //   0,
  //   "2020-02-01",
  //   "2014.67",
  //   "NORMAL",
  //   "ALL",
  //   "14.67",
  //   "2020-03-20",
  //   "200",
  //   "2000",
  //   "2020-03-20",
  //   "2020-03-20",
  //   "0",
  // );

  @override
  void initState() {
    super.initState();
    page = "1";
    pageSize = "1000";
    _loadData();
    // 初次加载显示loading indicator, 会自动调用_loadData
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  Future<void> _loadData() async {
    var req = new GetScheduleDetailListReq(
        widget.loanDetail.contactNo,
        //  page,
        //  pageSize,
        'Q');
    HSProgressHUD.show();
    // LoanDataRepository()
    ApiClientLoan().getSchedulePlanDetailList(req).then((data) {
      HSProgressHUD.dismiss();
      if (data.getLnAcScheduleRspDetlsDTOList != null) {
        setState(() {
          lnScheduleList.clear();
          lnScheduleList.addAll(data.getLnAcScheduleRspDetlsDTOList);
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
    lnScheduleList.clear();
    // lnScheduleList.add(_list1);
    // lnScheduleList.add(_list2);
    // lnScheduleList.add(_list3);
  }

  @override
  Widget build(BuildContext context) {
    // LnAcMastAppDOList loanDetail = ModalRoute.of(context).settings.arguments;
    // setState(() {
    //   acNo = loanDetail.acNo;

    //   repaymentStatus = "";
    // });
    var stackList = Stack(
      fit: StackFit.loose,
      children: [
        //竖线
        Positioned(
          left: 88,
          top: 10,
          bottom: 15,
          child: VerticalDivider(
            width: 1,
            color: Color(0x16000000),
          ),
        ),
        listViewList(context),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).repayment_plan),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: refrestIndicatorKey,
        child: Column(
          children: [
            _getHeader(widget.loanDetail),
            Expanded(
              child: stackList,
            ),
          ],
        ),
        onRefresh: _loadData,
      ),
    );
  }

  Widget listViewList(BuildContext context) {
    List<Widget> _list = new List();
    //按日期降序排序
    // for (int i = lnScheduleList.length - 1; i >= 0; i--) {
    for (int i = 0; i < lnScheduleList.length; i++) {
      _list.add(getListViewBuilder(_getContent(lnScheduleList[i])));
    }
    return new ListView(
      children: _list,
    );
  }

  //封装ListView.Builder
  Widget getListViewBuilder(Widget function) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  Widget _getHeadBox(String left, String right) {
    return SizedBox(
      child: Row(
        children: [
          //贷款余额
          Text(
            left,
            style: TextStyle(fontSize: 13, color: Color(0xFF262626)),
          ),
          Text(
            right,
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          ),
        ],
      ),
    );
  }

  //获取头部(贷款本金，贷款余额)
  Widget _getHeader(LnAcMastAppDOList loanDetail) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 21, 20, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getHeadBox(
              S.of(context).loan_principal + ":",
              loanDetail.ccy +
                  ' ' +
                  FormatUtil.formatSringToMoney(loanDetail.loanAmt)),
          Padding(padding: EdgeInsets.only(top: 9)),
          _getHeadBox(
              S.of(context).loan_balance2 + ":",
              loanDetail.ccy +
                  ' ' +
                  FormatUtil.formatSringToMoney(loanDetail.osAmt)),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            height: 20,
            child: Divider(
              height: 0,
              color: Color(0xFFE9E9E9),
            ),
          ),
        ],
      ),
    );
  }

  //获取内容(左[日期] 中[时间轴] 右[还款详情])
  Widget _getContent(GetLnAcScheduleRspDetlsDTOList lnSchedule) {
    var instalDate = lnSchedule.payDt;
    instalDate = instalDate.trim();
    var year = instalDate.substring(0, 4);
    var day = instalDate.substring(5);
    // 是否到期 是否还款
    // -----------
    // 未到期 1.未还款 2，部分还款 3.已还款 不显示还款
    // 已到期未逾期 1.未还款 2，部分还款 3.已还款  显示还款
    // 已逾期 1.未还款 2，部分还款 3.已还款  显示还款
    // 存在逾期未还款。需要先还逾期的，再还当前期数。

    var instalType = lnSchedule.paySts; //还款状态 0：未还 1：逾期 2：已还
    var repay = '还款'; //还款
    switch (instalType) {
      case '0':
        instalType = ' (未还) ';
        break;
      case '1':
        instalType = ' (逾期) '; //(部分还款)
        break;
      case '2':
        instalType = ' (全部还款) ';
        repay = '';
        break;
      default:
    }

    double currentPenAmt = double.parse(lnSchedule.payPrin) -
        double.parse(lnSchedule.recPrin); //当前本金金额
    double currentInterestAmt =
        double.parse(lnSchedule.payInt) - double.parse(lnSchedule.recInt); //利息
    double currentAmorIntAmt =
        (double.parse(lnSchedule.payPen) + double.parse(lnSchedule.payCom)) -
            (double.parse(lnSchedule.recPen) +
                double.parse(lnSchedule.recCom)); //利息罚息

    double currentAmt = currentPenAmt + currentInterestAmt + currentAmorIntAmt;

    var instalOutstAmt =
        FormatUtil.formatSringToMoney(currentAmt.toString()); //归还金额合计
    var principalAmt = FormatUtil.formatSringToMoney(
        currentPenAmt.toString()); //本金金额 lnSchedule.recPrin
    var interestAmt = FormatUtil.formatSringToMoney(
        currentInterestAmt.toString()); //利息lnSchedule.interestAmt
    var amorIntAmt = ''; //罚息 lnSchedule.amorIntAmt
    // if (lnSchedule.amorIntAmt == null) {
    //   amorIntAmt = '0.00';
    // } else {
    amorIntAmt = currentAmorIntAmt.toString();
    // }

    var leftCont = Container(
      width: 66,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            child: Text(
              day,
              style: TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
            ),
          ),
          SizedBox(
            child: Text(
              year,
              style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
            ),
          ),
        ],
      ),
    );
    var stackCont = Stack(
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.loose,
      textDirection: TextDirection.rtl,
      children: [
        Align(
          heightFactor: 2,
          child: Opacity(
              opacity: 0.6,
              child: Container(
                width: 7,
                height: 7,
                child: CircleAvatar(
                  radius: 6.0,
                ),
              )),
        ),
        Opacity(
            opacity: 0.5,
            child: Container(
              width: 15,
              height: 15,
              child: CircleAvatar(
                radius: 6.0,
              ),
            )),
      ],
    );
    var centerCont = Container(
      width: 24,
      child: Column(
        children: [
          stackCont,
        ],
      ),
    );
    var rightCont = Container(
      width: 250,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                instalOutstAmt,
                style: TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
              ),
              Text(
                instalType, //instalType
                style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
              ),
              InkWell(
                onTap: () {
                  //跳转loan_plan提前还款
                  Map detailMap = Map();
                  detailMap['detailModel'] = lnSchedule;
                  detailMap['loanDetail'] = widget.loanDetail; //0不是还款计划

                  Navigator.pushNamed(context, pageRepaymentPlan,
                      arguments: detailMap); //需要传不同的参数进去
                  //跳转
                },
                child: Text(
                  repay, //repay
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4871FF),
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Wrap(
            spacing: 20, //左右组件间距
            runSpacing: 30, //上下组件间距
            alignment: WrapAlignment.spaceEvenly, //横轴对齐方式
            runAlignment: WrapAlignment.end,
            children: [
              Text(
                S.of(context).with_principal +
                    " " +
                    principalAmt +
                    " " +
                    S.of(context).interest_amt +
                    " " +
                    interestAmt +
                    " " +
                    S.of(context).punishment_interest +
                    " " +
                    amorIntAmt,
                maxLines: 250,
                style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          SizedBox(
            width: 250,
            child: Divider(
              height: 0,
              color: Color(0xFFE4E4E4),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leftCont,
          centerCont,
          rightCont,
        ],
      ),
    );
  }
}
