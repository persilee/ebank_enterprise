import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan_calculate_interest.dart';
import 'package:ebank_mobile/data/source/model/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan_trail_commit.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/page/loan/limit_details_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/pay_password_check.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';

class PageLoanCollectionPreview extends StatefulWidget {
  PageLoanCollectionPreview({Key key}) : super(key: key);

  @override
  _PageLoanCollectionPreviewState createState() =>
      _PageLoanCollectionPreviewState();
}

class _PageLoanCollectionPreviewState extends State<PageLoanCollectionPreview> {
  Map _reviewMap = {};
  Map _requstMap = {};
  LoanAccountDOList _accountInfo;
  String _interestRate = '';
  GetCreditlimitByCusteDTOList _limitCusteModel; //额度接口数据
  final f = NumberFormat("#,##0.00", "en_US"); //USD有小数位的处理
  final fj = NumberFormat("#,##0", "ja-JP"); //日元没有小数位的处理
  @override
  Widget build(BuildContext context) {
    Map listData = ModalRoute.of(context).settings.arguments;
    _reviewMap = listData['reviewList'];
    _requstMap = listData['requestList'];
    _interestRate = _requstMap['interestRate']; //利率

    _accountInfo = listData['loanAccountDOList']; //当前贷款帐号信息
    _limitCusteModel = listData['limitCusteModel']; //贷款额度信息

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loan_trail_title),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: _previewInfo(),
      ),
    );
  }

//文字样式
  Widget _textStyle(
      String text, Color color, double fontSize, TextAlign textAlign) {
    return Text(
      text == null ? '' : text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontSize == 24 ? FontWeight.bold : FontWeight.normal),
      textAlign: textAlign,
    );
  }

//一行文字
  Widget _rowText(String leftText, String rightText, Color leftColor,
      Color rightColor, double leftSize, double rightSize) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 16, 0),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 37) / 5 * 2,
            margin: EdgeInsets.only(right: 5),
            child: _textStyle(leftText, leftColor, leftSize, TextAlign.left),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 37) / 5 * 3,
            child:
                _textStyle(rightText, rightColor, rightSize, TextAlign.right),
          ),
        ],
      ),
    );
  }

//领用金额
  Widget _previewHeader() {
    String ccyStr = _requstMap['ccy']; //币种
    String _loanMount = _reviewMap['price'];

    return Container(
      padding: EdgeInsets.fromLTRB(0, 12.5, 0, 42.5),
      child: _rowText(
          S.current.loan_Recipients_Amount,
          ccyStr == 'JPY'
              ? fj.format(double.parse(_loanMount ?? '0')) ?? ''
              : f.format(double.parse(_loanMount ?? '0')) ?? '',
          HsgColors.aboutusTextCon,
          Color(0xFF232323),
          14,
          24),
    );
  }

//预览信息
  Widget _previewInfo() {
    String ccyStr = _requstMap['ccy']; //币种
    String _loanMount = _reviewMap['availableCredit'];
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _previewHeader(),
          Divider(
            height: 1,
          ),
          _rowText(
              S.current.loan_Borrowing_limit,
              ccyStr == 'JPY'
                  ? fj.format(double.parse(_loanMount ?? '0')) ?? ''
                  : f.format(double.parse(_loanMount ?? '0')) ?? '',
              HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText,
              14,
              14), //借款额度
          _rowText(
              S.current.loan_Borrowing_Period,
              _reviewMap['timeLimit'], //期限
              HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText,
              14,
              14),
          _rowText(S.current.repayment_ways, _reviewMap['repaymentMethod'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(S.current.view_repayment_plan, _reviewMap['repayPlan'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(S.current.loan_Total_Interest, _reviewMap['totalInterst'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(
              S.current.transfer_to_account,
              FormatUtil.formatSpace4(_reviewMap['payAcNo']),
              HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText,
              14,
              14),
          _rowText(S.current.loan_Borrowing_Purposes, _reviewMap['loanPurpose'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _finishBtn(),
        ],
      ),
    );
  }

  //确定按钮
  Widget _finishBtn() {
    return CustomButton(
      margin: EdgeInsets.fromLTRB(29.5, 100, 29.5, 30),
      height: 44,
      borderRadius: BorderRadius.circular(5.0),
      text: Text(
        S.current.confirm,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      clickCallback: () {
        // CheckPayPassword(context, () {
        _loanWithdrawalCommit(); //领用
        // });
      },
    );
  }

//输入交易密码最终申请
  _loanWithdrawalCommit() {
    String payData = _requstMap['planPayData'];
    String repayDat = payData.substring(payData.length - 2);
    String repay = _requstMap['repaymentMethod']; //还款方式
    String insType = '';
    String payType = ''; //还款方式

    if (repay == 'EPI') {
      //等额本息
      insType = '1';
      payType = '4';
    } else if (repay == 'IPI') {
      //等额本金
      insType = '2';
      payType = '4';
    } else if (repay == 'FPI') {
      //到期一次性
      payType = '1';
    } else {
      //按月付息
      payType = '2';
    }

    double _inRateVale = 0; //合约利率
    if (_limitCusteModel.floatNMth == '1') {
      //参考利率+点差 ：
      _inRateVale =
          double.parse(_interestRate) + double.parse(_limitCusteModel.onRate);
    } else if (_limitCusteModel.floatNMth == '2') {
      //参考利率+ 参考利率*百分比差/100
      _inRateVale = double.parse(_interestRate) +
          double.parse(_interestRate) *
              int.parse(_limitCusteModel.iratNPer) /
              100;
    }
    String mothCode = '';
    if (int.parse(_requstMap['termValue']) < 10) {
      mothCode = 'M00' + _requstMap['termValue'];
    } else {
      mothCode = 'M0' + _requstMap['termValue'];
    }

    var req = LoanTrailCommitReq(
        _requstMap['acNo'], //贷款合约号
        _accountInfo.ccy, //货币
        int.parse(_requstMap['price']), //贷款本金
        _limitCusteModel.iratCd1, //参考利率类型
        mothCode, //贷款期限 加上 M0
        double.parse(_interestRate), //参考利率
        _limitCusteModel.floatNMth, //浮动方式
        double.parse(_limitCusteModel.onRate), //点差
        int.parse(_limitCusteModel.iratNPer), //百分比差
        _inRateVale, //合约利率
        _requstMap['payAcNo'], //放款活期账户
        payType, //还款方式
        insType, //本利和公式
        '1', //结息周期
        'M', //结息周期单位
        _requstMap['planPayData'], //首次还息日期
        int.parse(repayDat), //还款指定日 年-月-日中的日
        _accountInfo.endDt, //_requstMap['matuDt'], //贷款到期日
        _reviewMap['availableCredit'], //可借款额度
        _requstMap['totalInterst'], //总利息
        _requstMap['loanPurpose'] //贷款用途
        );
    // 可借款额度 总利息  贷款用途
    HSProgressHUD.show();
    ApiClientLoan().loanFinalWithdrawInterface(req).then(
      (data) async {
        if (data != null) {
          HSProgressHUD.showToastTip(S.current.total_opration_audit_tip);
          await Future.delayed(Duration(seconds: 1)); //延迟一秒再执行
          Navigator.of(context)..pop()..pop();
        }
        HSProgressHUD.dismiss();
      },
    ).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }
}
