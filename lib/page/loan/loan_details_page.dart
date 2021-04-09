import 'package:ebank_mobile/data/source/loan_data_repository.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款详情界面
/// Author: fangluyao
/// Date: 2020-12-03
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/data/source/model/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan_detail_modelList.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class LoanDetailsPage extends StatefulWidget {
//如果需要在initState里面拿到传过来的值。必须在一开始就需要去实例化它
  final LoanAccountDOList loanAccountDetail;
  LoanDetailsPage({Key key, this.loanAccountDetail}) : super(key: key);

  @override
  _LoanDetailsPageState createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  // LoanAccountDOList loanAccountDetail;
  var loanDetailsArr = []; //币种列表、

  // @override
  void initState() {
    super.initState();
    _loadDetailData(); //获取列表数据
  }

  //获取底部详情数据
  Future<void> _loadDetailData() async {
    //请求的参数
    String acNo = widget.loanAccountDetail.lnac; //贷款帐号
    String ciNo = "";
    String contactNo = "";
    String productCode = "";
    SVProgressHUD.show();
    LoanDataRepository()
        .getLoanList(LoanDetailMastModelReq(acNo, ciNo, contactNo, productCode),
            'getLoanList')
        .then((data) {
      SVProgressHUD.dismiss();
      if (data.lnAcMastAppDOList != null) {
        setState(() {
          loanDetailsArr.clear();
          loanDetailsArr.addAll(data.lnAcMastAppDOList);
        });
      }
    }).catchError((e) {
      SVProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
    loanDetailsArr.clear();
  }

  @override
  Widget build(BuildContext context) {
    // LoanAccountDOList loanDetail = ModalRoute.of(context).settings.arguments;
    // this.loanAccountDetail = loanDetail;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loan_detail),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: _getContent(),
      ),
    );
  }

  //业务品种
  Widget _business(String acNo) {
    return _getSingleBox(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 业务品种
            Text(
              S.current.loan_account + ': ' + acNo,
              // "贷款账号",
              style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
            ),
            //贷款编号
            Container(
              margin: EdgeInsets.only(top: 13.5),
              child: Text(
                acNo,
                style: TextStyle(fontSize: 16, color: HsgColors.aboutusTextCon),
              ),
            ),
          ],
        ),
      ),
      _collectButton(), //领用按钮
    );
  }

  //竖线条
  Widget _verticalMoulding() {
    return Padding(
      padding: EdgeInsets.only(right: 30),
      child: SizedBox(
        width: 1,
        height: 30,
        child: DecoratedBox(
          decoration: BoxDecoration(color: HsgColors.textHintColor),
        ),
      ),
    );
  }

  //贷款额
  Widget _loanMoney(String loanName, String money) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loanName,
            style: TextStyle(fontSize: 13, color: HsgColors.describeText),
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Text(
            // '￥' +
            FormatUtil.formatSringToMoney(money),
            style: TextStyle(fontSize: 16, color: HsgColors.aboutusTextCon),
          ),
        ],
      ),
    );
  }

  //页面跳转
  Widget _jumpPage(String jumpPage, var transfer) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, jumpPage, arguments: transfer);
      },
      // child: _getSingleBox(text, icon),
    );
  }

  //获得单条内容
  Widget _getSingleBox(Widget name, Widget content) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              name,
              content,
            ],
          ),
        ],
      ),
    );
  }

  Type arb() => S;

  //领用按钮
  Widget _collectButton() {
    return Container(
      width: 62.5,
      height: 28.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HsgColors.plainBtn, width: 0.5),
        borderRadius: BorderRadius.circular((5)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Text(
          S.current.loan_lines_get,
          style: TextStyle(
            fontSize: 13,
            color: HsgColors.plainBtn,
          ),
        ),
        onPressed: () {
          //需要先判断当前额度是否大于0
          if (double.parse(widget.loanAccountDetail.bal) <= 0) {
            SVProgressHUD.showInfo(
                status: S.current.loan_detail_available_insufficient);
          } else {
            //传值过去
            Navigator.pushNamed(context, pageLoanReference,
                arguments: widget.loanAccountDetail);
          }
        },
      ),
    );
  }

//一行文字
  Widget _rowText(String leftText, String rightText, Color color) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(fontSize: 14, color: HsgColors.secondDegreeText),
          ),
          Text(
            rightText,
            style: TextStyle(fontSize: 14, color: color),
          ),
        ],
      ),
    );
  }

//合约列表
  List<Widget> _getContent() {
    List<Widget> section = [];

    section.add(
      SliverToBoxAdapter(
        child: Container(
          // margin: EdgeInsets.only(bottom: 12),
          color: Colors.white,
          child: Column(
            children: [
              //业务品种
              _business(widget.loanAccountDetail.lnac),
              Divider(height: 0, color: HsgColors.textHintColor),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                child: Row(
                  children: [
                    //总额度
                    _loanMoney(
                        S.current.amount +
                            ' (' +
                            widget.loanAccountDetail.ccy +
                            ')',
                        widget.loanAccountDetail.amt),
                    _verticalMoulding(),
                    //余额额度
                    _loanMoney(
                        S.current.loan_detail_available_amount +
                            ' (' +
                            widget.loanAccountDetail.ccy +
                            ')',
                        widget.loanAccountDetail.bal),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    section.add(
      loanDetailsArr.length <= 0
          ? SliverToBoxAdapter(
              child: Container(
                  // margin: EdgeInsets.only(top: 100),
                  // child: notDataContainer(context, S.current.no_data_now),
                  ),
            )
          : SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                LnAcMastAppDOList detailModel = loanDetailsArr[index];
                //存入金额
                var rate = [
                  _rowText(
                      S.current.loan_principal,
                      detailModel.loanAmt.toString() + ' ' + detailModel.ccy,
                      HsgColors.secondDegreeText), //金额
                  _rowText(
                      S.current.loan_balance2,
                      detailModel.osAmt + " " + detailModel.ccy,
                      HsgColors.secondDegreeText), //余额
                  _rowText(S.current.begin_time, detailModel.disbDate,
                      HsgColors.secondDegreeText), //开始时间
                  _rowText(S.current.end_time, detailModel.maturityDate,
                      HsgColors.secondDegreeText), //结束时间
                  _rowText(S.of(context).loan_interest_rate,
                      detailModel.intRate + "%", Color(0xFFF8514D)),
                ];
                //整存整取
                var taking = Column(
                  children: [
                    Container(
                      //顶部线条
                      height: 13,
                      color: Color(0xFFF7F7F7),
                    ),
                    Container(
                      //合约号
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 45,
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              //合约账号
                              S.current.contract_number +
                                  ' ' +
                                  detailModel.contactNo,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: HsgColors.aboutusTextCon),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                //点击弹窗
                                _selectPage(context, detailModel);
                              },
                              child: Image(
                                width: 15,
                                image: AssetImage(
                                    'images/loanProduct/loan_apply_more.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0, color: HsgColors.textHintColor),
                    Container(
                      // height: 125,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: rate,
                        ),
                      ),
                    ),
                  ],
                );
                return taking;
              }, childCount: loanDetailsArr.length //需要标注子类的个数
                      ),
            ),
    );
    return section;
  }

  //弹窗跳转
  _selectPage(BuildContext context, LnAcMastAppDOList loanDetail) async {
    List<String> pages = [
      S.current.repayment_record,
      S.of(context).view_repayment_plan,
      S.of(context).prepayment,
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.loan_opration_alert,
              items: pages,
            ));
    if (result != null && result != false) {
      // loanDetails.debitAccount => '0101238000001758';;
      // print('详情数据----$loanDetail.');
      switch (result) {
        case 0:
          //直接还款记录
          Navigator.pushNamed(context, pageRepayRecords, arguments: loanDetail);
          break;
        case 1:
          //查看还款计划
          Navigator.pushNamed(context, pageRepayPlan, arguments: loanDetail);
          break;
        case 2:
          //提前还款
          Navigator.pushNamed(context, pageRepayInput, arguments: loanDetail);
          break;
      }
    } else {
      return;
    }
  }
}
