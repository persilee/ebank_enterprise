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
  Widget _textStyle(String text, Color color, double fontSize) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }

//一行文字
  Widget _rowText(String leftText, String rightText) {
    return Container(
      child: Row(
        children: [
          _textStyle(leftText, Colors.black, 15),
          _textStyle(rightText, Colors.black, 15),
        ],
      ),
    );
  }

//领用金额
  Widget _previewHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 42.5, 16, 42.5),
      child: _rowText("可借款额度", "USD 800"),
    );
  }

//预览信息
  Widget _previewInfo() {
    return Container(
      child: Row(
        children: [
          _rowText("可借款额度", "USD 800"),
          _rowText("借款期限", "12个月"),
          _rowText("还款方式", "按月付息"),
          _rowText("还款计划", "首期4月28"),
          _rowText("总利息", "51.4"),
          _rowText("收款账户", "2444 4547 4545"),
          _rowText("借款用途", "无"),
        ],
      ),
    );
  }
}
