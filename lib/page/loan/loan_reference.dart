import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/application_loan.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan_trial_rate.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api_client_bill.dart';
import 'package:ebank_mobile/http/retrofit/api_client_loan.dart';
import 'package:ebank_mobile/http/retrofit/api_client_openAccount.dart';
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
/// 贷款领用页面
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
  String _mothCode = ''; //月份编码
  double max = 0; //贷款最大限额
  String iratCd1 = ''; //用户额度保存
  String interestRate = ''; //贷款利率

  var _recipientsController = new TextEditingController(); //领用金额输入框

//获取各个公共参数的接口
  String _goal = ""; //贷款目的
  List<IdType> _goalLists = []; //贷款目的列表

  String _deadLine = ''; //贷款期限
  String _dateCode = ''; //贷款期限编码

  List<IdType> _deadLineLists = []; //贷款期限列表

  String _reimburseStr = ''; //还款方式
  String _reimburseCode = ''; //还款方式编码
  List<IdType> _reimburseTypeLists = []; //还款方式

  String _loanAccount = ''; //收款帐号
  int _loanAccountIndex = 0; //收款索引
  List<RemoteBankCard> _totalAccoutList = []; //总帐号

  String _trailStr = ''; //领用的还款计划文本
  int _trailIndex = 0; //计划的索引

  LoanTrialDTOList _trailModel; //当前选中的模型
  List<LoanTrialDTOList> _trailList = []; //计划的数组列表

  Map _listDataMap = {}; //确认页展示列表数据的map
  Map _requestDataMap = {}; //确认页上传数据的map

  LoanAccountDOList accountInfo; //上个界面传过来的值
  FocusNode focusnode = FocusNode(); //监听编辑的输入

  GetCreditlimitByCusteDTOList _limitCusteModel; //额度接口数据

  //获取借款期限
  Future _getLoanTimeList() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("LOAN_TERM")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _deadLineLists.clear();
        _deadLineLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

  //获取借款用途
  Future _getLoanPurposeList() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("LOAN_PUR")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _goalLists.clear();
        _goalLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

//还款方式
  Future _getLoanRepayTypeList() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("REPAY_TYPE")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _reimburseTypeLists.clear();
        _reimburseTypeLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

  //获取收款账户列表
  Future _loadTotalAccountData() async {
    SVProgressHUD.show();
    // CardDataRepository()
    ApiClientAccount().getCardList(GetCardListReq()).then(
      (data) {
        SVProgressHUD.dismiss();
        if (data.cardList != null) {
          // if (mounted) {
          setState(() {
            _totalAccoutList.clear();
            _totalAccoutList.addAll(data.cardList);
            RemoteBankCard card = _totalAccoutList[0];
            _loanAccount = card.cardNo;
            _listDataMap['payAcNo'] = card.cardNo;
            _requestDataMap['payAcNo'] = card.cardNo;
          });
        }
      },
    ).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

// loan/interestRate/queryInterestRate

  @override
  void initState() {
    //网络请求，数据等都在这里进行创建
    super.initState();
    _getLoanPurposeList(); //贷款目的
    _getLoanTimeList(); //获取贷款期限
    _loadTotalAccountData(); //获取贷款账户列表
    _getLoanRepayTypeList(); //获取还款方式

    focusnode.addListener(() {
      if (focusnode.hasFocus) {
        //得到焦点
        String text = _recipientsController.text;
        int length = text.length;

        RegExp postalcode = new RegExp(r'^(0\d)');
        if (postalcode.hasMatch(text)) {
          _recipientsController.text = text.substring(1);
          _recipientsController.selection = TextSelection.collapsed(
              offset: _recipientsController.text.length);
        }
        if (double.parse(_recipientsController.text) > max) {
          _recipientsController.text = formatDouble(max, 2);
          _recipientsController.selection = TextSelection.collapsed(
              offset: _recipientsController.text.length);
        }
      } else {
        //失去焦点 去请求接口并计算
        _checkInputValueAndRate();
        _loadQueryIntereRateData();
      }
    });
  }

//贷款领用界面查询客户授信额度信息的接口

//先去请求/loan/contracts/getCreditlimitByCust  拿到iratCd1 参数，再去请求利率接口拿到利率和还款计划
  Future _loadQueryIntereRateData() async {
    var req = LoanGetCreditlimitReq(
      '',
      '',
      accountInfo.lmtNo,
      'L',
    );
    // LoanDataRepository()
    ApiClientLoan().loanCreditlimitInterface(req).then((data) {
      if (data.getCreditlimitByCusteDTOList != null) {
        //判断数据不为空
        if (mounted) {
          setState(() {
            GetCreditlimitByCusteDTOList custcd =
                data.getCreditlimitByCusteDTOList[0];
            iratCd1 = custcd.iratCd1 != '' ? custcd.iratCd1 : 'E10';
            _limitCusteModel = custcd;
            _checkInputValueAndRate(); //利率判断
          });
        }
      }
    }).catchError((e) {
      setState(() {
        _recipientsController.text = '';
      });
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

//获取当前的利率
  Future<void> _loadGrossCalculationData() async {
    var req = LoanIntereRateReq(
        accountInfo.bookBr, accountInfo.ccy, iratCd1, _mothCode);
    SVProgressHUD.show();
    // ForexTradingRepository()
    ApiClientBill().loanGetRateInterface(req).then((data) {
      SVProgressHUD.dismiss();
      //获取利率在去进行试算
      if (mounted) {
        setState(() {
          interestRate = data.interestRate.toString();
          _loadTrialDate(); //拿到利率进行失算
        });
      }
    }).catchError((e) {
      print(e.toString());
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

//领用试算的接口
  Future _loadTrialDate() async {
    _trailList.clear();
    var req = LoanTrailReq(
      accountInfo.ccy, //货币
      '1', //频率 还款周期
      'M', //频率单位
      _reimburseCode, //还款方式
      double.parse(_recipientsController.text), //贷款本金
      double.parse(interestRate), //贷款利率
      _dateCode, //总期数
    );
    // LoanDataRepository()
    ApiClientLoan().loanPilotComputingInterface(req).then((data) {
      if (data.loanTrialDTOList != null) {
        setState(() {
          _trailList.addAll(data.loanTrialDTOList); //添加所有的列表
          LoanTrialDTOList modellist = _trailList[0];
          _totalInterest = modellist.totInt; //总利息
          var year = modellist.payDt.substring(5);
          _trailStr = S.current.loan_trail_plan_first +
              year +
              ',' +
              S.current.loan_trail_plan_second +
              modellist.payAmt;
          _trailModel = modellist;
        });
      }
    }).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    //释放
    focusnode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoanAccountDOList accountInfo = ModalRoute.of(context).settings.arguments;
    this.accountInfo = accountInfo;
    max = double.parse(accountInfo.bal); //保存可使用的额度

    return Scaffold(
        //防止挤压溢出
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(S.current.loan_trail_title),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          color: HsgColors.commonBackground,
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
                      //可用额度
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        S.current.loan_detail_available_amount +
                            ' ' +
                            accountInfo.ccy +
                            accountInfo.bal,
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
                            margin: EdgeInsets.only(right: 14.5, top: 10),
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
                              focusNode: focusnode,
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
                          _trailStr,
                          _repamentPlanAlert(),
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
      FocusScope.of(context).requestFocus(FocusNode());
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
              _dateCode = type.code;
              if (int.parse(type.code) < 10) {
                _mothCode = 'M00' + type.code;
              } else {
                _mothCode = 'M0' + type.code;
              }
              _checkInputValueAndRate(); //利率判断
            } else if (i == 1) {
              _goal = str;
              _listDataMap['loanPurpose'] = str; //名称
              _requestDataMap['loanPurpose'] = type.code; //ID
            } else {
              _reimburseStr = str;
              _listDataMap['repaymentMethod'] = str; //名称
              _requestDataMap['repaymentMethod'] = type.code; //ID
              _reimburseCode = type.code;
              _checkInputValueAndRate(); //利率判断
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
      bankCards = bankCards.toSet().toList(); //去重
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

//还款计划弹窗
  _repamentPlanAlert() {
    return () async {
      if (_trailList.length <= 0) {
        return;
      } else {
        final result = await showHsgBottomSheet(
            context: context,
            builder: (context) => HsgBottomTrailPlanChiose(
                  title: S.current.repayment_plan,
                  listItems: this._trailList,
                ));

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
              padding: EdgeInsets.only(left: 10),
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
                    width: MediaQuery.of(context).size.width / 2 - 110,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //右侧文本
                  // Padding(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(right: 12),
                  child: item == ''
                      ? Text(S.current.please_select,
                          style: TextStyle(color: HsgColors.textHintColor),
                          textAlign: TextAlign.end) //占位文本
                      : Text(
                          //文本
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
    _listDataMap["totalInterst"] = _trailModel.totInt; //总利息
    _listDataMap["price"] = _recipientsController.text; //金额
    _listDataMap["repayPlan"] = _trailStr; //计划
    _listDataMap["availableCredit"] = accountInfo.bal; //可借款额度

    _requestDataMap["totalInterst"] = _trailModel.totInt; //总利息
    _requestDataMap["price"] = _recipientsController.text; //金额
    _listDataMap["repayPlan"] = _trailStr; //计划
    _listDataMap["availableCredit"] = accountInfo.bal; //可用额度

    _requestDataMap["acNo"] = accountInfo.lnac; //贷款帐号
    _requestDataMap["interestRate"] = interestRate; //利率
    _requestDataMap["planPayData"] = _trailModel.payDt; //还款计划模型

    LoanTrialDTOList _lastModel = _trailList.last;
    _requestDataMap["matuDt"] = _lastModel.payDt;

    Map dataList = {
      //key的名字不能跟后面的值相同
      'reviewList': _listDataMap,
      'requestList': _requestDataMap,
      'loanAccountDOList': accountInfo,
      'limitCusteModel': _limitCusteModel //额度信息数据
    };

    Navigator.pushNamed(context, pageLoanCollectionPreview,
        arguments: dataList);
  }

//直接删除多余的小数(不四舍五入、向上或向下)
  static formatDouble(double num, int postion) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  void _checkInputValueAndRate() {
    if (iratCd1 != '' &&
        _mothCode != '' &&
        _recipientsController.text != '' &&
        _reimburseCode != '') {
      //调用试算的接口
      _loadGrossCalculationData();
    }
  }
}
