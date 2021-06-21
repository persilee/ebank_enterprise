import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/loan/application_loan.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_get_new_rate.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_trial_rate.dart';
import 'package:ebank_mobile/data/source/model/other/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_bill.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_transfer.dart';
import 'package:ebank_mobile/page/mine/id_cardVerification_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_single_picker.dart';
import 'package:ebank_mobile/widget/money_text_input_formatter.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 贷款领用页面
/// Author: pengyikang
class LoanReference extends StatefulWidget {
  final LoanAccountDOList accountInfo;

  LoanReference({Key key, this.accountInfo}) : super(key: key);

  @override
  _LoanReferenceState createState() => _LoanReferenceState();
}

class _LoanReferenceState extends State<LoanReference> {
  bool _checkBoxValue = false; //复选框默认值
  bool _isButton = false; //按钮是否能点击
  String _language = Intl.getCurrentLocale(); //版本语言
  // String _totalInterest = ''; //总利息
  String _mothCode = ''; //月份编码
  double max = 0; //贷款最大限额
  double min = 0; //贷款最小金额

  String iratCd1 = ''; //用户额度编号保存

  String _balStr = ''; //可用额度
  String _getCcy = ''; //领取币种

  String _conversionTotalAmount = '0.00'; //领用换算金额
  String _documentTotalAmount = '0.00'; //单据换算金额
  String _totalAmount = '0.00'; //最终提款金额
  double _finRaPctValue = 0; //融资比例金额

  int _ccyId = 0; //币种下标
  List _currencyList = []; //币种列表

  bool _financingZero = false; //融资比例 大于0显示单据金额，单据货币 单据金额
  // double _documentTotalAmount = 0.0; //单据金额*融资比例

  String _documentsCcy = ''; //单据货币
  List _documentCcyList = []; //币种列表
  int _documentCcyIndex = 0; //单据币种下标

  String _documentsAmount = ''; //单据金额
  var _documentsAmountController = new TextEditingController(); //金额输入框

  bool _isShowDocument = false; //是否提示单据金额
  bool _isShowInputText = false; //是否提示输入金额

  bool _inputHasLength = false; //金额输入框大于0
  bool _documentHasLength = false; //单据金额输入框大于0

  final f = NumberFormat("#,##0.00", "en_US"); //USD有小数位的处理
  final fj = NumberFormat("#,##0", "ja-JP"); //日元没有小数位的处理

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

  FocusNode focusnode = FocusNode(); //监听编辑的输入
  FocusNode _doucumentFocusnode = FocusNode(); //监听编辑的输入

  GetCreditlimitByCusteDTOList _limitCusteModel; //额度接口数据
  LoanGetNewRateResp _rateModel; //利率模型

  //获取借款期限
  _getLoanTimeList() {
    // 目前有 1 2 3 6 12。大于返回期限的月份不能进行显示。需手动解决
    ApiClientOpenAccount().getIdType(GetIdTypeReq("LOAN_TERM")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _deadLineLists.clear();
        for (int i = 0; i < data.publicCodeGetRedisRspDtoList.length; i++) {
          IdType type = data.publicCodeGetRedisRspDtoList[i];
          if (int.parse(type.code) <= int.parse(_limitCusteModel.tenorDays)) {
            _deadLineLists.add(type);
          }
        }
      }
    });
  }

  //获取借款用途
  Future _getLoanPurposeList() async {
    ApiClientOpenAccount().getIdType(GetIdTypeReq("LOAN_PUR")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _goalLists.clear();
        _goalLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
    });
  }

  //还款方式
  _getLoanRepayTypeList() {
    // 返回空代表到期还本还息，返回1代表等额本息，返回2代表等额本金
    ApiClientOpenAccount()
        .getIdType(GetIdTypeReq("REPAY_TYPE_LN"))
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        for (int i = 0; i < data.publicCodeGetRedisRspDtoList.length; i++) {
          IdType type = data.publicCodeGetRedisRspDtoList[i];
          if (_limitCusteModel.lnInsType == '' && type.code == "0") {
            _checkReimburse(data.publicCodeGetRedisRspDtoList[0]);
            _reimburseCode = type.code;
          } else {
            if (double.parse(_limitCusteModel.lnInsType) ==
                double.parse(type.code)) {
              _checkReimburse(type);
              _reimburseCode = type.code;
            }
          }
        }
      }
    });
  }

  _checkReimburse(IdType type) {
    setState(() {
      if (_language == 'zh_CN') {
        _reimburseStr = type.cname;
      } else if (_language == 'zh_HK') {
        _reimburseStr = type.chName;
      } else {
        _reimburseStr = type.name;
      }
    });
  }

  //获取收款账户列表
  Future _loadTotalAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);
    HSProgressHUD.show();
    ApiClientAccount().getCardList(GetCardListReq(custID)).then(
      (data) {
        HSProgressHUD.dismiss();
        if (data.cardList != null) {
          setState(() {
            _totalAccoutList.clear();
            _totalAccoutList.addAll(data.cardList);
            RemoteBankCard card = _totalAccoutList[0];
            _loanAccount = FormatUtil.formatSpace4(card.cardNo);
            _listDataMap['payAcNo'] = card.cardNo;
            _requestDataMap['payAcNo'] = card.cardNo;
          });
        }
      },
    ).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  // 获取币种列表
  Future _loadLocalCcy() async {
    ApiClientOpenAccount().getIdType(GetIdTypeReq("CCY")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        setState(() {
          _documentCcyList.clear();
          _documentCcyList.addAll(data.publicCodeGetRedisRspDtoList);
          IdType type = data.publicCodeGetRedisRspDtoList[0];
          _documentsCcy = type.code;
        });
      }
    });
  }

  //  buyCcy: _getCcy,
  //  sellCcy: widget.accountInfo.ccy,
  //  buyAmount: _recipientsController.text,
  //币种汇率换算，写上不同的汇率计算接口，这样可以区分开写

  //输入领用金额
  _inputAmountConversion(String buyCcy, String sellCcy, String inputStr) async {
    String _totalMoney = '';
    try {
      _totalMoney = await _calculateTotalRateValue(buyCcy, sellCcy, inputStr);
      if (_totalMoney == '') {
        _recipientsController.text = '';
        return;
      }

      setState(() {
        if (!_financingZero) {
          //融资比例小于0，说明没有单据
          _totalAmount = _conversionTotalAmount = _totalMoney;
        } else {
          if (_inputHasLength && _documentHasLength) {
            //两者输入框都已经输入,就需要拿换算金额进行判断比较了.提款金额大于单据金额
            if (double.parse(_documentTotalAmount) >
                double.parse(_totalMoney)) {
              _conversionTotalAmount = _totalMoney;
              _totalAmount = _totalMoney; //提款金额
            } else {
              //小于单据金额。那就以输入金额为准
              _conversionTotalAmount = _totalMoney;
              _totalAmount = _documentTotalAmount;
            }
          } else {
            _conversionTotalAmount = _totalMoney; //保存单据金额
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

//单据汇率查询
  _documentAmountConversion(
      String buyCcy, String sellCcy, String inputStr) async {
    String _totalMoney = '';
    try {
      _totalMoney = await _calculateTotalRateValue(buyCcy, sellCcy, inputStr);
      if (_totalMoney == '') {
        _documentsAmountController.text = '';
        return;
      }
      //还需要判断是否超过了最大金额
      if (buyCcy == sellCcy) {
        //币种相同的情况下
        if (double.parse(_totalMoney) > double.parse(_limitCusteModel.avaBal)) {
          setState(() {
            _documentsAmountController.text = '';
            _documentTotalAmount = '0.00';
          });
          //超过最大金额
          HSProgressHUD.showToastTip(
              S.current.loan_get_document_Conversion_amount +
                  S.current.loan_get_max_tips +
                  S.current.remaining_available_amount);
          return;
        }
      }

      //如果计算出来的金额小于最低提取金额
      if (min > double.parse(_totalMoney)) {
        _documentsAmountController.text = '';
        HSProgressHUD.showToastTip(S.current.loan_Recipients_Amount +
            S.current.loan_get_limit_tips +
            S.current.loan_available_minimum_receive);
        return;
      }
      setState(() {
        //如果当前金额小于后台返回的最小
        if (_inputHasLength && _documentHasLength) {
          //两者输入框都已经输入,就需要进行判断比较了.提款金额大于单据金额
          if (double.parse(_conversionTotalAmount) >
              double.parse(_totalMoney)) {
            _totalAmount = _documentTotalAmount = _totalMoney;
          } else {
            //小于单据金额。那就以输入金额为准
            _documentTotalAmount = _totalMoney;
            _totalAmount = _conversionTotalAmount;
          }
        } else {
          _documentTotalAmount = _totalMoney; //保存单据金额
        }
      });
    } catch (e) {
      print(e);
    }
  }

//计算最低提取金额
  _calculateMinimumExchange(String buyCcy, String sellCcy) async {
    String _totalMoney = '';
    try {
      _totalMoney = await _calculateTotalRateValue(
          buyCcy, sellCcy, _limitCusteModel.minDdAmt);
      min = double.parse(_totalMoney); //保存最低提取金额
    } catch (e) {
      print(e);
    }
  }

  //总计算规则
  Future<String> _calculateTotalRateValue(
      String buyCcy, String sellCcy, String inputStr) async {
    try {
      HSProgressHUD.show(); //当前是买入价
      TransferTrialReq req = TransferTrialReq(
          opt: "B",
          buyCcy: sellCcy,
          sellCcy: buyCcy,
          buyAmount: '0',
          sellAmount: inputStr,
          exGroup: 'SMR' //昨日汇率，只有领用接口才能传值
          );
      TransferTrialResp resp = await Transfer().transferTrial(req);
      HSProgressHUD.dismiss();
      if (this.mounted) {
        return resp.optExAmt;
      }
    } catch (e) {
      HSProgressHUD.dismiss();
      print(e.toString());
      return '';
    }
  }

  @override
  void initState() {
    //网络请求，数据等都在这里进行创建
    super.initState();
    _getCcy = widget.accountInfo.ccy;
    _loadQueryIntereRateData(); //获取用户的授信额度
    _getLoanPurposeList(); //贷款目的
    _loadTotalAccountData(); //获取贷款账户列表
    _loadLocalCcy(); //获取收款币种

    //金额监听键盘的输入
    _recipientsController.addListener(() {
      String text = _recipientsController.text;
      RegExp postalcode = new RegExp(r'^(0\d)');
      if (postalcode.hasMatch(text)) {
        _recipientsController.text = text.substring(1);
        _recipientsController.selection =
            TextSelection.collapsed(offset: _recipientsController.text.length);
      }
      if (double.parse(_recipientsController.text) > max) {
        //不能超过最大限额
        _recipientsController.text = formatDouble(max, 2);
        _recipientsController.selection =
            TextSelection.collapsed(offset: _recipientsController.text.length);
      }
    });

    focusnode.addListener(() {
      //监听键盘的弹起与结束
      if (focusnode.hasFocus) {
        //得到焦点
      } else {
        //此监听方法是是输入框有值才会走
        //失去焦点 去请求接口并计算
        if (double.parse(_recipientsController.text) < min) {
          //不能小于最低限额
          _recipientsController.text = formatDouble(min, 2);
          _recipientsController.selection = TextSelection.collapsed(
              offset: _recipientsController.text.length);
        }

        setState(() {
          if (_recipientsController.text == '' ||
              double.parse(_recipientsController.text) <= 0) {
            //那么其他的选项都得变更数值才行。
            _cleanInputDataStr();
            //判断自己本身有没有输入金额
            _isShowInputText = true;
          } else {
            _isShowInputText = false;
          }

          if (_documentHasLength) {
            _isShowDocument = false;
          } else {
            _isShowDocument = true;
          }
        });

        if (double.parse(_recipientsController.text) > 0 ||
            _recipientsController.text != '') {
          _inputHasLength = true;
          _inputAmountConversion(widget.accountInfo.ccy, _getCcy,
              _recipientsController.text); //计算兑换金额
        }
        _checkInputValueAndRate(); //校验成功即可去进行利率获取
      }
    });

    //单据金额
    _documentsAmountController.addListener(() {
      String text = _documentsAmountController.text;
      RegExp postalcode = new RegExp(r'^(0\d)');
      if (postalcode.hasMatch(text)) {
        _documentsAmountController.text = text.substring(1);
        _documentsAmountController.selection = TextSelection.collapsed(
            offset: _documentsAmountController.text.length);
      }
    });

    //单据金额
    _doucumentFocusnode.addListener(() {
      if (_doucumentFocusnode.hasFocus) {
        //得到焦点
      } else {
        setState(() {
          //先判断领用金额的输入
          if (_inputHasLength) {
            _isShowInputText = false;
          } else {
            _isShowInputText = true;
          }
          if (_documentsAmountController.text == '' ||
              double.parse(_documentsAmountController.text) <= 0) {
            //判断自己本身有没有输入金额
            _isShowDocument = true;
          } else {
            _isShowDocument = false;
          }
        });

        if (double.parse(_documentsAmountController.text) > 0 &&
            _documentsAmountController.text != '') {
          _documentHasLength = true;
          double documentTotalAmount =
              double.parse(_documentsAmountController.text) *
                  _finRaPctValue; //单据金额 * 融资比例
          _documentAmountConversion(
              _documentsCcy, _getCcy, documentTotalAmount.toString()); //计算兑换金额
        }
        _checkInputValueAndRate(); //校验成功即可去进行利率获取
      }
    });
  }

//当输入空的时候清空其他的选项字段值
  _cleanInputDataStr() {
    setState(() {
      if (_financingZero) {
        //融资比例大于0。

      } else {
        //没有融资比例
        _conversionTotalAmount = '0.00'; //领用换算金额
        _totalAmount = '0.00'; //最终提款金额
        _trailList.clear(); //清空还款计划
        _deadLine = ''; //贷款期限
        _dateCode = ''; //贷款期限编
      }
    });
  }

//贷款领用界面查询客户授信额度信息的接口
//先去请求/loan/contracts/getCreditlimitByCust  拿到iratCd1 参数，再去请求利率接口拿到利率和还款计划
  Future _loadQueryIntereRateData() async {
    var req = LoanGetCreditlimitReq(
      '',
      '',
      widget.accountInfo.lmtNo,
      'L',
    );
    ApiClientLoan().loanCreditlimitInterface(req).then((data) {
      if (data.getCreditlimitByCusteDTOList != null) {
        //判断数据不为空
        if (mounted) {
          GetCreditlimitByCusteDTOList custcd =
              data.getCreditlimitByCusteDTOList[0];
          _limitCusteModel = custcd;
          _currencyList.addAll(custcd.loanRateList); //保存币种列表
          _checkGetCcyIdIndex();

          _financingZero =
              double.parse(custcd.finRaPct) > 0 ? true : false; //判断是否显示融资比例
          _finRaPctValue = double.parse(custcd.finRaPct) / 100; //融资比例

          max = double.parse(custcd.avaBal); //保存可使用的额度
          _balStr = widget.accountInfo.ccy == 'JPY'
              ? fj.format(double.parse(_limitCusteModel.avaBal ?? '0')) ?? ''
              : f.format(double.parse(_limitCusteModel.avaBal ?? '0')) ?? '';

          _calculateMinimumExchange(
              widget.accountInfo.ccy, widget.accountInfo.ccy); //计算最低提取金额

          _getLoanTimeList(); //还款期限
          _getLoanRepayTypeList(); //还款方式
        }
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      setState(() {
        _recipientsController.text = '';
      });
      HSProgressHUD.showToast(e);
    });
  }

  //获取币种下标
  _checkGetCcyIdIndex() {
    for (int i = 0; i < _currencyList.length; i++) {
      LoanRateList listCcy = _currencyList[i];
      if (widget.accountInfo.ccy == listCcy.lnCcy) {
        _ccyId = i;
      }
    }
  }

//获取当前的利率
  void _loadGrossCalculationData() {
    var req = LoanGetNewRateReq(
      double.parse(_totalAmount), //贷款本金
      _getCcy, //币种
      widget.accountInfo.lnac, //贷款账户
      _mothCode, //月份
    );
    HSProgressHUD.show();
    ApiClientBill().loanGetNewRateInterface(req).then((data) {
      HSProgressHUD.dismiss();
      //获取利率在去进行试算
      if (mounted) {
        setState(() {
          _rateModel = data; //保存利率模型
          // _loadTrialDate(); //拿到利率进行试算
        });
      }
    }).catchError((e) {
      //需要把利率的接口
      setState(() {
        _deadLine = '';
        _dateCode = "";
        _mothCode = '';
      });
      HSProgressHUD.showToast(e);
    });
  }

//领用试算的接口
  Future _loadTrialDate() async {
    _trailList.clear();
    // _rateModel.repType == "";  周期：额度的期限 单位：M 还款方式：1   期数：1
    // repType 有值 还款方式：本利和公式  期数：期限/还款周期

    var req = LoanTrailReq(
      _getCcy, //货币
      _rateModel.setPeRd, //频率 还款周期
      _rateModel.setUnit, //频率单位
      _rateModel.repType, //还款方式
      double.parse(_totalAmount), //贷款本金
      double.parse(_rateModel.intRat), //贷款利率
      _dateCode, //总期数
    );

    ApiClientLoan().loanPilotComputingInterface(req).then((data) {
      if (data.loanTrialDTOList != null) {
        setState(() {
          _trailList.addAll(data.loanTrialDTOList); //添加所有的列表
          LoanTrialDTOList modellist = _trailList[0];
          // _totalInterest = modellist.totInt; //总利息
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
      HSProgressHUD.showToast(e);
    });
  }

  @override
  void dispose() {
    super.dispose();
    //释放
    focusnode.dispose();
    _doucumentFocusnode.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        S.current.remaining_available_amount +
                            ': ' +
                            '(' +
                            widget.accountInfo.ccy +
                            ') ' +
                            _balStr,
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Color(0xFF262626), fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //贷款账号
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        S.current.loan_account + ': ' + widget.accountInfo.lnac,
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
                              widget.accountInfo.ccy,
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
                                  border: InputBorder.none,
                                  hintText:
                                      S.current.loan_available_minimum_receive +
                                          ' ' +
                                          min.toString(),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Color(0xFFCCCCCC))),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(11),
                                FilteringTextInputFormatter.allow(
                                  RegExp(widget.accountInfo.ccy == 'JPY'
                                      ? "[0-9]"
                                      : "[0-9.]"),
                                ),
                                MoneyTextInputFormatter(),
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
                    _isShowInputText
                        ? Container(
                            //单据金额提示
                            padding: EdgeInsets.fromLTRB(20, 5, 10, 10),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Text(
                              S.current.please_input +
                                  S.current.loan_Recipients_Amount,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: HsgColors.redText, fontSize: 13),
                            ),
                          )
                        : Container(),
                    // Container(
                    //   padding: EdgeInsets.only(bottom: 21),
                    // )
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
                    _financingZero
                        ? Container(
                            margin: EdgeInsets.fromLTRB(0, 16, 0, 13),
                            color: Colors.white,
                            child: Column(
                              children: [
                                //单据货币
                                Container(
                                    color: Colors.white,
                                    child: selectInkWellToBlackTitle(
                                      S.current.loan_get_document_ccy,
                                      _documentsCcy,
                                      _showDialog(_documentCcyIndex,
                                          _documentCcyList, true),
                                    )),
                                Divider(
                                  height: 0,
                                ),
                                _creatDocumentColunm(
                                    //单据金额
                                    S.current.loan_get_document_amount,
                                    S.current.please_input,
                                    _documentsAmountController,
                                    TextInputType.numberWithOptions(
                                        decimal: true)),
                                Divider(
                                  height: 0,
                                ),
                                _isShowDocument
                                    ? Container(
                                        //单据金额提示
                                        padding:
                                            EdgeInsets.fromLTRB(20, 5, 10, 0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Text(
                                          S.current.please_input +
                                              S.current
                                                  .loan_get_document_amount,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: HsgColors.redText,
                                              fontSize: 13),
                                        ),
                                      )
                                    : Container(),
                                _creatCommonColumn(
                                    //单据总额
                                    S.current
                                        .loan_get_document_Conversion_amount,
                                    _documentTotalAmount),
                                Divider(height: 0),
                                Container(
                                  //融资比例
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 0),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Text(
                                    S.current.loan_get_financing_proportion +
                                        ': ' +
                                        _finRaPctValue.toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Color(0xFF3394D4), fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
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
                    //领用币种
                    Container(
                        color: Colors.white,
                        child: selectInkWellToBlackTitle(
                          S.current.loan_collection_currency,
                          _getCcy,
                          _showDialog(_ccyId, _currencyList, false),
                        )),
                    //换算金额
                    _creatCommonColumn(
                        S.current.loan_exchange_amount, _conversionTotalAmount),
                    Divider(
                      height: 0,
                    ),
                    _creatCommonColumn(
                        //最终提款金额
                        S.current.loan_get_total_amount,
                        _totalAmount),
                    Divider(
                      height: 0,
                    ),
                    // // //还款计划
                    // Container(
                    //     color: Colors.white,
                    //     child: selectInkWellToBlackTitle(
                    //       S.current.repayment_plan,
                    //       _trailStr,
                    //       _repamentPlanAlert(),
                    //     )),
                    //还款方式
                    _creatCommonColumn(S.current.repayment_ways, _reimburseStr),
                    Divider(
                      height: 0,
                    ),
                    Divider(
                      height: 0,
                    ),
                    // _creatCommonColumn(
                    //     //总利息
                    //     S.current.loan_Total_Interest,
                    //     _totalInterest),
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

  Widget _creatDocumentColunm(String leftTitle, String hitStr,
      TextEditingController rightControl, TextInputType keyboard) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 11, 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //总利息
            child: Text(leftTitle,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              child: TextField(
                controller: _documentsAmountController,
                focusNode: _doucumentFocusnode,
                autocorrect: false,
                autofocus: false,
                textAlign: TextAlign.end,
                style: FIRST_DEGREE_TEXT_STYLE,
                keyboardType: keyboard,
                decoration: InputDecoration.collapsed(
                  hintText: hitStr,
                  hintStyle: HINET_TEXT_STYLE,
                ),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.allow(
                    RegExp(
                        widget.accountInfo.ccy == 'JPY' ? "[0-9]" : "[0-9.]"),
                  ),
                  MoneyTextInputFormatter(),
                ],
                // onChanged: (text) {},
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _creatCommonColumn(String leftTitle, String rightTitle) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 11, 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //总利息
            child: Text(leftTitle,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
          ),
          Container(
            child: Text(
              rightTitle,
              style: TextStyle(
                color: Color(0xFF3394D4), // Color(0xFF9C9C9C),
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }

  //币种弹窗内容
  _showDialog(int index, List<dynamic> list, bool isDocument) {
    return () async {
      List<String> tempList = [];
      list.forEach((e) {
        if (isDocument) {
          tempList.add(e.code);
        } else {
          tempList.add(e.lnCcy);
        }
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
          if (isDocument) {
            //单据币种
            _documentCcyIndex = result;
            _documentsCcy = tempList[result];
            _documentCheckCcy(isDocument);
          } else {
            //兑换币种,是兑换币种就需要全盘去进行试算
            _ccyId = result;
            _getCcy = tempList[result];
            _loanChenkCcy();
          }
        });
      }
    };
  }

//期限，用途 ，还款方式底部弹窗内容选择
  _select(String title, List<IdType> list, int i) {
    return () {
      FocusScope.of(context).requestFocus(FocusNode());
      List<String> tempList = [];
      list.forEach((e) {
        if (_language == 'zh_CN') {
          tempList.add(e.cname);
        } else if (_language == 'zh_HK') {
          tempList.add(e.chName);
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
                _mothCode = '000' + type.code;
              } else {
                _mothCode = '00' + type.code;
              }
              _requestDataMap['mothCode'] = _mothCode; //名称
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
          _requestDataMap['payAcNo'] = bankCards[result];
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: HsgColors.firstDegreeText,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 110,
                    child: title == S.current.transfer_to_account
                        ? Text(
                            S.current.loan_Estimated_time_account,
                            style: TextStyle(
                              fontSize: 13,
                              color: HsgColors.describeText,
                            ),
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
                          style: TextStyle(
                            color: HsgColors.textHintColor,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.end) //占位文本
                      : Text(
                          //文本
                          item,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          style: FIRST_DEGREE_TEXT_STYLE,
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
            _conetentJump(S.current.loan_recipients_agreement1,
                'personLoanContact'), //《个人消费贷款合同》
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_recipients_agreement2,
                'authPersonCreditReport'), //《个人信用报告查询授权书》
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
        _inputHasLength &&
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

//单据币种进行的
  _documentCheckCcy(bool _isDocument) {
    //  需要检查当前是否有输入金额才能去进行试算
    //单据货币
    if (_documentHasLength) {
      _documentAmountConversion(
          _documentsCcy, _getCcy, _documentsAmountController.text);
    } else {
      setState(() {});
    }
  }

  //领用币种的校验，领用币种一更新，输入的金额与单据金额就需要重新试算
  _loanChenkCcy() async {
    if (double.parse(_limitCusteModel.minDdAmt) > 0) {
      //最低领用金额需要变更
      await _calculateMinimumExchange(widget.accountInfo.ccy, _getCcy);
    }

    //如果有单据
    if (_financingZero) {
      //有融资比例
      //如果两个币种都有值
      if (_inputHasLength && _documentHasLength) {
        String _inpuyMoney = await _calculateTotalRateValue(
            widget.accountInfo.ccy,
            _getCcy,
            _recipientsController.text); //领用金额输入框
        String _documentMoney = await _calculateTotalRateValue(
            _documentsCcy, _getCcy, _documentsAmountController.text); //单据金额输入框

        if (_inpuyMoney != '' && _documentMoney != '') {
          setState(() {
            if (double.parse(_inpuyMoney) > double.parse(_documentMoney)) {
              _totalAmount = _documentMoney; //使用单据金额
            } else {
              _totalAmount = _inpuyMoney; //使用领用金额
            }
            _conversionTotalAmount = _inpuyMoney; //领用金额
            _documentTotalAmount = _documentMoney; //单据金额
          });
          _checkInputValueAndRate(); //变更之后再另外请求数据
        }
      } else {
        //领用币种变更，领用金额, 单据金额需要重新试算
        if (_documentHasLength) {
          await _documentAmountConversion(
              _documentsCcy, _getCcy, _documentsAmountController.text);
          _checkInputValueAndRate(); //变更之后再另外请求数据
        }

        if (_inputHasLength) {
          await _inputAmountConversion(
              widget.accountInfo.ccy, _getCcy, _recipientsController.text);
          _checkInputValueAndRate(); //变更之后再另外请求数据
        }
      }
    } else {
      //没有融资比例

      if (_inputHasLength) {
        await _inputAmountConversion(
            widget.accountInfo.ccy, _getCcy, _recipientsController.text);
        _checkInputValueAndRate(); //变更之后再另外请求数据
      }
    }
  }

//下一步 确定按钮
  _openBottomSheet() {
    //需要传值
    _listDataMap["price"] = _totalAmount; //金额
    _listDataMap["repayPlan"] = _trailStr; //计划
    _listDataMap["documentAmount"] = _documentTotalAmount; //单据金额
    _listDataMap["reimburseStr"] = _reimburseStr; //还款方式
    _listDataMap["reimburseCode"] = _reimburseCode; //还款code

    _requestDataMap["price"] = _totalAmount; //金额
    _listDataMap["repayPlan"] = _trailStr; //计划
    _listDataMap["availableCredit"] = _limitCusteModel.avaBal; //可用额度

    _requestDataMap["acNo"] = widget.accountInfo.lnac; //贷款帐号
    _requestDataMap["interestRate"] = '0.1'; //interestRate; //利率
    // _requestDataMap["planPayData"] = _trailModel.payDt; //还款计划模型
    _requestDataMap["ccy"] = _getCcy; //_trailModel.ccy; //币种类型

    // LoanTrialDTOList _lastModel = _trailList.last;
    // _requestDataMap["matuDt"] = '2021-22022'; //_lastModel.payDt;

    Map dataList = {
      //key的名字不能跟后面的值相同
      'reviewList': _listDataMap,
      'requestList': _requestDataMap,
      'loanAccountDOList': widget.accountInfo,
      'limitCusteModel': _limitCusteModel, //额度信息数据
      'rateModel': _rateModel //利率接口信息
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

  //校验试算的接口
  void _checkInputValueAndRate() {
    if (_financingZero) {
      //有单据的判断
      if (_mothCode != '' &&
          _inputHasLength &&
          _documentHasLength &&
          _reimburseCode != '') {
        //月份 输入的金额  还款方式
        //调用试算的接口
        _loadGrossCalculationData();
      }
    } else {
      //没有单据
      if (_mothCode != '' && _inputHasLength && _reimburseCode != '') {
        //月份 输入的金额  还款方式
        //调用试算的接口
        _loadGrossCalculationData();
      }
    }
  }
}
