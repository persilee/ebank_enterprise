/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-16

import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/data/source/model/get_loan_money_caculate.dart';
import 'package:ebank_mobile/data/source/model/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan_detail_modelList.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client_loan.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepayInputPage extends StatefulWidget {
  @override
  _RepayInputPageState createState() => _RepayInputPageState();
}

class _RepayInputPageState extends State<RepayInputPage> {
  LnAcMastAppDOList loanDetail; //合约帐号信息
  PostAdvanceRepaymentDTOList list; //利息计算信息

  Map message = new Map();
  var currency = ''; //币种
  double max = 0; //还款最大值(贷款余额)
  var loanInterest = ''; //贷款利率
  var debitAccount = ''; //扣款账号

  var _repayInterest = ''; //还款利息
  var _fine = ''; //罚金
  var _totalRepay = ''; //还款总额
  bool _isBtnDisabled = false;

  var acNo = '';
  var instalNo = '';
  var isInterestCharge = '';
  var repayPrincipal = ''; //还款金额
  var repaymentMethod = '';
  var rescheduleType = 'I';

  //创建文本控制器实例
  TextEditingController _inputController = new TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        //得到焦点
        String text = _inputController.text;
        int length = text.length;
        if (length <= 0) {
          setState(() {
            _isBtnDisabled = false;
            _repayInterest = '0.00';
            _fine = '0.00';
            _totalRepay = '0.00';
          });
        } else {
          RegExp postalcode = new RegExp(r'^(0\d)');
          if (postalcode.hasMatch(text)) {
            _inputController.text = text.substring(1);
            _inputController.selection =
                TextSelection.collapsed(offset: _inputController.text.length);
          }
          if (double.parse(_inputController.text) > max) {
            _inputController.text = formatDouble(max, 2);
            _inputController.selection =
                TextSelection.collapsed(offset: _inputController.text.length);
          }
          repayPrincipal = _inputController.text;
          if (double.parse(repayPrincipal) == max) {
            repaymentMethod = "SETTLEMENT";
          } else {
            repaymentMethod = "PART_PREPAYMENT";
          }
        }
      } else {
        //失去焦点
        String text = _inputController.text;
        int length = text.length;
        if (length > 0) {
          _loadData();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //释放
    focusNode.dispose();
  }

  //进行贷款试算
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);
    SVProgressHUD.show();
    // LoanDataRepository()
    ApiClientLoan()
        .getLoanCaculate(
      GetLoanCaculateReq(
          loanDetail.contactNo, //贷款放款编号
          loanDetail.br, //机构号
          loanDetail.ccy, //币种
          custID, //客户号
          loanDetail.osAmt, //贷款余额
          loanDetail.loanAmt, //贷款本金
          _inputController.text, //还本金额
          loanDetail.prodTyp, //产品类型
          loanDetail.repaymentMethod, //还息方式
          loanDetail.disbDate //生效日期
          ),
    )
        .then((data) {
      SVProgressHUD.dismiss();
      if (data.postAdvanceRepaymentDTOList != null) {
        setState(() {
          //请求回来进行变更
          PostAdvanceRepaymentDTOList list =
              data.postAdvanceRepaymentDTOList[0];
          this.list = list; //保存传回去
          _repayInterest = list.rcvInt; //还款利息
          //  rcvPen 本金罚息 + rcvCom 利息罚息
          double totalRcv =
              double.parse(list.rcvPen) + double.parse(list.rcvCom);
          _fine = totalRcv.toString();

          double totalAmt =
              double.parse(list.payPrin) + double.parse(list.rcvInt) + totalRcv;
          _totalRepay = totalAmt.toString(); //还款总额 = 还款本金 + 利息 + 罚金

          _isBtnDisabled = true;
        });
      }
    }).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    LnAcMastAppDOList loanDetail = ModalRoute.of(context).settings.arguments;
    this.loanDetail = loanDetail;

    var container1 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //贷款账号
          _contentColumn(S.of(context).loan_account, loanDetail.acNo),
          //币种
          _contentColumn(S.of(context).currency, loanDetail.ccy), //ccy
          //贷款本金
          _contentColumn(S.of(context).loan_principal,
              FormatUtil.formatSringToMoney(loanDetail.loanAmt)), //loanAmt
          //贷款余额
          _contentColumn(S.of(context).loan_balance2,
              FormatUtil.formatSringToMoney(loanDetail.osAmt)), //osAmt
          //贷款利率
          _contentColumn(
              S.of(context).loan_interest_rate, loanDetail.intRate + "%"),
        ],
      ),
    );

    var container2 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //扣款账号
          _contentColumn(
              S.of(context).debit_account,
              loanDetail.repaymentAcNo != null
                  ? loanDetail.repaymentAcNo
                  : '8011208000001258'), //repaymentAcNo  8011208000001258 测试的
          //还款本金
          _repayPrincipal(loanDetail),
          //还款利息
          _contentColumn(S.of(context).repayment_interest,
              FormatUtil.formatSringToMoney(_repayInterest)), //需要计算
          //罚金
          _contentColumn(
              S.of(context).fine, FormatUtil.formatSringToMoney(_fine)),
          //还款总额
          _contentColumn(S.of(context).total_repayment,
              FormatUtil.formatSringToMoney(_totalRepay)),
        ],
      ),
    );
    var btnNext = Padding(
      // 点击进入下一步
      padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
      child: RaisedButton(
        child: Text(
          S.of(context).next_step,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
        onPressed: _getBtnClickListener(context),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        color: Color(0xFF4871FF),
        disabledColor: HsgColors.btnDisabled,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).repay_input),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView(
          children: [
            //贷款账号，币种，贷款本金，贷款余额，贷款利率
            container1,
            _getPadding(0, 13, 0, 0),
            //扣款账号，还款本金，还款利息，罚金，还款总额
            container2,
            btnNext, //点击下一步按钮
          ],
        ),
      ),
    );
  }

  //点击进入下一步
  _getBtnClickListener(BuildContext context) {
    if (_isBtnDisabled) {
      return () {
        //修改信息map里的信息
        message['accountModel'] = loanDetail;
        message['calculateModel'] = list;
        message['totalRepay'] = _totalRepay; //还款总额
        Navigator.pushNamed(context, pageRepayConfirm, arguments: message);
      };
    } else {
      return null;
    }
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

  //还款金额输入
  Widget _repayPrincipal(LnAcMastAppDOList loanDetail) {
    var inputRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Container(
            width: 170,
            height: 21,
            child: TextField(
              focusNode: focusNode,
              controller: _inputController,
              textAlign: TextAlign.end,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(
                    RegExp("^[0-9]+[.]?[0-9]{0,2}"))
              ],
              style: TextStyle(fontSize: 14, color: Colors.black87),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: S.of(context).hint_repayment_principal,
                hintStyle: TextStyle(color: HsgColors.hintText, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                //输入框数据修改后
                setState(() {
                  repayPrincipal = _inputController.text;
                });
                // _loadData();
              },
            ),
          ),
        ),
        Container(
          //提前还清
          width: 84,
          height: 21,
          child: OutlineButton(
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            borderSide: BorderSide(color: HsgColors.btnPrimary),
            child: Text(
              S.of(context).early_repayment,
              style: TextStyle(fontSize: 13, color: HsgColors.btnPrimary),
            ),
            onPressed: () {
              _inputController.text = loanDetail.osAmt;
              _inputController.selection =
                  TextSelection.collapsed(offset: _inputController.text.length);
              setState(() {
                // _inputController.text = loanDetail.osAmt;
                repayPrincipal = _inputController.text;
                _loadData(); //达到最大值后不修改了
              });
            },
          ),
        ),
      ],
    );
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    S.of(context).repayment_principal,
                    style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                  ),
                ),
              ],
            ),
            _getPadding(0, 8, 0, 0),
            inputRow,
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Divider(
                height: 0,
                color: HsgColors.textHintColor,
              ),
            ),
          ],
        ));
  }

  Widget _getPadding(double l, double t, double r, double b) {
    return Padding(padding: EdgeInsets.fromLTRB(l, t, r, b));
  }

  //通用组件
  Widget _contentColumn(String leftcont, String rightcont) {
    return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftcont,
                  style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                ),
                Text(
                  rightcont,
                  style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Divider(
                height: 0,
                color: HsgColors.textHintColor,
              ),
            ),
          ],
        ));
  }
}
