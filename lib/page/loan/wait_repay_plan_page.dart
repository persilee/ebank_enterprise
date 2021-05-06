/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 待还记录页面
/// Author: zhangqirong
/// Date: 2020-12-15

import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_schedule_detail_list.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

class WaitRepayPlanPage extends StatefulWidget {
  @override
  _WaitRepayPlanState createState() => _WaitRepayPlanState();
}

class _WaitRepayPlanState extends State<WaitRepayPlanPage> {
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
  //已还本金
  var paidPrincipal = '';
  //待还本金
  var notPaidPrincipal = '2000';
  // GetLnAcScheduleRspDetlsDTOList _list1 = new GetLnAcScheduleRspDetlsDTOList(
  //   "50000085",
  //   "0",
  //   "30",
  //   0,
  //   0,
  //   "2020-04-01",
  //   "2000",
  //   "NORMAL",
  //   "NONE",
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
    _loadData();
    // 初次加载显示loading indicator, 会自动调用_loadData
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  Future<void> _loadData() async {
    // var req =
    //     new GetScheduleDetailListReq(acNo, page, pageSize, repaymentStatus);
    // LoanDataRepository()
    //     .getScheduleDetailList(req, 'getScheduleDetailList')
    //     .then((data) {
    //   if (data.getLnAcScheduleRspDetlsDTOList != null) {
    //     setState(() {
    //       lnScheduleList.clear();
    //       lnScheduleList.addAll(data.getLnAcScheduleRspDetlsDTOList);
    //     });
    //   }
    // }).catchError((e) {
    //   HSProgressHUD.showToast(e.error);
    // });
    lnScheduleList.clear();
    // lnScheduleList.add(_list1);
  }

  @override
  Widget build(BuildContext context) {
    Loan loanDetail = ModalRoute.of(context).settings.arguments;
    setState(() {
      acNo = loanDetail.acNo;
      page = "1";
      pageSize = "1000";
      repaymentStatus = "";
    });
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
        title: Text(S.of(context).wait_repayment_plan),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: refrestIndicatorKey,
        child: Column(
          children: [
            _getHeader(notPaidPrincipal, loanDetail.restPeriods.toString()),
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
    for (int i = 0; i < lnScheduleList.length; i++) {
      // if (lnScheduleList[i].instalType == 'PART' ||
      //     lnScheduleList[i].instalType == 'NONE') {
      //   _list.add(getListViewBuilder(_getContent(lnScheduleList[i])));
      // }
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
  Widget _getHeader(String money, String nums) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 21, 20, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getHeadBox(S.of(context).remaining_principal + ":",
              " HKD " + FormatUtil.formatSringToMoney(money)),
          Padding(padding: EdgeInsets.only(top: 9)),
          SizedBox(
            child: Row(
              children: [
                //贷款余额
                Text(
                  S.of(context).remaining_periods +
                      ": " +
                      nums +
                      S.of(context).periods,
                  style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
                ),
              ],
            ),
          ),
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
    var instalDate = ''; //lnSchedule.instalDate;
    var year = instalDate.substring(0, 4);
    var day = instalDate.substring(5);
    var instalType = ''; //lnSchedule.instalType; //还款状态 未还NONE、部分还款PART、全额还款ALL
    var repay = '还款'; //还款
    switch (instalType) {
      case 'NONE':
        instalType = ' (未还) ';
        break;
      case 'PART':
        instalType = ' (部分还款) ';
        break;
      case 'ALL':
        instalType = ' (全部还款) ';
        repay = '';
        break;
      default:
    }
    var instalOutstAmt =
        ''; //FormatUtil.formatSringToMoney(lnSchedule.instalOutstAmt); //归还金额合计
    var principalAmt = '';
    // FormatUtil.formatSringToMoney(lnSchedule.principalAmt); //本金金额
    var interestAmt = '';
    // FormatUtil.formatSringToMoney(lnSchedule.interestAmt); //利息

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
              opacity: 0.2,
              child: Container(
                width: 7,
                height: 7,
                child: CircleAvatar(
                  radius: 6.0,
                ),
              )),
        ),
        Opacity(
            opacity: 0.1,
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
                instalType,
                style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
              ),
              // InkWell(
              //   onTap: () {
              //     //跳转
              // HSProgressHUD.showToastTip(
              //   '还款中...',
              // );
              //   },
              //   child: Text(
              //     repay,
              //     style: TextStyle(
              //         fontSize: 13,
              //         color: Color(0xFF4871FF),
              //         decoration: TextDecoration.underline),
              //   ),
              // ),
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
                    interestAmt,
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
