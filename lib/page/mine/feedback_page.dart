/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 意见反馈
/// Author: hlx
/// Date: 2020-12-03

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
                    child:
                    //https://www.jianshu.com/p/3fb613ffac22   使用from 表单提交
                     TextFormField(
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      maxLength: 300, //允许输入的字符长度/
                      maxLengthEnforced: false, //是否允许输入的字符长度超过限定的字符长度
                      style: TextStyle(
                        color: HsgColors.secondDegreeText, //文字的颜色
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        hintText: "请写下您的建议，如功能需求，产品吐槽等，我们会努力改进…",
                        hintMaxLines: 20,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: HsgColors.hintText), //设置提示文字样式
                      ),
                      onChanged: (newValue) {
                        // print(newValue); // 当输入内容变更时,如何处理
                      },
                    ),
                  ),
                ),
                // Container(
                //   height: 30.0,
                //   margin: EdgeInsets.only(right: 15.0),
                //   width: MediaQuery.of(context).size.width,
                //   color: Colors.white,
                //   child: Text('还能输入300字',
                //       textAlign: TextAlign.end,
                //       style: TextStyle(
                //         color: HsgColors.secondDegreeText,
                //       )),
                // ),
                Container(
                  margin: EdgeInsets.all(40), //外边距
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    child: Text("提交"),
                    onPressed: () => print("提交"),
                    color: HsgColors.accent,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) //设置圆角
                        ),
                  ),
                )
              ],
            )));
  }
}
