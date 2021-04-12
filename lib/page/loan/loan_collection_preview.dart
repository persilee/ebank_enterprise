import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:flutter/material.dart';

class PageLoanCollectionPreview extends StatefulWidget {
  PageLoanCollectionPreview({Key key}) : super(key: key);

  @override
  _PageLoanCollectionPreviewState createState() =>
      _PageLoanCollectionPreviewState();
}

class _PageLoanCollectionPreviewState extends State<PageLoanCollectionPreview> {
  Map _reviewMap = {};
  Map _requstMap = {};

  @override
  Widget build(BuildContext context) {
    Map listData = ModalRoute.of(context).settings.arguments;
    _reviewMap = listData['reviewList'];
    _requstMap = listData['requestList'];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_the_preview),
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

  Future _loanWithdrawalCommit() async {}
}
