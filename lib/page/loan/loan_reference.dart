import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/mine/id_cardVerification_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 贷款引用页面
/// Author: pengyikang
class LoanReference extends StatefulWidget {
  LoanReference({Key key}) : super(key: key);

  @override
  _LoanReferenceState createState() => _LoanReferenceState();
}

class _LoanReferenceState extends State<LoanReference> {
  String _deadLine = ''; //贷款期限
  bool _checkBoxValue = false; //复选框默认值
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //防止挤压溢出
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('领用'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height / 0.33,
        //color: Colors.white,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(23, 16, 23, 0),
              // width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      '可借款额度 CNY800.00',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Color(0xFF262626), fontSize: 15),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5, top: 10),
                          child: Text(
                            'CNY',
                            style: TextStyle(
                                color: Color(0xFF3394D4),
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: 60,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 24,
                              color: HsgColors.firstDegreeText,
                            ),
                            decoration: InputDecoration(
                                // isCollapsed: true,
                                // contentPadding: EdgeInsets.symmetric(
                                //     vertical: 10, horizontal: 10),
                                // filled: true,
                                //  fillColor: Colors.green,
                                border: InputBorder.none,
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Color(0xFFCCCCCC))),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                              LengthLimitingTextInputFormatter(12),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.blue,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 21),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(15, 16, 15, 13),
              child: Column(
                children: [
                  //借款期限
                  Container(
                      child: selectInkWellToBlackTitle(
                          '借款期限', _deadLine, onClink())),
                  Divider(
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 11),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Text(
                      '可提前还款，利息按天计算，免手续费',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Color(0xFF9C9C9C), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  //借款期限
                  Container(
                      //  color: Colors.white,
                      child: selectInkWellToBlackTitle(
                    '还款方式',
                    _deadLine,
                    onClink,
                  )),
                  Divider(
                    height: 0,
                  ),
                  Container(
                      color: Colors.white,
                      child: selectInkWellToBlackTitle(
                        '还款计划',
                        _deadLine,
                        onClink(),
                      )),
                  Divider(
                    height: 0,
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(19, 20, 11, 20),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text('总利息',
                              style: TextStyle(
                                  fontSize: 14.5, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          child: Text(
                            '261.88',
                            style: TextStyle(color: Color(0xFF9C9C9C)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 16, 15, 13),
              child: Column(
                children: [
                  //借款期限
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    color: Colors.white,
                    child: SelectInkWell(
                      title: '收款账户',
                      item: _deadLine,
                      onTap: () {
                        // FocusScope.of(context).requestFocus(FocusNode());
                        // _select(S.current.loan_duration, _deadLineLists, 0);
                      },
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  Container(
                      color: Colors.white,
                      child: selectInkWellToBlackTitle(
                        '借款用途',
                        _deadLine,
                        onClink(),
                      )),
                ],
              ),
            ),
            //文本协议内容
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              //padding: CONTENT_PADDING,
              child: Row(
                children: [_roundCheckBox(), _textContent()],
              ),
            ),
            //完成按钮

            CustomButton(
              margin:
                  EdgeInsets.only(left: 37.5, right: 37.5, bottom: 50, top: 10),
              height: 50,
              text: Text(
                S.current.complete,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              clickCallback: () {
                //  _login();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget selectInkWellToBlackTitle(
    String title,
    String item,
    Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                title,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: item == ''
                      ? Text(S.current.please_select,
                          style: TextStyle(color: HsgColors.textHintColor))
                      : Text(item),
                ),
                Container(
                  padding: EdgeInsets.only(right: 11),
                  child: Image(
                    color: HsgColors.firstDegreeText,
                    image: AssetImage(
                        'images/home/listIcon/home_list_more_arrow.png'),
                    width: 7,
                    height: 10,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

//圆形复选框
  Widget _roundCheckBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _checkBoxValue = !_checkBoxValue;
        });
        //_submit();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 25),
        child: _checkBoxValue
            ? _ckeckBoxImge("images/common/check_btn_common_checked.png")
            : _ckeckBoxImge("images/common/check_btn_common_no_check.png"),
      ),
    );
  }

  //圆形复选框是否选中图片
  Widget _ckeckBoxImge(String imgurl) {
    return Image.asset(
      imgurl,
      height: 16,
      width: 16,
    );
  }

  //协议文本内容
  Widget _textContent() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '本人已阅读并同意签署',
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump('《个人消费贷款合同》', '98822'),
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump('《个人信用报告查询授权书》', '99868'),
            TextSpan(
              text: '同意报送贷款相关信息至金融信用信息基础数据库（人行征信系统）',
              style: AGREEMENT_TEXT_STYLE,
            ),
          ],
        ),
      ),
    );
  }

  //协议文本跳转内容
  _conetentJump(String text, String arguments) {
    return TextSpan(
      text: text,
      style: AGREEMENT_JUMP_TEXT_STYLE,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.pushNamed(context, pageUserAgreement, arguments: arguments);
        },
    );
  }

  onClink() {}
}
