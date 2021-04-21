import 'package:ebank_mobile/data/source/loan_data_repository.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 还款记录页面
/// Author: zhangqirong
/// Date: 2020-12-15

import 'package:ebank_mobile/data/source/model/get_schedule_detail_list.dart';
import 'package:ebank_mobile/data/source/model/loan_detail_modelList.dart';
import 'package:ebank_mobile/data/source/model/loan_prepayment_model.dart';
import 'package:ebank_mobile/data/source/model/loan_repayment_record.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

class RepayRecordsPage extends StatefulWidget {
  final LnAcMastAppDOList loanDetail; //上界面传回来的模型
  RepayRecordsPage({Key key, this.loanDetail}) : super(key: key);

  @override
  _RepayRecordsState createState() => _RepayRecordsState();
}

class _RepayRecordsState extends State<RepayRecordsPage> {
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<LoanPrepaymentHistoryDTOList> lnScheduleList = [];

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

  // GetLnAcScheduleRspDetlsDTOList _list2 = new GetLnAcScheduleRspDetlsDTOList(
  //   "50000085",
  //   "0",
  //   "30",
  //   0,
  //   0,
  //   "2020-03-01",
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
    //已还本金 = 本金-余额
    paidPrincipal = (double.parse(widget.loanDetail.loanAmt) -
            double.parse(widget.loanDetail.osAmt))
        .toString();
    // _loadData();
    // 初次加载显示loading indicator, 会自动调用_loadData
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  Future<void> _loadData() async {
    lnScheduleList.clear();
    var req = new LoanRepaymentRecordReq(
      widget.loanDetail.contactNo, //合约号
    );
    SVProgressHUD.show();
    // LoanDataRepository()
    ApiClientLoan().getScheduleRecordDetailList(req).then((data) {
      if (data.loanPrepaymentHistoryDTOList != null) {
        SVProgressHUD.dismiss();
        setState(() {
          lnScheduleList.clear();
          lnScheduleList.addAll(data.loanPrepaymentHistoryDTOList);
        });
      }
    }).catchError((e) {
      SVProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(S.of(context).repayment_record),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: refrestIndicatorKey,
        child: Column(
          children: [
            _getHeader(paidPrincipal),
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
    print(lnScheduleList.length);
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
  Widget _getHeader(String paidMoney) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 21, 20, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getHeadBox(S.of(context).paid_principal + ": ",
              widget.loanDetail.ccy + FormatUtil.formatSringToMoney(paidMoney)),
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
  Widget _getContent(LoanPrepaymentHistoryDTOList lnSchedule) {
    var instalDate = lnSchedule.trDt;
    var year = instalDate.substring(0, 4);
    var day = instalDate.substring(5);
    // var instalType = lnSchedule.instalType; //还款状态 未还NONE、部分还款PART、全额还款ALL
    // var repay = '还款'; //还款
    // switch (instalType) {
    //   case 'NONE':
    //     instalType = ' (未还) ';
    //     break;
    //   case 'PART':
    //     instalType = ' (部分还款) ';
    //     break;
    //   case 'ALL':
    //     instalType = ' (全部还款) ';
    //     repay = '';
    //     break;
    //   default:
    // }

    String totalValue =
        (double.parse(lnSchedule.payPrin) + double.parse(lnSchedule.payInt))
            .toString();
    var instalOutstAmt = FormatUtil.formatSringToMoney(totalValue); //归还金额合计
    var principalAmt = FormatUtil.formatSringToMoney(lnSchedule.payPrin); //本金金额
    var interestAmt = FormatUtil.formatSringToMoney(lnSchedule.payInt); //利息

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
              // Text(
              //   '正常还款',
              //   style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
              // ),
              // InkWell(
              //   onTap: () {
              //     //跳转
              //     Fluttertoast.showToast(
              //       msg: '还款中...',
              //       gravity: ToastGravity.CENTER,
              //     );
              // },
              // child: Text(
              //   repay,
              //   style: TextStyle(
              //       fontSize: 13,
              //       color: Color(0xFF4871FF),
              //       decoration: TextDecoration.underline),
              // ),
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
