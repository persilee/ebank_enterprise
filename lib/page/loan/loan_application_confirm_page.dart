import 'dart:io';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/loan_application.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanConfirmApplicationList extends StatefulWidget {
  @override
  _LoanConfirmStatePage createState() => _LoanConfirmStatePage();
}

class _LoanConfirmStatePage extends State<LoanConfirmApplicationList> {
  Map _reviewMap = {};
  Map _requstMap = {};

  final f = NumberFormat("#,##0.00", "en_US"); //USD有小数位的处理
  final fj = NumberFormat("#,##0", "ja-JP"); //日元没有小数位的处理

  @override
  Widget build(BuildContext context) {
    Map listData = ModalRoute.of(context).settings.arguments;
    _reviewMap = listData['reviewList'];
    _requstMap = listData['requestList'];

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(S.current.loan_application_confirm_NavTitle),
          centerTitle: true,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          height: double.infinity,
          child: Container(
            color: HsgColors.commonBackground,
            child: ListView(children: [
              Container(
                // //第一组
                color: Colors.white,
                child: Column(
                  children: [
                    _firstGroup(),
                  ],
                ),
              ),
              Container(
                //第二组横线
                height: 20,
                color: HsgColors.commonBackground,
              ),
              Container(
                //第三组
                color: Colors.white,
                child: Column(
                  children: [
                    _sectionGroup(), //调用组件
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  //第一组
  Widget _firstGroup() {
    String balStr = _reviewMap['ccy'] == 'JPY'
        ? fj.format(double.parse(_reviewMap['intentAmt'] ?? '0')) ?? ''
        : f.format(double.parse(_reviewMap['intentAmt'] ?? '0')) ?? '';

    return Container(
      color: Colors.white,
      child: Column(children: [
        //贷款产品
        _textFieldCommonFunc(
            S.current.loan_New_product_column, _reviewMap['prdtCode']),
        _addLinne(),
        //申请金额
        _textFieldCommonFunc(S.current.apply_amount, balStr),
        _addLinne(),
        //贷款期限
        _textFieldCommonFunc(S.current.loan_duration, _reviewMap['timeLimit']),
        _addLinne(),
        //支出币种
        _textFieldCommonFunc(S.current.debit_currency, _reviewMap['ccy']),
        _addLinne(),
        //贷款目的
        _textFieldCommonFunc(S.current.loan_purpose, _reviewMap['loanPurpose']),
        _addLinne(),
        //放款帐号
        _textFieldCommonFunc(S.current.loan_Disbursement_Account_column,
            FormatUtil.formatSpace4(_reviewMap['payAcNo'])),
        _addLinne(),
        //还款帐号
        _textFieldCommonFunc(S.current.loan_Repayment_account_column,
            FormatUtil.formatSpace4(_reviewMap['repaymentAcNo'])),
        _addLinne(),
        //还款方式
        _textFieldCommonFunc(S.current.loan_Repayment_method_column,
            _reviewMap['repaymentMethod']),
        _addLinne(),
        //贷款利率
        // _textFieldCommonFunc(
        // S.current.loan_Interest_Rate_column, _reviewMap['loanRate']),
      ]),
    );
  }

  Widget _addLinne() {
    return Divider(
      color: Color(0xFFD8D8D8),
      height: 1,
      indent: 15,
      endIndent: 15,
      thickness: 1,
    );
  }

  //第二组
  Widget _sectionGroup() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //联系人
          _textFieldCommonFunc(S.current.contact, _reviewMap['contact']),
          _addLinne(),
          //联系人手机号码
          _textFieldCommonFunc(
              S.current.contact_phone_num, _reviewMap['phone']),
          _addLinne(),
          //备注
          _textFieldCommonFunc(S.current.remark, _reviewMap['remark']),
          _addLinne(),

          Container(
            //申请按钮
            margin: EdgeInsets.only(top: 40, bottom: 20),
            child: HsgButton.button(
              title: S.current.apply,
              click: _openBottomSheet,
              isColor: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldCommonFunc(String columnName, String detailStr) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            columnName,
            style: TextStyle(),
            textAlign: TextAlign.start,
          ),
          Text(
            detailStr,
            style: TextStyle(),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  //点击确认页面
  _openBottomSheet() async {
    final prefs = await SharedPreferences.getInstance();
    String userPhone = prefs.getString(ConfigKey.USER_PHONE);
    String custID = prefs.getString(ConfigKey.CUST_ID);
    String userAccount = prefs.getString(ConfigKey.USER_ACCOUNT);
    String userID = prefs.getString(ConfigKey.USER_ID);
    String userType = prefs.getString(ConfigKey.USER_TYPE);

    print(userPhone);
    print(custID);
    print(userAccount);
    print(userID);

    SVProgressHUD.show();
    // LoanDataRepository()
    ApiClientLoan()
        .submitLoanApplication(
      LoanApplicationReq(
        _requstMap['ccy'].toString(), //币种
        custID, //用户custID
        _requstMap['contact'], //联系人
        double.parse(_requstMap['intentAmt']), //金额
        _requstMap['loanPurpose'], //贷款目的
        _requstMap['phone'], //手机号
        _requstMap['prdtCode'], //贷款产品码 TDCBCBNF _requstMap['prdtCode']
        _requstMap['remark'], //备注
        _requstMap['repaymentMethod'], //还款方式
        '2', //单位 月份MONTH
        int.parse(_requstMap['termValue']), //日期code
        userAccount, //用户帐号
        userID, //用户ID
        userType, //用户类型
        _requstMap['repaymentAcNo'], //还款帐号
        _requstMap['payAcNo'], //收款账号
        _requstMap['loanRate'], //利率
      ),
    )
        .then((data) async {
      SVProgressHUD.showSuccess(status: S.current.total_opration_audit_tip);
      await sleep(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return IndexPage();
      }), (Route route) {
        //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
        print(route.settings?.name);
        if (route.settings?.name == "/") {
          return true; //停止
        }
        return false; //继续关闭
      });
    }).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showError(status: e.toString());
    });
  }
}
