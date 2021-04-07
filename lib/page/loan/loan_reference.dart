import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/mine/id_cardVerification_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_single_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:intl/intl.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 贷款引用页面
/// Author: pengyikang
class LoanReference extends StatefulWidget {
  LoanReference({Key key}) : super(key: key);

  @override
  _LoanReferenceState createState() => _LoanReferenceState();
}

class _LoanReferenceState extends State<LoanReference> {
  bool _checkBoxValue = false; //复选框默认值
  bool _isButton = false; //按钮是否能点击
  String _language = Intl.getCurrentLocale(); //版本语言
  String _totalInterest = ''; //总利息
  var _recipientsController = new TextEditingController(); //领用金额输入框

//获取各个公共参数的接口
  String _goal = ""; //贷款目的
  List<IdType> _goalLists = []; //贷款目的列表

  String _deadLine = ''; //贷款期限
  List<IdType> _deadLineLists = []; //贷款期限列表

  String _reimburseStr = ''; //还款方式
  List<IdType> _reimburseTypeLists = []; //还款方式

  String _loanAccount = '81003891929'; //收款帐号
  int _loanAccountIndex = 0; //收款索引
  List<RemoteBankCard> _totalAccoutList = []; //总帐号

  Map _listDataMap = {}; //确认页展示列表数据的map
  Map _requestDataMap = {}; //确认页上传数据的map

  //获取借款期限
  Future _getLoanTimeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("LOAN_TERM"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _deadLineLists.clear();
        _deadLineLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

  //获取借款用途
  Future _getLoanPurposeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("LOAN_PUR"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _goalLists.clear();
        _goalLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

//还款方式
  Future _getLoanRepayTypeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("REPAY_TYPE"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _reimburseTypeLists.clear();
        _reimburseTypeLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

  //获取收款账户列表
  Future _loadTotalAccountData() async {
    SVProgressHUD.show();
    CardDataRepository().getCardList('getCardList').then(
      (data) {
        SVProgressHUD.dismiss();
        if (data.cardList != null) {
          // if (mounted) {
          setState(() {
            _totalAccoutList.clear();
            _totalAccoutList.addAll(data.cardList);
          });
        }
      },
    ).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

  @override
  void initState() {
    //网络请求，数据等都在这里进行创建
    super.initState();
    _getLoanPurposeList(); //贷款目的
    _getLoanTimeList(); //获取贷款期限
    _loadTotalAccountData(); //获取贷款账户列表
    _getLoanRepayTypeList(); //获取还款方式
  }

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
                        style:
                            TextStyle(color: Color(0xFF262626), fontSize: 15),
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
                              controller: _recipientsController, //绑定属性关系
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
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
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
                            S.current.loan_Borrowing_Period,
                            _deadLine,
                            _select(S.current.loan_Borrowing_Period,
                                _deadLineLists, 0))),
                    Divider(
                      height: 0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 11),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Text(
                        S.current.loan_Borrowing_description,
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Color(0xFF9C9C9C), fontSize: 13),
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
                    //还款方式
                    Container(
                        //  color: Colors.white,
                        child: selectInkWellToBlackTitle(
                      S.current.repayment_ways,
                      _reimburseStr,
                      _select(S.current.repayment_ways, _reimburseTypeLists, 2),
                    )),
                    Divider(
                      height: 0,
                    ),
                    Container(
                        //还款计划
                        color: Colors.white,
                        child: selectInkWellToBlackTitle(
                          S.current.repayment_plan,
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
                            //总利息
                            child: Text(S.current.loan_Total_Interest,
                                style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            child: Text(
                              _totalInterest,
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
                    //收款账户
                    Container(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Container(
                      child: Column(
                        children: [
                          //收款账户
                          Container(
                            // padding: EdgeInsets.only(left: 20),
                            color: Colors.white,
                            child: selectInkWellToBlackTitle(
                                S.current.transfer_to_account,
                                _loanAccount,
                                _selectAccount()),
                          ),

                          Divider(
                            height: 0,
                          ),
                          Container(
                              //借款用途
                              color: Colors.white,
                              child: selectInkWellToBlackTitle(
                                  S.current.loan_Borrowing_Purposes,
                                  _goal,
                                  _select(S.current.loan_Borrowing_Purposes,
                                      _goalLists, 1))),
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
                    Container(
                      //申请按钮
                      margin: EdgeInsets.only(
                          left: 37.5, right: 37.5, bottom: 50, top: 10),
                      child: HsgButton.button(
                        title: S.current.apply,
                        click: _isButton ? _openBottomSheet : null,
                        isColor: _isButton,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            //  ),
          ),
        ));
  }

//期限，用途 ，还款方式底部弹窗内容选择
  _select(String title, List<IdType> list, int i) {
    return () {
      List<String> tempList = [];
      list.forEach((e) {
        if (_language == 'zh_CN') {
          tempList.add(e.cname);
        } else {
          tempList.add(e.name);
        }
      });
      SinglePicker.showStringPicker(
        context,
        data: tempList,
        title: title,
        clickCallBack: (int index, var str) {
          setState(() {
            //贷款期限，贷款用途, 还款方式
            IdType type = list[index];
            if (i == 0) {
              _deadLine = str;
              _listDataMap['timeLimit'] = str; //名称
              _requestDataMap['termUnit'] = str; //月份中文
              _requestDataMap['termValue'] = type.code; //月份编码
            } else if (i == 1) {
              _goal = str;
              _listDataMap['loanPurpose'] = str; //名称
              _requestDataMap['loanPurpose'] = type.code; //ID
            } else {
              _reimburseStr = str;
              _listDataMap['repaymentMethod'] = str; //名称
              _requestDataMap['repaymentMethod'] = type.code; //ID
            }
            // _index = _index * (index + 1);
            _checkloanIsClick();
          });
        },
      );
    };
  }

//账号弹窗
  _selectAccount() {
    return () async {
      List<String> bankCards = [];
      List<String> accounts = [];
      List<String> ciNames = [];
      for (RemoteBankCard cards in _totalAccoutList) {
        //便利拿出帐号
        bankCards.add(cards.cardNo);
        ciNames.add((cards.ciName));
      }
      for (var i = 0; i < bankCards.length; i++) {
        accounts.add(FormatUtil.formatSpace4(bankCards[i]));
      }
      final result = await showHsgBottomSheet(
          context: context,
          builder: (context) => HsgBottomSingleChoice(
              title: S.current.transfer_to_account,
              items: accounts,
              lastSelectedPosition: _loanAccountIndex));
      if (result != null && result != false) {
        setState(() {
          //放款
          //返回拿到的索引值
          _loanAccount = accounts[result];
          _loanAccountIndex = result;
          _listDataMap['payAcNo'] = _loanAccount;
          _requestDataMap['payAcNo'] = _loanAccount;
          _checkloanIsClick(); //校验按钮
        });
      } else {
        return;
      }
    };
  }

//选项弹窗
  Widget selectInkWellToBlackTitle(
    String title,
    String item,
    Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            0, 15, 0, title == S.current.transfer_to_account ? 5 : 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              //左侧文本
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: title == S.current.transfer_to_account
                        ? Text(
                            S.current.loan_Estimated_time_account,
                            style: TextStyle(
                                fontSize: 13, color: HsgColors.describeText),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //右侧文本
                  // Padding(
                  width: MediaQuery.of(context).size.width / 3,
                  padding: EdgeInsets.only(right: 12),
                  child: item == ''
                      ? Text(S.current.please_select,
                          style: TextStyle(color: HsgColors.textHintColor))
                      : Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                        ),
                ),
                Container(
                  //右侧箭头
                  padding: EdgeInsets.only(
                    right: 5,
                  ),
                  // width: 20,
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
          _checkloanIsClick();
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
              text: S.current.loan_application_agreement1,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_recipients_agreement1, '98822'),
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_recipients_agreement2, '99868'),
            TextSpan(
              text: S.current.loan_recipients_agreement3,
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

//判断按钮能否使用
  _checkloanIsClick() {
    if (_checkBoxValue &&
        _recipientsController.text != '' &&
        _deadLine != '' &&
        _goal != '' &&
        _loanAccount != '' &&
        _reimburseStr != '') {
      return setState(() {
        _isButton = true;
      });
    } else {
      setState(() {
        _isButton = false;
      });
    }
  }

  onClink() {
    return () {
      print('来到了这里');
    };
  }

  _openBottomSheet() {
    //需要传值
    _listDataMap["totalInterst"] = '100'; //总利息
    _listDataMap["price"] = _recipientsController.text; //金额
    _listDataMap["repayPlan"] = '首期24，还款1000元'; //计划
    _listDataMap["availableCredit"] = '首期24，还款1000元'; //可借款额度

    _requestDataMap["totalInterst"] = '100'; //总利息
    _requestDataMap["price"] = _recipientsController.text; //金额
    _listDataMap["repayPlan"] = '12'; //计划
    _listDataMap["availableCredit"] = 'USD 10000'; //可用额度

    Map dataList = {'reviewList': _listDataMap, 'requestList': _requestDataMap};

    Navigator.pushNamed(context, pageLoanCollectionPreview,
        arguments: dataList);
  }

// 先去拿到利率
  //利率接口
  // "ccy": 上个界面拿过来的,
  // "payFre": 1, OK
  // "payUnit": "M",OK
  // "paytyp": "1", OK
  // "prin": 输入的金额，需要拿到, OK
  // "rate": 0, no
  // "totTerm": 0, no
  // "repDay": 3, OK
  // "valDt": "2021-02-03" OK
  //

}
