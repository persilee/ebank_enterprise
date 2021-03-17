import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferAccount extends StatelessWidget {
  //支付币种
  final String payCcy;
  final List<String> payCcyList;
  //转出币种
  final String transferCcy;
  final List<String> transferCcyList;
  //限额
  final String limit;
  //转出账户
  final String cardNo;
  final List<String> cardNoList;
  //余额
  final String balance;
  TransferAccount({
    Key key,
    this.payCcy,
    this.payCcyList,
    this.transferCcy,
    this.transferCcyList,
    this.limit,
    this.cardNo,
    this.cardNoList,
    this.balance,
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
          Text('转账金额'),
          Row(
            children: [
              Text('限额：'),
              Text(payCcy),
              Text(limit),
            ],
          )
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
                // _ccyDialog(context, payCcyList, 0,0);
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
              onChanged: (money) {
                money.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1');
                // moneyChanges(money);
              },
              // controller: _transferMoneyController,
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
          Text('转出账户'),
          InkWell(
            onTap: () {
              _selectAccount(context, cardNoList, 0);
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Text(cardNo),
                      Row(
                        children: [
                          Text('余额'),
                          Text(payCcy),
                          Text(balance),
                        ],
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
        title: '转出币种',
        item: transferCcy,
        onTap: () {
          // _ccyDialog(context, transferCcyList, 0,1);
        },
      ),
    );
  }

  //币种弹窗
  _ccyDialog(context, String ccy, List<String> ccyList, int index,
      int ccySelect) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: ccyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: index,
        );
      },
    );
    if (result != null && result != false) {
      // ccySelect == 0 ? ccy = ccyList[result];
    }
  }

  //账号弹窗
  _selectAccount(context, List<String> cardNoList, int index) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.current.account_lsit,
            items: cardNoList,
            lastSelectedPosition: index,
          );
        });
    if (result != null && result != false) {}
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
