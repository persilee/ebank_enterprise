// TODO Implement this library.
/**
  @desc   意见反馈 
  @author hlx
 */
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('意见反馈'),
          elevation: 15.0,
        ),
        body: Container(
            color: HsgColors.commonBackground,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  // width: MediaQuery.of(context).size.width,
                  //margin: EdgeInsets.only(left:10,right:10,top:10),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      style: TextStyle(
                        color: HsgColors.secondDegreeText,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        hintText: "请写下您的建议，如功能需求，产品吐槽等，我们会努力改进…",
                        hintMaxLines: 20,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("浮动按钮"),
                  color: Colors.white,
        //按钮亮度
        colorBrightness: Brightness.dark,
        //文本颜色
        textColor: Colors.white,
        //按钮主题 ButtonTheme ButtonThemeData ButtonTextTheme ThemeData
        textTheme: ButtonTextTheme.normal,
        //墨汁飞溅的颜色
        splashColor: Colors.blue,
        //抗锯齿能力
        clipBehavior: Clip.antiAlias,
        //内边距
        padding: new EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
          left: 20.0,
          right: 20.0,
        ),
                ),
              ],
            )));
  }
}
