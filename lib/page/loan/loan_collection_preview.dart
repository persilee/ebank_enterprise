import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan_calculate_interest.dart';
import 'package:ebank_mobile/data/source/model/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan_trail_commit.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

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
    return Container(
      padding: EdgeInsets.fromLTRB(0, 12.5, 0, 42.5),
      child: _rowText(S.current.loan_Recipients_Amount, _reviewMap['price'],
          HsgColors.aboutusTextCon, Color(0xFF232323), 14, 24),
    );
  }

//预览信息
  Widget _previewInfo() {
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
              _reviewMap['availableCredit'],
              HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText,
              14,
              14),
          _rowText(S.current.loan_Borrowing_Period, _reviewMap['timeLimit'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(S.current.repayment_ways, _reviewMap['repaymentMethod'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(S.current.view_repayment_plan, _reviewMap['repayPlan'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(S.current.loan_Total_Interest, _reviewMap['totalInterst'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
          _rowText(S.current.transfer_to_account, _reviewMap['payAcNo'],
              HsgColors.aboutusTextCon, HsgColors.secondDegreeText, 14, 14),
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
        _loanWithdrawalCommit();
      },
    );
  }

  _loanWithdrawalCommit() {
    String payData = _requstMap['planPayData'];
    String repayDat = payData.substring(8);
    String repay = _requstMap['repaymentMethod']; //还款方式
    String insType = '';
    if (repay == 'EPI') {
      //等额本息
      insType = '1';
    } else if (repay == 'IPI') {
      //等额本金
      insType = '2';
    } else {}

    double _inRateVale = 0; //合约利率
    if (_limitCusteModel.floatNMth == '1') {
      //参考利率+点差 ：
      _inRateVale =
          double.parse(_interestRate) + int.parse(_limitCusteModel.onRate);
    } else if (_limitCusteModel.floatNMth == '2') {
      //参考利率+ 参考利率*百分比差/100
      _inRateVale = double.parse(_interestRate) +
          double.parse(_interestRate) *
              int.parse(_limitCusteModel.iratNPer) /
              100;
    }

    var req = LoanTrailCommitReq(
        _requstMap['acNo'], //贷款帐号
        _accountInfo.ccy, //货币
        int.parse(_requstMap['price']), //贷款本金
        _limitCusteModel.iratCd1, //参考利率类型
        _requstMap['termValue'], //贷款期限
        double.parse(_interestRate), //参考利率
        _limitCusteModel.floatNMth, //浮动方式
        double.parse(_limitCusteModel.onRate), //点差
        int.parse(_limitCusteModel.iratNPer), //百分比差
        _inRateVale, //合约利率
        _requstMap['payAcNo'], //放款活期账户
        repay, //还款方式
        insType, //本利和公式
        '1', //结息周期
        'M', //结息周期单位
        _requstMap['planPayData'], //首次还息日期
        int.parse(repayDat) //还款指定日 年-月-日中的日
        );

    SVProgressHUD.show();
    LoanDataRepository().loanFinalWithdrawInterface(req, 'getCardList').then(
      (data) {
        if (data != null) {}
        SVProgressHUD.dismiss();
      },
    ).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }
}
