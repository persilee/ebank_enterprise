import 'package:ebank_mobile/data/source/mine_feedbackApi.dart';
import 'package:ebank_mobile/data/source/model/getFeedback.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 意见反馈
/// Author: hlx
/// Date: 2020-12-03

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                      maxLength: 200, //允许输入的字符长度/
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp(
                            InputFormartterRegExp.REGEX_EMOJI)), //禁止输入emoji
                        LengthLimitingTextInputFormatter(200), //限制长度
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
                CustomButton(
                  margin: EdgeInsets.all(40),
                  text: Text(
                    S.of(context).submit,
                    style: TextStyle(color: Colors.white),
                  ),
                  isEnable: _submit(),
                  clickCallback: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _submitFeedBack();
                  },
                ),
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
    String feedbackProblem = _feedbackController.text ?? '';
    String opinionPhone = '';
    String opinionTheme = '反馈';
    String problemType = '4';
    HSProgressHUD.show();
    // FeedbackRepository()
    ApiClientAccount()
        .feedBack(
      GetFeedBackReq(feedbackProblem, opinionPhone, opinionTheme, problemType),
    )
        .then((data) {
      Fluttertoast.showToast(
        msg: S.current.feedbackSuccess,
        gravity: ToastGravity.CENTER,
      );
      Navigator.pop(context);
      HSProgressHUD.dismiss();
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      print('${e.toString()}');
    });
  }
}
