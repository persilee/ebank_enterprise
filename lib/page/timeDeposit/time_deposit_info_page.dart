/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 我的存单详情页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/get_account_overview_info.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_early_contract.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_record_info.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_trial.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_td_prod_inst_code.dart';
import 'package:ebank_mobile/data/source/model/update_time_deposit_con_info.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_timeDeposit.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/pay_password_check.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';

import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';

class PageDepositInfo extends StatefulWidget {
  final DepositRecord deposit;
  // final List<TotalAssetsCardListBal> cardList;
  PageDepositInfo({Key key, this.deposit}) : super(key: key);

  @override
  _PageDepositInfo createState() => _PageDepositInfo();
}

class _PageDepositInfo extends State<PageDepositInfo> {
  var ciNo = '';

  var ccy = '';

  var bal = '';

  var auctCale = '';

  var valDate = '';

  var mtDate = '';

  var conNos = '';

  var settDbAc = '';

  GetDepositTrialResp _trialResp;

  List<TotalAssetsCardListBal> cardList;
  //第二个接口所需变量
  var conMatAmt = '';

  var matAmt = '';

  //第三个接口所需变量

  var eryInt = '';

  var eryRate = '';

  var hdlFee = '';

  var pnltFee = '';

  var settDdAc = '';

  var settBals = '';

  var _instCode = ''; //到期指示代码

  var instruction = ''; //到期指示

  var _changedInstruction = '';

  var _changedInstCode = '';

  var mainAc = '';

  var transferAc = '';

  // _PageDepositInfo(widget.deposit);

  List<String> cards = [];

  int _settAcPosition = 0;

  String _changedSettAcTitle = '';

  String _changedSettAc = '';

  String _paymentAc = '';

  bool _checkBoxValue = false; //复选框默认值

  List<String> instructions = [];

  List<String> instCodes = [];

  String language = Intl.getCurrentLocale();

  String productName;

  String _termUnit = '';

  String _modify;

  bool _btnIsLoadingR = false; // 提前结清按钮
  bool _btnIsLoadingUN = false; // 返回按钮
  bool _btnIsEnable = true;

  //获取网络请求
  @override
  void initState() {
    super.initState();
    _getInsCode();
    _getDetail();
    _loadData();
  }

  //右箭头图标
  Widget _rightArrow() {
    return Container(
      width: 20,
      child: Icon(
        Icons.keyboard_arrow_right,
        color: HsgColors.nextPageIcon,
      ),
    );
  }

  //到期指示按钮
  Widget _selectInstCodeBtn(
      String leftText, String rightText, bool isShowLine, bool isOptional) {
    return Container(
      padding: EdgeInsets.zero,
      child: FlatButton(
        padding: EdgeInsets.zero,
        child: _unit(leftText, rightText, isShowLine, isOptional),
        onPressed: () {
          _selectInstruction(context);
        },
      ),
    );
  }

  //结算账户按钮
  Widget _selectSettACBtn(
      String leftText, String rightText, bool isShowLine, bool isOptional) {
    return Container(
      padding: EdgeInsets.zero,
      // height: language == "en" &&
      //         leftText == S.current.tdInfo_interest_settlement_account
      //     ? 57
      //     : 45,
      child: FlatButton(
        padding: EdgeInsets.zero,
        child: _unit(leftText, rightText, isShowLine, isOptional),
        onPressed: () {
          _selectSettAc(context);
        },
      ),
    );
  }

  //结算账户弹窗
  _selectSettAc(BuildContext context) async {
    List<String> accounts = [];
    List<String> cardNo = [];
    for (var i = 0; i < cards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(cards[i]));
      cardNo.add(cards[i]);
      if (_changedSettAcTitle == cards[i]) {
        _settAcPosition = i;
      }
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => HsgBottomSingleChoice(
            title: S.current.settlement_account,
            items: accounts,
            lastSelectedPosition: _settAcPosition));
    if (result != null && result != false) {
      _settAcPosition = result;
      _changedSettAc = cardNo[result];
      _verificationDialog(
          S.current.tdEarlyRed_modify_settlement_account,
          S.current.tdEarlyRed_modify_settlement_account_determine +
              '\n' +
              FormatUtil.formatSpace4(_changedSettAc),
          _select);
    } else {
      return;
    }
    if (this.mounted) {
      setState(() {});
    }
  }

//弹窗
  _verificationDialog(
      String title, String message, void _load(String leftText)) async {
    showDialog(
      context: context,
      builder: (context) {
        return HsgAlertDialog(
            title: title,
            message: message,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel);
      },
    ).then(
      (value) {
        if (value == true) {
          _load(title);
        }
      },
    );
  }

  Widget _unit(
      String leftText, String rightText, bool isShowLine, bool isOptional) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: (MediaQuery.of(context).size.width - 42) / 7 * 3,
                  child: Text(
                    leftText,
                    style: FIRST_DEGREE_TEXT_STYLE,
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 42) / 7 * 4,
                child: Text(
                  rightText,
                  style: FIRST_DEGREE_TEXT_STYLE,
                  textAlign: TextAlign.right,
                ),
              ),
              isOptional ? _rightArrow() : Container(),
            ],
          ),
        ),
        isShowLine
            ? Container(
                height: 1,
                child: Divider(),
              )
            : Container(),
      ],
    );
  }

  //圆形复选框
  Widget _roundCheckBox() {
    return GestureDetector(
      onTap: () {
        if (this.mounted) {
          setState(() {
            _checkBoxValue = !_checkBoxValue;
          });
        }
      },
      child: Container(
        width: 20,
        margin: EdgeInsets.only(left: 16, top: 2.5, right: 5),
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

  //勾选协议
  Widget _agreement() {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
      ),
      width: MediaQuery.of(context).size.width - 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _roundCheckBox(),
          Container(
            margin: EdgeInsets.only(left: 15),
            width: MediaQuery.of(context).size.width - 52,
            padding: EdgeInsets.zero,
            child: Text(
              S.current.select_content,
              style: TextStyle(
                color: HsgColors.toDoDetailText,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //到期指示弹窗
  _selectInstruction(BuildContext context) async {
    // List<String> instructionDatas = [
    //   '0',
    //   '1',
    //   '2',
    //   '5',
    // ];
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.current.due_date_indicate,
        items: instructions,
      ),
    );
    if (this.mounted) {
      setState(() {
        if (result != null && result != false) {
          _changedInstruction = instructions[result];
          _changedInstCode = instCodes[result];
          _verificationDialog(
              S.current.tdEarlyRed_modify_expiration_instruction,
              S.current.tdEarlyRed_modify_expiration_instruction_determine +
                  '\n' +
                  _changedInstruction,
              _select);
        } else {
          // return {instCode, instCode};
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // deposit = ModalRoute.of(context).settings.arguments;
    print(widget.deposit.toJson());

    String _language = Intl.getCurrentLocale();
    String _nameStr = '';
    if (_language == 'zh_CN') {
      _nameStr = widget.deposit.lclName ?? widget.deposit.engName;
    } else if (_language == 'zh_HK') {
      _nameStr = widget.deposit.lclName ?? widget.deposit.engName;
    } else {
      _nameStr = widget.deposit.engName;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.receipt_detail),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              //付款账户
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.payment_account,
                      style: FIRST_DEGREE_TEXT_STYLE,
                    ),
                  ),
                  Container(
                    child: Text(
                      FormatUtil.formatSpace4(_paymentAc),
                      style: FIRST_DEGREE_TEXT_STYLE,
                    ),
                  )
                ],
              ),
            ),
            //整存整取
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _nameStr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: HsgColors.firstDegreeText,
                            ),
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                  Container(height: 0.5, color: HsgColors.divider),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //合约号
                  _unit(S.current.contract_number, conNos, true, false),
                  //币种
                  _unit(S.current.currency, ccy, true, false),
                  //存入金额
                  _unit(S.current.deposit_amount,
                      FormatUtil.formatSringToMoney(bal), true, false),
                  //存期
                  _unit(S.current.deposit_term, auctCale + _termUnit, true,
                      false),
                  //生效日期
                  _unit(S.current.effective_date, valDate, true, false),
                  //到期日期
                  _unit(S.current.due_date, mtDate, true, false),
                  //到期指示
                  _selectInstCodeBtn(
                      S.current.due_date_indicate, instruction, true, true),
                  //结算账户
                  _selectSettACBtn(
                      _instCode == "3"
                          ? S.current.tdInfo_interest_settlement_account
                          : S.current.settlement_account,
                      FormatUtil.formatSpace4(_changedSettAcTitle),
                      false,
                      true),
                ],
              ),
            ),
            _agreement(),
            _btnWidget(),

            // Container(
            //   height: 45,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: !_checkBoxValue
            //           ? [HsgColors.btnDisabled, HsgColors.btnDisabled]
            //           : [
            //               Color(0xFF1775BA),
            //               Color(0xFF3A9ED1),
            //             ],
            //     ),
            //     borderRadius: BorderRadius.circular(2.5),
            //   ),
            //   margin: EdgeInsets.fromLTRB(40, 20, 40, 15),
            //   child: ButtonTheme(
            //     height: 45,
            //     child: FlatButton(
            //       onPressed: _checkBoxValue
            //           ? () {
            //               _loadDepositData();
            //             }
            //           : null,
            //       textColor: Colors.white,
            //       disabledColor: HsgColors.btnDisabled,
            //       child: (Text(S.current.repayment_type2, style: FIRST_DEGREE_TEXT_STYLE,)),
            //     ),
            //   ),
            // ),
            Container(
              color: HsgColors.commonBackground,
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: (Text(
                S.current.deposit_declare,
                style: TextStyle(color: HsgColors.toDoDetailText, fontSize: 12),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnWidget() {
    return Container(
      child: Row(
        children: [
          // 提前结清按钮
          Expanded(
            flex: 1,
            child: CustomButton(
              isLoading: _btnIsLoadingR,
              isEnable: _btnIsEnable,
              isOutline: true,
              margin: EdgeInsets.all(15),
              text: Text(
                S.current.repayment_type2,
                style: TextStyle(
                    color: _btnIsEnable ? Color(0xff3394D4) : Colors.grey,
                    fontSize: 14.0),
              ),
              clickCallback: () {
                if (this.mounted) {
                  setState(() {
                    _btnIsLoadingR = true;
                    _btnIsEnable = false;
                  });
                }
                _loadDepositData();
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 5)),
          // 返回按钮
          Expanded(
            flex: 1,
            child: CustomButton(
              isLoading: _btnIsLoadingUN,
              isEnable: _btnIsEnable,
              margin: EdgeInsets.all(15),
              text: Text(
                S.of(context).hs_go_back,
                style: TextStyle(
                    color: _btnIsEnable ? Colors.white : Colors.grey,
                    fontSize: 14.0),
              ),
              clickCallback: () {
                if (this.mounted) {
                  setState(() {
                    _btnIsLoadingUN = true;
                    _btnIsEnable = false;
                  });
                }
                Navigator.of(context)..pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  _showTimeDepositEarlyTip() {
    String conMatAmts = FormatUtil.formatSringToMoney('$conMatAmt');
    String matAmts = FormatUtil.formatSringToMoney('$matAmt');
    _verificationDialog(
        S.current.confirm_to_early_settlement,
        S.current.contract_settlement_amt +
            ' $ccy $conMatAmts\n' +
            S.current.early_settlement_amt +
            ' $ccy $matAmts',
        _select);
  }

//提前结清试算
  _loadDepositData() {
    HSProgressHUD.show();
    Future.wait({
      // DepositDataRepository()
      ApiClientTimeDeposit()
          .getDepositTrial(GetDepositTrialReq(bal, conNos, bal))
    }).then((value) {
      HSProgressHUD.dismiss();
      value.forEach((element) {
        if (this.mounted) {
          setState(() {
            conMatAmt = element.conMatAmt;
            matAmt = element.matAmt;
            eryInt = element.eryInt;
            eryRate = element.eryRate;
            mainAc = element.mainAc;
            _trialResp = element;
            _btnIsLoadingR = false;
            _btnIsEnable = true;
          });
        }

        _showTimeDepositEarlyTip();
      });
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

// 提前结清接口调整
  _contractEarly(BuildContext context) {
    if (this.mounted) {
      setState(() {});
    }

    HSProgressHUD.show();
    // DepositDataRepository()
    ApiClientTimeDeposit()
        .getDepositEarlyContract(
      GetDepositEarlyContractReq(
        _trialResp.bal ?? '',
        _trialResp.ccy ?? '',
        double.parse(_trialResp.clsInt ?? '0'),
        double.parse(_trialResp.clsRate ?? '0'),
        conNos,
        _trialResp.mtDate ?? '',
        double.parse(eryInt),
        double.parse(eryRate),
        double.parse(_trialResp.hdlFee ?? '0'),
        _trialResp.mainAc ?? '',
        double.parse(_trialResp.matAmt ?? '0'),
        double.parse(_trialResp.matBal ?? '0'),
        double.parse(_trialResp.pnltFee ?? '0'),
        double.parse(_trialResp.settBal ?? '0'),
        widget.deposit.settDdAc ?? '',
        widget.deposit.conSts ?? '',
        widget.deposit.tenor ?? '',
        widget.deposit.settDdAc ?? '', //_paymentAc,
        'all',
        _trialResp.valDate ?? '',
      ),
    )
        .then((value) {
      HSProgressHUD.dismiss();
      _showContractSucceedPage(context);
    }).catchError((e) {
      if (this.mounted) {
        setState(() {});
      }
      HSProgressHUD.showToast(e);
    });
    // _showContractSucceedPage(context);
  }

  //获取详情
  _getDetail() {
    conNos = widget.deposit.conNo;
    ccy = widget.deposit.ccy;
    bal = widget.deposit.bal;
    _paymentAc = widget.deposit.openDrAc;
    _changedSettAcTitle = widget.deposit.settDdAc;
    valDate = widget.deposit.valDate;
    mtDate = widget.deposit.mtDate;
    productName = widget.deposit.engName;
    auctCale = widget.deposit.auctCale;
    _changedInstCode = widget.deposit.instCode;
    _changedSettAc = widget.deposit.settDdAc;

    switch (widget.deposit.accuPeriod) {
      case '1':
        _termUnit = S.current.tdContract_day;
        break;
      case '2':
        _termUnit = S.current.months;
        break;
      case '5':
        _termUnit = S.current.year;
        break;
    }
    switch (widget.deposit.instCode) {
      case '1':
        instruction = S.current.tdInfo_transfer_to_current_account;
        break;
      case '3':
        instruction = S.current.tdInfo_continuation_of_principal_and_interest;
        break;
      case '6':
        instruction = S.current.tdInfo_principal_renewal;
    }
  }

  void _select(String leftText) {
    _modify = '';
    if (leftText == S.current.tdEarlyRed_modify_settlement_account) {
      //修改结算账户
      _updateTimeDepositConInfo(ccy, conNos, _changedInstCode, '',
          _changedSettAc.replaceAll(new RegExp(r"\s+\b|\b\s"), ""), '');
    } else if (leftText == S.current.tdInfo_interest_settlement_account) {
      //修改结息账户
      _updateTimeDepositConInfo(ccy, conNos, _changedInstCode, '', '',
          _changedSettAc.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
    } else if (leftText == S.current.tdEarlyRed_modify_expiration_instruction) {
      //修改到期指示
      _changedInstCode == '3'
          ? _updateTimeDepositConInfo(ccy, conNos, _changedInstCode, ccy, '',
              _changedSettAc.replaceAll(new RegExp(r"\s+\b|\b\s"), ""))
          : _updateTimeDepositConInfo(ccy, conNos, _changedInstCode, '',
              _changedSettAc.replaceAll(new RegExp(r"\s+\b|\b\s"), ""), '');
      _modify = S.current.tdEarlyRed_modify_expiration_instruction;
    } else {
      //提前结清
      // CheckPayPassword(context, () {
      _contractEarly(context);
      // });
    }
  }

//获取卡列表
  Future<void> _loadData() async {
    // CardDataRepository()
    ApiClientAccount().getCardList(GetCardListReq()).then(
      (data) {
        if (data.cardList != null) {
          if (this.mounted) {
            setState(() {
              cards.clear();
              data.cardList.forEach((element) {
                bool isContainer = cards.contains(element.cardNo);
                if (!isContainer) {
                  cards.add(element.cardNo);
                }
              });
              cards = cards.toSet().toList();
            });
          }
        }
      },
    ).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  ///根据产品代码获取产品支持的待办指示
  Future _getTdProdInstCode() async {
    ApiClientTimeDeposit()
        .getTdProdInstCode(
            GetTdProductInstCodeReq(widget.deposit.prdCode ?? ''))
        .then((data) {
      HSProgressHUD.dismiss();
      List<String> instructionDataList = [];
      List<String> instructionList = [];
      for (var i = 0; i < instCodes.length; i++) {
        if (data.insCodes.contains(instCodes[i])) {
          instructionDataList.add(instCodes[i]);
          instructionList.add(instructions[i]);
        }
      }
      setState(() {
        instCodes = instructionDataList;
        instructions = instructionList;
      });
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

//获取到期指示列表
  Future _getInsCode() async {
    // PublicParametersRepository()
    HSProgressHUD.show();
    ApiClientOpenAccount().getIdType(GetIdTypeReq("EXP_IN")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        instructions.clear();
        instCodes.clear();
        data.publicCodeGetRedisRspDtoList.forEach((element) {
          if (this.mounted) {
            // setState(() {
            instCodes.add(element.code);
            if (language == 'zh_CN') {
              instructions.add(element.cname);
            } else if (language == 'zh_HK') {
              instructions.add(element.chName);
            } else {
              instructions.add(element.name);
            }
            // });
          }
        });
        _getTdProdInstCode();
      } else {
        HSProgressHUD.dismiss();
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

//修改到期指示和结算账户
  Future _updateTimeDepositConInfo(
    String ccy,
    String conNo,
    String instCode,
    String intAcCcy,
    String settDdAc,
    String settIntAc,
  ) async {
    // TimeDepositDataRepository()
    HSProgressHUD.show();
    ApiClientTimeDeposit()
        .updateTimeDepositConInfo(UpdateTdConInfoReq(
            ccy, conNo, instCode, intAcCcy, settDdAc, settIntAc))
        .then((data) {
      HSProgressHUD.dismiss();
      setState(() {
        if (_modify == S.current.tdEarlyRed_modify_expiration_instruction) {
          instruction = _changedInstruction;
          _instCode = _changedInstCode;
        } else {
          _changedSettAcTitle = _changedSettAc;
        }
      });
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  //结算成功-跳转页面
  _showContractSucceedPage(BuildContext context) async {
    if (this.mounted) {
      setState(() {});
    }

    Navigator.pushReplacementNamed(context, pageDepositRecordSucceed,
        arguments: 'timeDepositRecord');
  }
}
