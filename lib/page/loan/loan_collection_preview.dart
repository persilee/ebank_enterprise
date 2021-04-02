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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("转账预览"),
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
      text,
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
      padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 37) / 5 * 3,
            margin: EdgeInsets.only(right: 5),
            child: _textStyle(leftText, leftColor, leftSize, TextAlign.left),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 37) / 5 * 2,
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
      child: _rowText("可借款额度", "USD148.95", HsgColors.aboutusTextCon,
          Color(0xFF232323), 14, 24),
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
          _rowText("可借款额度", "USD 800", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
          _rowText("借款期限", "12个月", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
          _rowText("还款方式", "按月付息", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
          _rowText("还款计划", "首期4月28", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
          _rowText("总利息", "51.4", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
          _rowText("收款账户", "2444 4547 4545", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
          _rowText("借款用途", "无", HsgColors.aboutusTextCon,
              HsgColors.secondDegreeText, 14, 14),
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
        print('确定');
      },
    );
  }
}
