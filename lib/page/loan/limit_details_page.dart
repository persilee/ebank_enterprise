/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 额度详情
/// Author: zhangqirong
/// Date: 2020-12-03

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/loan_account_model.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimitDetailsPage extends StatefulWidget {
  LimitDetailsPage({Key key}) : super(key: key);
  @override
  _LimitDetailsState createState() => _LimitDetailsState();
}

class _LimitDetailsState extends State<LimitDetailsPage> {
  //贷款账号
  String acNo = "";
  //客户号
  String ciNo = "";
  //合约编号
  String contactNo = "";
  //产品号
  String productCode = "";
  //机构代码
  String br = "";
  //显示是否在加载中
  bool _isload = true;
  //下拉刷新数据
  RefreshController _refreshController;

  var loanDetails = [];

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).loan_mineLoan_record_navTitle),
          centerTitle: true,
          elevation: 0,
        ),
        body: CustomRefresh(
            controller: _refreshController, //绑定刷新控件
            content: _isload ? HsgLoading() : _getlistViewList(context),
            onRefresh: () {
              //下拉刷新
              _loadData();
              _refreshController.refreshCompleted(); //刷新成功的操作
            },
            onLoading: () {
              //上拉加载更多
              _refreshController.loadNoData(); //暂无更多数据的操作
            }));
  }

  Future<void> _loadData() async {
    loanDetails.clear();
    //请求的参数
    final prefs = await SharedPreferences.getInstance();
    String cino = prefs.getString(ConfigKey.CUST_ID);
    ciNo = cino;

    contactNo = "";
    // LoanDataRepository()
    ApiClientLoan()
        .getLoanAccountList(LoanAccountMastModelReq(0, ciNo, contactNo))
        .then((data) {
      _refreshController.loadComplete();
      setState(() {
        _isload = false;
        if (data.loanAccountDOList != null) {
          loanDetails.clear();
          loanDetails.addAll(data.loanAccountDOList);
        }
      });
    }).catchError((e) {
      setState(() {
        SVProgressHUD.showInfo(status: e.toString());
        _refreshController.loadComplete();
        _isload = false;
      });
      loanDetails.clear();
    });
  }

  //封装ListView.Builder
  Widget _getListViewBuilder(Widget function) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  //生成ListView
  Widget _getlistViewList(BuildContext context) {
    if (_isload == false && loanDetails.length <= 0) {
      return Container(
        child: notDataContainer(context, S.current.no_data_now),
      );
    } else {
      List<Widget> _list = new List();
      for (int i = 0; i < loanDetails.length; i++) {
        _list.add(
            _getListViewBuilder(_limitDetailsIcon(context, loanDetails[i])));
      }
      return new ListView(
        children: _list,
      );
    }
  }

  //额度详情-封装
  Widget _limitDetailsIcon(BuildContext context, LoanAccountDOList loanDetail) {
    var titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          //合约账号
          S.of(context).loan_account + " " + loanDetail.lnac,
          style: TextStyle(fontSize: 15, color: Color(0xFF242424)),
        ),
        Icon(
          Icons.keyboard_arrow_right,
        ),
      ],
    );
    var titleBox = InkWell(
      onTap: () {
        //跳转
        _selectPage(context, loanDetail);
      },
      child: SizedBox(
        height: 46,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: titleRow,
            ),
          ],
        ),
      ),
    );
    var contentColumn = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        contentRow(
            //贷款金额
            S.of(context).loan_principal,
            FormatUtil.formatSringToMoney(loanDetail.amt.toString()) +
                loanDetail.ccy,
            Color(0xFF1E1E1E)),
        contentRow(
            //贷款余额
            S.of(context).loan_balance2,
            FormatUtil.formatSringToMoney(loanDetail.bal.toString()) +
                loanDetail.ccy,
            Color(0xFF1E1E1E)),
        contentRow(
            //开始日期
            S.of(context).begin_time,
            loanDetail.valDt,
            Color(0xFF1E1E1E)),
        contentRow(
            S.of(context).end_time, loanDetail.endDt, Color(0xFF1E1E1E)), //结束日期
        // contentRow(
        //     S.of(context).loan_interest_rate,
        //     (double.parse(loanDetail.intRate) * 100).toStringAsFixed(2) + "%",
        //     Color(0xFFF8514D)),
      ],
    );
    var contentBox = SizedBox(
        height: 150,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: contentColumn,
        ));

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBox,
          Divider(
            height: 0,
            color: HsgColors.textHintColor,
            indent: 20,
            endIndent: 20,
          ),
          contentBox,
        ],
      ),
    );
  }

  Widget contentRow(String leftcont, String rightcont, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftcont,
          style: TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
        ),
        Text(
          rightcont,
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }

  //跳转
  _selectPage(BuildContext context, LoanAccountDOList loanDetail) async {
    // List<String> pages = [
    //   S.of(context).view_details,
    //   S.of(context).view_repayment_plan,
    //   S.of(context).prepayment,
    // ];
    // final result = await showHsgBottomSheet(
    //     context: context,
    //     builder: (context) => BottomMenu(
    //           title: S.of(context).loan_account + ' ' + loanDetail.contactNo,
    //           items: pages,
    //         ));
    // if (result != null && result != false) {
    //   // loanDetails.debitAccount => '0101238000001758';;
    //   print('详情数据----$loanDetail.');
    //   switch (result) {
    //     case 0:
    //直接跳到查看详情
    Navigator.pushNamed(context, pageloanDetails,
        arguments: {'data': loanDetail});
    //       break;
    //     case 1:
    //       //查看还款计划
    //       Navigator.pushNamed(context, pageRepayPlan, arguments: loanDetail);
    //       break;
    //     case 2:
    //       //提前还款
    //       Navigator.pushNamed(context, pageRepayInput, arguments: loanDetail);
    //       break;
    //   }
    // } else {
    //   return;
    // }
  }
}
