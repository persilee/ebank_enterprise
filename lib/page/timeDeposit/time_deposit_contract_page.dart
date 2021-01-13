/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期开立购买页面
/// Author: wangluyao
/// Date: 2020-12-14
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract_trial.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/time_deposit_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../page_route.dart';

class TimeDepositContract extends StatefulWidget {
  final TdepProducHeadDTO productList;
  final List<TdepProducDTOList> producDTOList;
  TimeDepositContract({Key key, this.productList, this.producDTOList})
      : super(key: key);

  @override
  _TimeDepositContractState createState() =>
      _TimeDepositContractState(productList, producDTOList);
}

class _TimeDepositContractState extends State<TimeDepositContract> {
  String _changedAccountTitle = S.current.hint_please_select;
  String _changedTermBtnTiTle = S.current.hint_please_select;
  String _changedInstructionTitle = S.current.hint_please_select;
  String _changedDepositTerm = '';
  String _changedRateTitle = '';
  String accuPeriod = '0';
  String auctCale = '0';
  String depositType = '0';
  String rate = '0';
  String matAmt = '0.00';
  List<RemoteBankCard> cards = [];
  RemoteBankCard card;

  double bal = 0.00;
  String instCode = '';

  TdepProducHeadDTO productList;
  List<TdepProducDTOList> producDTOList;
  _TimeDepositContractState(this.productList, this.producDTOList);

  TimeDepositContractTrialReq contractTrialReq;

  void initState() {
    super.initState();
    //网络请求
    _loadData();
  }

  Widget _background() {
    return Container(
      color: HsgColors.backgroundColor,
      height: 15,
    );
  }

  // 产品描述
  Widget _remark(List<TdepProducDTOList> producDTOList) {
    return Container(
      color: HsgColors.backgroundColor,
      height: 40,
      width: 500.0,
      child: Container(
        padding: EdgeInsets.only(top: 15.0, left: 15.0),
        height: 10,
        child: Text(
          S.current.no_advance_withdrawal,
          style: TextStyle(
            color: HsgColors.describeText,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  // 选择存款期限按钮
  Widget _termChangeBtn(
      BuildContext context, List<TdepProducDTOList> producDTOList) {
    return Column(
      children: [
        _remark(producDTOList),
        Container(
            child: FlatButton(
          onPressed: () {
            _selectTerm(context, producDTOList);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 190,
                child: Text(
                  S.current.deposit_time_limit,
                  style: TextStyle(
                      color: HsgColors.aboutusTextCon, fontSize: 14.0),
                ),
              ),
              Container(
                width: 145,
                alignment: Alignment.centerRight,
                child: TextField(
                  onTap: () {
                    _selectTerm(context, producDTOList);
                  },
                  textAlign: TextAlign.right,
                  enabled: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _changedTermBtnTiTle,
                      hintStyle:
                          _changedTermBtnTiTle == S.current.hint_please_select
                              ? TextStyle(
                                  color: HsgColors.hintText,
                                  fontSize: 14.0,
                                )
                              : TextStyle(
                                  color: HsgColors.firstDegreeText,
                                  fontSize: 14.0,
                                )),
                ),
              ),
              Container(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )),
        _background()
      ],
    );
  }

//存款期限弹窗
  _selectTerm(
      BuildContext context, List<TdepProducDTOList> producDTOList) async {
    List<String> depositTerms = [];
    List<String> terms = [];
    List<String> rates = [];
    List<String> accuPeriods = [];
    List<String> auctCales = [];
    for (var i = 0; i < producDTOList.length; i++) {
      switch (producDTOList[i].accuPeriod) {
        case '2':
          terms.add(producDTOList[i].auctCale + S.current.months);
          depositTerms.add(producDTOList[i].auctCale);
          break;
        case '3':
          terms.add((int.parse(producDTOList[i].auctCale) * 3).toString() +
              S.current.months);
          depositTerms
              .add((int.parse(producDTOList[i].auctCale) * 3).toString());
          break;
        case '4':
          terms.add((int.parse(producDTOList[i].auctCale) * 6).toString() +
              S.current.months);
          depositTerms
              .add((int.parse(producDTOList[i].auctCale) * 6).toString());
          break;
        default:
          {
            terms.add((int.parse(producDTOList[i].auctCale) * 12).toString() +
                S.current.months);
            depositTerms
                .add((int.parse(producDTOList[i].auctCale) * 12).toString());
          }
      }
      rates.add(producDTOList[i].annualInterestRate);
      accuPeriods.add(producDTOList[i].accuPeriod);
      auctCales.add(producDTOList[i].auctCale);
      depositType = producDTOList[i].depositType;
    }

    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: '存款期限',
              items: terms,
            ));

    setState(() {
      if (result != null && result != false) {
        _changedTermBtnTiTle = terms[result];
        _changedRateTitle = rates[result];
        _changedDepositTerm = depositTerms[result];
        accuPeriod = accuPeriods[result];
        auctCale = accuPeriods[result];
        rate = FormatUtil.formatNum(double.parse(_changedRateTitle) * 100, 2);
      } else {
        return;
      }
    });
  }

  //产品名称和年利率
  Widget _titleSection(
      TdepProducHeadDTO tdepProduct, List<TdepProducDTOList> producDTOList) {
    String name;
    String language = Intl.getCurrentLocale();
    if (language == 'zh_CN') {
      name = productList.lclName;
    } else {
      name = productList.engName;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 190.0,
          margin: EdgeInsets.only(top: 20, bottom: 20.0),
          height: 60,
          child: Column(children: [
            Text(
              S.current.product_name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
            ),
            SizedBox(height: 10.0),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20.0),
          width: 10.0,
          height: 50,
          child: Column(
            children: [
              SizedBox(
                width: 1,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: HsgColors.divider),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 190.0,
          margin: EdgeInsets.only(top: 20, bottom: 20.0),
          height: 60,
          child: Column(children: [
            Text(
              S.current.year_interest_rate,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
            ),
            SizedBox(height: 10.0),
            Text(
              rate + '%',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ],
    );
  }

  // 本金输入框
  Widget _inputPrincipal(RemoteBankCard card) {
    switch (producDTOList[0].accuPeriod) {
      case '2':
        _changedTermBtnTiTle = (producDTOList[0].auctCale + S.current.months);
        break;
      default:
        {
          _changedTermBtnTiTle =
              ((int.parse(producDTOList[0].auctCale) * 12).toString() +
                  S.current.months);
        }
    }
    rate = FormatUtil.formatNum(
        double.parse(producDTOList[0].annualInterestRate) * 100, 2);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              Container(
                child: Text(
                  productList.ccy,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextField(
                  autocorrect: false,
                  autofocus: false,
                  style: TextStyle(
                      color: HsgColors.firstDegreeText, fontSize: 18.0),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  ],
                  onChanged: (value) {
                    double.parse(
                        value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1'));
                    bal = double.parse(value);
                    print("输入的金额是:$value");
                    if (double.parse(value) >=
                        double.parse(productList.minAmt)) {
                      _loadDepositData(
                          // accuPeriod,
                          // auctCale,
                          // double.parse(value),
                          // productList.bppdCode,
                          // productList.ccy,
                          //  card.custId,
                          // depositType,
                          // '', // tenor
                          '2',
                          '1',
                          double.parse(value),
                          'TD000001',
                          'HKD',
                          '8000000004',
                          'A',
                          '');
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText:
                        S.current.deposit_min_with_value + productList.minAmt,
                    hintStyle: TextStyle(
                      color: HsgColors.hintText,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
          child: Row(
            children: [
              Container(
                child: Text(
                  S.current.contract_principal_and_interest,
                  style: TextStyle(
                    color: HsgColors.secondDegreeText,
                    fontSize: 13.0,
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Container(
                child: Text(
                  productList.ccy + ":" + matAmt,
                  style: TextStyle(
                    color: HsgColors.secondDegreeText,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        _background()
      ],
    );
  }

  //付款账户和到期指示
  Widget _accountsAndInstructions() {
    return Column(
      children: [
        //付款账户按钮
        Container(
            child: FlatButton(
          onPressed: () {
            _selectAccount(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 190,
                child: Text(
                  S.current.payment_account,
                  style: TextStyle(
                      color: HsgColors.aboutusTextCon, fontSize: 14.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 145,
                    alignment: Alignment.centerRight,
                    child: TextField(
                      textAlign: TextAlign.right,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: _changedAccountTitle,
                          hintStyle: _changedAccountTitle ==
                                  S.current.hint_please_select
                              ? TextStyle(
                                  color: HsgColors.hintText,
                                  fontSize: 14.0,
                                )
                              : TextStyle(
                                  color: HsgColors.firstDegreeText,
                                  fontSize: 14.0,
                                )),
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        //到期指示按钮
        Container(
            child: FlatButton(
          onPressed: () {
            _selectInstruction(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 190,
                child: Text(
                  S.current.due_date_indicate,
                  style: TextStyle(
                      color: HsgColors.aboutusTextCon, fontSize: 14.0),
                ),
              ),
              Container(
                width: 145,
                alignment: Alignment.centerRight,
                child: TextField(
                  textAlign: TextAlign.right,
                  enabled: false,
                  maxLines: 2,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15.0),
                      hintText: _changedInstructionTitle,
                      hintStyle: _changedInstructionTitle ==
                              S.current.hint_please_select
                          ? TextStyle(
                              color: HsgColors.hintText,
                              fontSize: 14.0,
                            )
                          : TextStyle(
                              color: HsgColors.firstDegreeText,
                              fontSize: 14.0,
                            )),
                ),
              ),
              Container(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
      ],
    );
  }

//付款账户弹窗
  _selectAccount(BuildContext context) async {
    List<String> bankCards = [];
    List<String> accounts = [];
    for (RemoteBankCard card in cards) {
      bankCards.add(card.cardNo);
    }
    for (var i = 0; i < bankCards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(bankCards[i]));
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) =>
            BottomMenu(title: S.current.payment_account, items: accounts));
    if (result != null && result != false) {
      _changedAccountTitle = accounts[result];
    } else {
      return;
    }
    setState(() {});
  }

//到期指示弹窗
  _selectInstruction(BuildContext context) async {
    List<String> instructions = [
      S.current.instruction_at_maturity_0,
      S.current.instruction_at_maturity_1,
      S.current.instruction_at_maturity_2,
      S.current.instruction_at_maturity_5,
    ];
    List<String> instructionDatas = [
      '0',
      '1',
      '2',
      '5',
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.due_date_indicate,
              items: instructions,
            ));
    setState(() {
      if (result != null && result != false) {
        _changedInstructionTitle = instructions[result];
        instCode = instructionDatas[result];
      } else {
        return {_changedInstructionTitle, instCode};
      }
    });
  }

  //确认按钮
  Widget _submitButton() {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: ButtonTheme(
          minWidth: 5,
          height: 45,
          child: FlatButton(
            onPressed: (matAmt == '0.00' ||
                    _changedTermBtnTiTle == S.current.hint_please_select ||
                    _changedAccountTitle == S.current.hint_please_select ||
                    _changedInstructionTitle == S.current.hint_please_select)
                ? null
                : () {
                    //_openBottomSheet();
                    Navigator.popAndPushNamed(context, pageDepositRecordSucceed,
                        arguments: 'timeDepositProduct');
                  },
            color: HsgColors.accent,
            disabledColor: HsgColors.btnDisabled,
            child: Text(
              S.current.deposit_now,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

//输入密码弹窗
  void _openBottomSheet() async {
    final isPassword = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgPasswordDialog(
            title: S.current.input_password,
          );
        });
    if (isPassword != null && isPassword == true) {
      _loadContractData(
          accuPeriod,
          double.parse(rate),
          auctCale,
          bal,
          productList.bppdCode,
          productList.ccy,
          card.ciName,
          depositType,
          instCode,
          _changedDepositTerm,
          _changedAccountTitle,
          bal,
          productList.prodType,
          '',
          _changedAccountTitle
          // "5",
          // 1.3,
          // "1",
          // 86,
          // "TD000009",
          // "HKD",
          // "50000066",
          // "A",
          // "0",
          // "112",
          // "500000666003",
          // 86,
          // "MMDP",
          // "ok",
          // "500000666003"
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('定期开立'),
        ),
        body: (ListView(
          children: [
            _background(),
            _titleSection(
              productList,
              producDTOList,
            ),
            _termChangeBtn(context, producDTOList),
            _inputPrincipal(card),
            _accountsAndInstructions(),
            _submitButton(),
          ],
        )));
  }

  Future<void> _loadData() async {
    CardDataRepository().getCardList('getCardList').then(
      (data) {
        if (data.cardList != null) {
          setState(() {
            cards.clear();
            cards.addAll(data.cardList);
          });
        }
      },
    ).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  Future<void> _loadDepositData(
      String accuPeriod,
      String auctCale,
      double bal,
      String bppdCode,
      String ccy,
      String ciNo,
      String depositType,
      String tenor) async {
    TimeDepositDataRepository()
        .getTimeDepositContractTrial(
            TimeDepositContractTrialReq(accuPeriod, auctCale, bal, bppdCode,
                ccy, ciNo, depositType, tenor),
            'getTimeDepositContractTrial')
        .then((value) {
      setState(() {
        matAmt = (value.matAmt).toString();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  Future<void> _loadContractData(
      String accuPeriod,
      double annualInterestRate,
      String auctCale,
      double bal,
      String bppdCode,
      String ccy,
      String custName,
      String depositType,
      String instCode,
      String mergeTerm,
      String payDdAc,
      double payDdAmt,
      String prodType,
      String remarks,
      String settDdAc) async {
    TimeDepositDataRepository()
        .getTimeDepositContract(
            TimeDepositContractReq(
                accuPeriod,
                annualInterestRate,
                auctCale,
                bal,
                bppdCode,
                ccy,
                custName,
                depositType,
                instCode,
                mergeTerm,
                payDdAc,
                payDdAmt,
                prodType,
                remarks,
                settDdAc),
            'getTimeDepositContract')
        .then((value) {
      setState(() {
        Navigator.popAndPushNamed(context, pageDepositRecordSucceed,
            arguments: 'timeDepositContract');
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
