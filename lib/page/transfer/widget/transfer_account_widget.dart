import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferAccount extends StatelessWidget {
  //支付币种
  final String payCcy;
  //转出币种
  final String transferCcy;
  //限额
  final String limit;
  //转出账户
  final String account;
  //余额
  final String balance;
  //转账金额控制器
  final TextEditingController transferMoneyController;
  final VoidCallback callback;
  //币种弹窗
  final Function payCcyDialog;
  final Function transferCcyDialog;
  //账户弹窗
  final Function accountDialog;
  TransferAccount({
    Key key,
    this.payCcy,
    this.transferCcy,
    this.limit,
    this.account,
    this.balance,
    this.transferMoneyController,
    this.callback,
    this.payCcyDialog,
    this.transferCcyDialog,
    this.accountDialog,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: [
            _limit(limit),
            _transferAmount(context),
            _fullLine(),
            _transferAccount(context),
            _fullLine(),
            _transferCcy(context)
          ],
        ),
      ),
    );
  }

  //限额
  Widget _limit(String limit) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.transfer_amount,
            style: TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
          ),
          Text(
            S.current.tran_limit_amt_with_value +
                '：' +
                payCcy +
                ' ' +
                FormatUtil.formatSringToMoney(limit),
            style: TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
          ),
        ],
      ),
    );
  }

  //转账金额
  Widget _transferAmount(context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            child: FlatButton(
              onPressed: () {
                payCcyDialog();
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 3),
                    child: Text(
                      payCcy,
                      style: TextStyle(
                        color: HsgColors.firstDegreeText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: HsgColors.firstDegreeText,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            child: TextField(
              //是否自动更正
              autocorrect: false,
              //是否自动获得焦点
              autofocus: false,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                color: HsgColors.firstDegreeText,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              onChanged: (text) {
                callback();
                // text.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1');
                // moneyChanges(money);
              },
              controller: transferMoneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.current.int_input_tran_amount,
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //转出账户
  _transferAccount(context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.current.transfer_from_account),
          InkWell(
            onTap: () {
              accountDialog();
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        account,
                        style:
                            TextStyle(color: Color(0xff262626), fontSize: 14),
                      ),
                      Text(
                        S.current.balance_with_value +
                            '：' +
                            payCcy +
                            ' ' +
                            FormatUtil.formatSringToMoney(balance),
                        style:
                            TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Image(
                  color: HsgColors.firstDegreeText,
                  image: AssetImage(
                      'images/home/listIcon/home_list_more_arrow.png'),
                  width: 7,
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //转出币种
  _transferCcy(context) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      color: Colors.white,
      child: SelectInkWell(
        title: S.current.transfer_from_ccy,
        item: transferCcy,
        onTap: () {
          transferCcyDialog();
        },
      ),
    );
  }

  //实线
  _fullLine() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Divider(
        color: HsgColors.divider,
        height: 0.5,
      ),
    );
  }
}
