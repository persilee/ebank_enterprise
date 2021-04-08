/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 我的存单详情页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_account_overview_info.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_early_contract.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_trial.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';

import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PageDepositInfo extends StatefulWidget {
  final DepositRecord deposit;
  // final List<TotalAssetsCardListBal> cardList;
  PageDepositInfo({Key key, this.deposit}) : super(key: key);

  @override
  _PageDepositInfo createState() => _PageDepositInfo(deposit);
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

  DepositRecord deposit;

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

  var instCode = '';

  var mainAc = '';

  var transferAc = '';

  _PageDepositInfo(this.deposit);

  List<RemoteBankCard> cards = [];

  int _settAcPosition = 0;

  String _changedSettAcTitle = '';

  String _paymentAc = '';

  bool _checkBoxValue = false; //复选框默认值

  List<String> instructions = [];

  String language = Intl.getCurrentLocale();

  String productName;

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
      height: 45,
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
    List<String> bankCards = [];
    List<String> accounts = [];
    List<String> cardNo = [];
    for (RemoteBankCard card in cards) {
      bankCards.add(card.cardNo);
    }
    for (var i = 0; i < bankCards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(bankCards[i]));
      cardNo.add(bankCards[i]);
      if (_changedSettAcTitle == bankCards[i]) {
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
      _changedSettAcTitle = cardNo[result];
      _verificationDialog(
          S.current.tdEarlyRed_modify_settlement_account,
          S.current.tdEarlyRed_modify_settlement_account_determine +
              '\n' +
              FormatUtil.formatSpace4(_changedSettAcTitle),
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
                  width: (MediaQuery.of(context).size.width - 42) / 7 * 2,
                  child: Text(
                    leftText,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 42) / 7 * 4,
                child: Text(
                  rightText,
                  style: TextStyle(fontWeight: FontWeight.normal),
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
            _loadDepositData();
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
      margin: EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width - 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _roundCheckBox(),
          Container(
            width: MediaQuery.of(context).size.width - 52,
            padding: EdgeInsets.zero,
            child: Text(
              S.current.select_content,
              style: TextStyle(color: HsgColors.toDoDetailText, fontSize: 12),
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
          instCode = instructions[result];
          // instCode = instructionDatas[result];
          _verificationDialog(
              S.current.tdEarlyRed_modify_expiration_instruction,
              S.current.tdEarlyRed_modify_expiration_instruction_determine +
                  '\n' +
                  instCode,
              _select);
        } else {
          // return {instCode, instCode};
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deposit = ModalRoute.of(context).settings.arguments;
    String conMatAmts = FormatUtil.formatSringToMoney('$conMatAmt');
    String matAmts = FormatUtil.formatSringToMoney('$matAmt');

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
                  Expanded(child: Text(S.current.payment_account)),
                  Container(
                    child: Text(
                      FormatUtil.formatSpace4(_paymentAc),
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
                            child: Text(productName,
                                style: TextStyle(fontWeight: FontWeight.bold))),
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
                  _unit(S.current.deposit_term, auctCale + S.current.month,
                      true, false),
                  //生效日期
                  _unit(S.current.effective_date, valDate, true, false),
                  //到期日期
                  _unit(S.current.due_date, mtDate, true, false),
                  //结算账户
                  _selectSettACBtn(S.current.settlement_account,
                      FormatUtil.formatSpace4(_changedSettAcTitle), true, true),
                  //到期指示
                  _selectInstCodeBtn(
                      S.current.due_date_indicate, instCode, false, true),
                ],
              ),
            ),
            _agreement(),

            Container(
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: !_checkBoxValue
                      ? [HsgColors.btnDisabled, HsgColors.btnDisabled]
                      : [
                          Color(0xFF1775BA),
                          Color(0xFF3A9ED1),
                        ],
                ),
                borderRadius: BorderRadius.circular(2.5),
              ),
              margin: EdgeInsets.fromLTRB(40, 20, 40, 15),
              child: ButtonTheme(
                height: 45,
                child: FlatButton(
                  onPressed: _checkBoxValue
                      ? () {
                          _verificationDialog(
                              S.current.confirm_to_early_settlement,
                              S.current.contract_settlement_amt +
                                  ' $ccy $conMatAmts\n' +
                                  S.current.early_settlement_amt +
                                  ' $ccy $matAmts',
                              _select);
                        }
                      : null,
                  textColor: Colors.white,
                  disabledColor: HsgColors.btnDisabled,
                  child: (Text(S.current.repayment_type2)),
                ),
              ),
            ),
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

//提前结清试算
  _loadDepositData() {
    Future.wait({
      DepositDataRepository().getDepositTrial(
          GetDepositTrialReq(bal, conNos, bal), 'GetDepositTrialReq')
    }).then((value) {
      value.forEach((element) {
        if (this.mounted) {
          setState(() {
            conMatAmt = element.conMatAmt;
            matAmt = element.matAmt;
            eryInt = element.eryInt;
            eryRate = element.eryRate;
            mainAc = element.mainAc;
          });
        }
      });
    });
  }

// 提前结清
  _contractEarly(BuildContext context) {
    if (this.mounted) {
      setState(() {});
    }

    HSProgressHUD.show();
    DepositDataRepository()
        .getDepositEarlyContract(
            GetDepositEarlyContractReq(
              conNos,
              double.parse(eryInt),
              double.parse(eryRate),
              0,
              mainAc,
              0,
              0,
              0,
              _paymentAc,
              // _changedSettAcTitle.replaceAll(new RegExp(r"\s+\b|\b\s"), "")
              '0101208000001528',
            ),
            'getDepositEarlyContract')
        .then((value) {
      HSProgressHUD.dismiss();
      _showContractSucceedPage(context);
    }).catchError((e) {
      if (this.mounted) {
        setState(() {});
      }
      HSProgressHUD.dismiss();
      HSProgressHUD.showError(status: '${e.toString()}');
    });
    // HSProgressHUD.dismiss();
    // _showContractSucceedPage(context);
  }

  //获取详情
  _getDetail() {
    conNos = deposit.conNo;
    ccy = deposit.ccy;
    bal = deposit.bal;
    _paymentAc = deposit.openDrAc;
    _changedSettAcTitle = deposit.settDdAc;
    valDate = deposit.valDate;
    mtDate = deposit.mtDate;
    productName = deposit.engName;

    switch (deposit.accuPeriod) {
      case '2':
        auctCale = deposit.auctCale;
        break;
      case '3':
        auctCale = (int.parse(deposit.auctCale) * 3).toString();
        break;
      case '4':
        auctCale = (int.parse(deposit.auctCale) * 6).toString();
        break;
      default:
        {
          auctCale = (int.parse(deposit.auctCale) * 12).toString();
        }
    }
    switch (deposit.instCode) {
      case '0':
        instCode = S.current.instruction_at_maturity_0;
        break;
      case '1':
        instCode = S.current.instruction_at_maturity_1;
        break;
      case '2':
        instCode = S.current.instruction_at_maturity_2;
        break;
      default:
        {
          instCode = S.current.instruction_at_maturity_5;
        }
    }
    // for (int i = 0; i < cardList.length; i++) {
    //   if (cardList[i].ccy == ccy) {
    //     transferAc = cardList[i].cardNo;
    //   }
    // }
  }

  void _select(String leftText) {
    if (leftText == S.current.tdEarlyRed_modify_settlement_account) {
      _loadData();
    } else if (leftText == S.current.tdEarlyRed_modify_expiration_instruction) {
      _getInsCode();
    } else {
      _contractEarly(context);
    }
  }

  Future<void> _loadData() async {
    CardDataRepository().getCardList('getCardList').then(
      (data) {
        if (data.cardList != null) {
          if (this.mounted) {
            setState(() {
              cards.clear();
              cards.addAll(data.cardList);
            });
          }
        }
      },
    ).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

//获取到期指示列表
  Future _getInsCode() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("EXP_IN"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        data.publicCodeGetRedisRspDtoList.forEach((element) {
          if (this.mounted) {
            setState(() {
              if (language == 'zh_CN') {
                instructions.add(element.cname);
              } else {
                instructions.add(element.name);
              }
            });
          }
        });
      }
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
