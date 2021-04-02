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
    return Container(
      child: _rowText("asd", "123"),
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
}
