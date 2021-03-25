import 'package:ebank_mobile/data/source/mine_feedbackApi.dart';
import 'package:ebank_mobile/data/source/model/getFeedback.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 意见反馈
/// Author: hlx
/// Date: 2020-12-03

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  var _content = '';

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // _feedbackController.text = '';
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).feedback),
        centerTitle: true,
        elevation: 1,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
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
                        TextField(
                      controller: _feedbackController,
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      maxLength: 300, //允许输入的字符长度/
                      inputFormatters: <TextInputFormatter>[
                        // FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
                        LengthLimitingTextInputFormatter(300), //限制长度
                      ],
                      maxLengthEnforced: false, //是否允许输入的字符长度超过限定的字符长度
                      style: TextStyle(
                        color: HsgColors.secondDegreeText, //文字的颜色
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        hintText: S.of(context).feedBackInfo,
                        hintMaxLines: 20,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: HsgColors.hintText), //设置提示文字样式
                      ),
                      onChanged: (newValue) {},
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(40), //外边距
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    child: Text(S.of(context).submit),
                    onPressed: _submit()
                        ? () {
                            _submitFeedBack();
                          }
                        : null,
                    color: HsgColors.accent,
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    disabledColor: Color(0xFFD1D1D1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) //设置圆角
                        ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.all(40), //外边距
                //   height: 44.0,
                //   width: MediaQuery.of(context).size.width,
                //   child: RaisedButton(
                //     child: Text(S.of(context).submit),
                //     // _content == '' ? null : _submitFeedBack(),
                //     onPressed: _submitFeedBack,
                //     color: HsgColors.accent,
                //     textColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5) //设置圆角
                //         ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _submit() {
    if (_feedbackController.text != '') {
      return true;
    } else {
      return false;
    }
  }

  _submitFeedBack() async {
    String feedbackProblem = _feedbackController.text;
    String opinionPhone = '';
    String opinionTheme = '反馈';
    String problemType = '4';
    HSProgressHUD.show();
    FeedbackRepository()
        .feedBack(
      GetFeedBackReq(feedbackProblem, opinionPhone, opinionTheme, problemType),
      'GetFeedBackReq',
    )
        .then((data) {
      HSProgressHUD.showError(status: '意见反馈成功');
      Navigator.pop(context);
      HSProgressHUD.dismiss();
    }).catchError((e) {
      // Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
    });
  }
}
