import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/loan_application.dart';
import 'package:ebank_mobile/data/source/model/loan_product_list.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/verify_trade_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_single_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class LoanNewApplicationPage extends StatefulWidget {
  @override
  _LoanNewApplicationState createState() => _LoanNewApplicationState();
}

class _LoanNewApplicationState extends State<LoanNewApplicationPage> {
  int _ccyId = 0; //币种下标

  int _index = 3; //贷款期限对应的几个月
  String _deadLine = ''; //贷款期限
  String _goal = ""; //贷款目的
  String _currency = ""; //币种
  String _rateValue = ""; //利率

  String _inputs = S.current.please_input; //请输入提示
  String _notRequired = S.current.not_required; //非必填提示
  String _custId = ''; //客户号
  String _language = Intl.getCurrentLocale(); //版本语言

  bool _isButton = false; //申请按钮是否能点击
  bool _checkBoxValue = false; //复选框默认值
  var _payPassword = ''; //交易密码

  var _contactsController = new TextEditingController(); //联系人文本监听器
  var _phoneController = new TextEditingController(); //联系人手机号码文本监听器
  var _moneyController = new TextEditingController(); //申请金额文本监听器
  var _remarkController = new TextEditingController(); //备注文本监听器

  Map _listDataMap = {}; //确认页展示列表数据的map
  Map _requestDataMap = {}; //确认页上传数据的map

  List<IdType> _ccyList = []; //币种列表、
  List<IdType> _deadLineLists = []; //贷款期限列表
  List<IdType> _goalLists = []; //贷款目的列表

  String _loanAccount = ''; //放款帐号
  int _loanAccountIndex = 0; //放款款索引

  String _repayAccount = ''; //还款帐号
  int _repayAccountIndex = 0; //还款索引
  List<RemoteBankCard> _totalAccoutList = []; //总帐号

  String _reimburseStr = ''; //还款方式
  List<IdType> _reimburseTypeLists = []; //还款方式

  List<LoanProductList> _loanProduct = []; //贷款产品列表
  String _loanProductName = ""; //贷款产品名称
  String _loanProductID = ""; //贷款产品ID
  int _indexPro = 0; //贷款产品对应的几个月

  get w500 => null; //还款方式

  @override
  void initState() {
    //网络请求，数据等都在这里进行创建
    super.initState();
    _custIdReqData(); //获取客户号
    _getCcyList(); //获取币种
    _getLoanPurposeList(); //贷款目的
    _getLoanTimeList(); //获取贷款期限
    _loadTotalAccountData(); //获取贷款账户列表
    _getLoanRepayTypeList();
    _loadLoanProductData(); //获取贷款产品列表
  }

// 获取币种列表
  Future _getCcyList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("CCY"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _ccyList.clear();
        _ccyList.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

  //获取贷款期限
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

  //获取贷款目的
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

  //获取客户号
  Future<void> _custIdReqData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(GetUserInfoReq(userID), "getUserInfo")
        .then((data) {
      setState(() {
        _custId = data.custId;
      });
    }).catchError((e) {
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

  //获取放款以及还款帐号列表
  Future<void> _loadTotalAccountData() async {
    SVProgressHUD.show();
    CardDataRepository().getCardList('getCardList').then(
      (data) {
        SVProgressHUD.dismiss();
        if (data.cardList != null) {
          // if (mounted) {
          setState(() {
            _totalAccoutList.clear();
            _totalAccoutList.addAll(data.cardList);
            RemoteBankCard card = _totalAccoutList[0];
            _loanAccount = card.cardNo; //放款帐号
            _repayAccount = card.cardNo; //还款帐号
            _listDataMap['payAcNo'] = _loanAccount;
            _requestDataMap['payAcNo'] = _loanAccount;
            _listDataMap['repaymentAcNo'] = _repayAccount;
            _requestDataMap['repaymentAcNo'] = _repayAccount;
          });
        }
      },
    ).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

//获取贷款产品
  Future<void> _loadLoanProductData() async {
    LoanDataRepository()
        .loanGetProductListRequest(LoanProductListReq('0'), 'loanProductData')
        .then((data) {
      if (data.loanProductList != null) {
        setState(() {
          _loanProduct = data.loanProductList;
          LoanProductList names = _loanProduct[0];
          _loanProductID = names.bppdCode;
          _requestDataMap['prdtCode'] = names.bppdCode; //ID
          if (_language == 'zh_CN') {
            _loanProductName = names.lclName;
            _listDataMap['prdtCode'] = names.lclName;
          } else {
            _loanProductName = names.engName;
            _listDataMap['prdtCode'] = names.engName; //名称
          }
        });
      }
    }).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_apply),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(top: _language == 'zh_CN' ? 17.5 : 12),
            width: (MediaQuery.of(context).size.width - 36) / 4,
            margin: EdgeInsets.only(right: 18, top: 5),
            child: Text.rich(
              TextSpan(
                  text: S.current.my_application,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, pageLoanMyApplicationList);
                    }),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      body: Container(
        color: HsgColors.commonBackground,
        height: double.infinity,
        child: Container(
          color: HsgColors.commonBackground,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                //第一组
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      color: Colors.white,
                      child: Column(
                        children: [
                          _firstGroup(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //第二组横线
                height: 20,
                color: HsgColors.commonBackground,
              ),
              Container(
                //第三组
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      color: Colors.white,
                      child: Column(
                        children: [
                          _sectionGroup(), //调用组件
                          Container(
                            //复选框及协议文本内容
                            margin: EdgeInsets.only(top: 10),
                            padding: CONTENT_PADDING,
                            child: Row(
                              children: [
                                _roundLoanCheckBox(),
                                _textLoanContent()
                              ],
                            ),
                          ),
                          Container(
                            //申请按钮
                            margin: EdgeInsets.only(top: 40, bottom: 20),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstGroup() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 40,
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Text(S.current.loan_NewTop_infomation,
                style:
                    TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
                textAlign: TextAlign.left),
          ),
          SelectInkWell(
            //贷款产品
            title: S.current.loan_New_product_column,
            item: _loanProductName,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectProductList(_indexPro);
              //点击跳转回调的方法
              // Navigator.pushNamed(context, pageLoanProductlistNav)
              //     .then((value) {
              //   setState(() {
              //     Map map = value;
              //     _loanProductName = map['pro_name'];
              //     _listDataMap['prdtCode'] = map['pro_name']; //名称
              //     _requestDataMap['prdtCode'] = map['pro_ID']; //ID
              //   });
              // });
            },
          ),
          TextFieldContainer(
            //申请金额
            title: S.current.apply_amount,
            hintText: _inputs,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _moneyController,
            callback: _checkloanIsClick,
          ),
          SelectInkWell(
            //贷款期限
            title: S.current.loan_duration,
            item: _deadLine,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _select(S.current.loan_duration, _deadLineLists, 0);
            },
          ),
          SelectInkWell(
            //支出币种
            title: S.current.debit_currency,
            item: _currency,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showDialog(_ccyId, _ccyList);
            },
          ),
          SelectInkWell(
            //贷款目的
            title: S.current.loan_purpose,
            item: _goal,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _select(S.current.loan_purpose, _goalLists, 1);
            },
          ),
          SelectInkWell(
            //放款帐号
            title: S.current.loan_Disbursement_Account_column,
            item: _loanAccount,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectAccount(0);
            },
          ),
          SelectInkWell(
            //还款帐号
            title: S.current.loan_Repayment_account_column,
            item: _repayAccount,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectAccount(1);
            },
          ),
          SelectInkWell(
            //还款方式
            title: S.current.loan_Repayment_method_column,
            item: _reimburseStr,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _select(S.current.loan_Repayment_method_column,
                  _reimburseTypeLists, 2);
            },
          ),
          // Container(
          //   height: 45,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         S.current.loan_Interest_Rate_column,
          //         style: TextStyle(),
          //         textAlign: TextAlign.start,
          //       ),
          //       Text(
          //         '1%',
          //         style: TextStyle(),
          //         textAlign: TextAlign.end,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

//第二组的组件
  Widget _sectionGroup() {
    return Container(
      //第二组
      color: Colors.white,
      child: Column(
        children: [
          //联系人
          _textFieldCommonFunc(S.current.contact, _inputs, TextInputType.text,
              _contactsController, _checkloanIsClick),
          //联系人手机号码
          _textFieldCommonFunc(S.current.contact_phone_num, _inputs,
              TextInputType.number, _phoneController, _checkloanIsClick),
          //联系人手机号码
          _textFieldCommonFunc(S.current.remark, _notRequired,
              TextInputType.text, _remarkController, () {}),
        ],
      ),
    );
  }

  Widget _textFieldCommonFunc(
      String title,
      String hintText,
      TextInputType keyboard,
      TextEditingController controller,
      VoidCallback callback) {
    return TextFieldContainer(
      //备注
      title: title,
      hintText: hintText,
      keyboardType: keyboard,
      controller: controller,
      callback: _checkloanIsClick,
    );
  }

//交易密码窗口  点击确认页面
  void _openBottomSheet() async {
    //判断金额是否为0
    if (double.parse(_moneyController.text) <= 0) {
      SVProgressHUD.showInfo(status: S.current.loan_application_amount_check);
      return;
    }

    //需要将数据绑定并传值，添加新的值进去
    // _listDataMap["loanRate"] = '0.1'; //利率
    _listDataMap["remark"] = _remarkController.text; //备注
    _listDataMap["contact"] = _contactsController.text; //联系人
    _listDataMap["phone"] = _phoneController.text; //联系方式
    _listDataMap["intentAmt"] = _moneyController.text; //金额

    _requestDataMap["loanRate"] = '0.1'; //利率
    _requestDataMap["remark"] = _remarkController.text; //备注
    _requestDataMap["contact"] = _contactsController.text; //联系人
    _requestDataMap["phone"] = _phoneController.text; //联系方式
    _requestDataMap["intentAmt"] = _moneyController.text; //金额

    Map dataList = {'reviewList': _listDataMap, 'requestList': _requestDataMap};

    Navigator.pushNamed(context, pageLoanConfirmNav, arguments: dataList);
    // _passwordList = await showHsgBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return HsgPasswordDialog(
    //       title: S.current.input_password,
    //       resultPage: pageOperationResult,
    //     );
    //   },
    // );
  }

  //协议文本内容
  Widget _textLoanContent() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: S.current.loan_application_agreement1,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement2, '98822'),
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement4, '99868'),
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

  //币种弹窗内容
  _showDialog(int index, List<IdType> list) async {
    List<String> tempList = [];
    list.forEach((e) {
      tempList.add(e.code);
    });

    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: tempList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: index,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        IdType type = list[result];
        _ccyId = result;
        _listDataMap['ccy'] = tempList[index];
        _requestDataMap['ccy'] = type.code;
        _currency = tempList[result];
        _checkloanIsClick();
      });
    }
  }

//圆形复选框
  Widget _roundLoanCheckBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _checkBoxValue = !_checkBoxValue;
          _checkloanIsClick();
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 25),
        child: _checkBoxValue
            ? _loanCkeckBoxImge("images/common/check_btn_common_checked.png")
            : _loanCkeckBoxImge("images/common/check_btn_common_no_check.png"),
      ),
    );
  }

  //圆形复选框是否选中图片
  Widget _loanCkeckBoxImge(String imgurl) {
    return Image.asset(
      imgurl,
      height: 16,
      width: 16,
    );
  }

  //期限，目的底部弹窗内容选择
  _select(String title, List<IdType> list, int i) {
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
          //贷款期限，贷款目的, 还款方式
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
          _index = _index * (index + 1);
          _checkloanIsClick();
        });
      },
    );
  }

//获取贷款产品列表的数据
  _selectProductList(int index) async {
    List<String> _productName = [];
    List<String> _productID = [];
    for (LoanProductList names in _loanProduct) {
      if (_language == 'zh_CN') {
        _productName.add(names.lclName);
      } else {
        _productName.add(names.engName);
      }
      _productID.add(names.bppdCode);
    }
    //弹窗
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => HsgBottomSingleChoice(
            title: S.current.loan_New_product_column,
            items: _productName,
            lastSelectedPosition: index));
    //拿值
    if (result != null && result != false) {
      setState(() {
        _loanProductName = _productName[result]; //产品名称
        _loanProductID = _productID[result]; //产品ID
        _indexPro = result;

        _listDataMap['prdtCode'] = _productName[result]; //名称
        _requestDataMap['prdtCode'] = _productID[result]; //ID
      });
    }
  }

//付款账户弹窗
  _selectAccount(int index) async {
    List<String> bankCards = [];
    List<String> accounts = [];
    List<String> ciNames = [];
    for (RemoteBankCard cards in _totalAccoutList) {
      //便利拿出帐号
      bankCards.add(cards.cardNo);
      ciNames.add((cards.ciName));
    }
    bankCards = bankCards.toSet().toList(); //去重复的数据
    for (var i = 0; i < bankCards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(bankCards[i]));
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => HsgBottomSingleChoice(
            title: S.current.payment_account,
            items: accounts,
            lastSelectedPosition:
                index == 0 ? _loanAccountIndex : _repayAccountIndex));
    if (result != null && result != false) {
      setState(() {
        if (index == 0) {
          //放款
          //返回拿到的索引值
          _loanAccount = accounts[result];
          _loanAccountIndex = result;
          _listDataMap['payAcNo'] = _loanAccount;
          _requestDataMap['payAcNo'] = _loanAccount;
        } else {
          //还款
          _repayAccount = accounts[result];
          _repayAccountIndex = result;
          _listDataMap['repaymentAcNo'] = _repayAccount;
          _requestDataMap['repaymentAcNo'] = _repayAccount;
        }
      });
    } else {
      return;
    }
  }

  //判断按钮能否使用
  _checkloanIsClick() {
    if (_checkBoxValue &&
        _contactsController.text != '' &&
        _phoneController.text != '' &&
        _moneyController.text != '' &&
        _deadLine != '' &&
        _goal != '' &&
        _currency != '' &&
        _loanProductName != '' &&
        _loanAccount != '' &&
        _repayAccount != '' &&
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
}
