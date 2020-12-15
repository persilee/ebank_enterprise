import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_limit_by_con_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class PageDepositInfo extends StatefulWidget {
  final Rows deposit;
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
  Rows deposit;

  _PageDepositInfo(this.deposit);

//获取网络请求
  @override
  void initState() {
    super.initState();
    _loadDepositData(deposit.conNo);
  }

  @override
  Widget build(BuildContext context) {
    deposit = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.receipt_detail),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 0, 0, 10),
              //付款账户
              child: Row(
                children: [
                  Expanded(child: Text(S.current.payment_account)),
                  Container(
                    child: Text(
                      FormatUtil.formatSpace4('${settDbAc}'),
                    ),
                  )
                ],
              ),
            ),
            //整存整取
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(S.current.deposit_taking,
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
              padding: EdgeInsets.fromLTRB(16, 3, 16, 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //合约号
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.contract_number)),
                        Container(
                          child: Text(conNos),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 6),
                  ),
                  //币种
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.currency)),
                        Container(
                          child: Text(ccy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 6),
                  ),
                  //存入金额
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.deposit_amount)),
                        Container(
                          child: Text(
                            FormatUtil.formatSringToMoney('${bal}'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 6),
                  ),
                  //存期
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.deposit_term)),
                        Container(
                          child: Text('${auctCale}${S.current.month}'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 6),
                  ),
                  //生效日期
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.effective_date)),
                        Container(
                          child: Text(valDate),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 6),
                  ),
                  //到期日期
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.due_date)),
                        Container(
                          child: Text(mtDate),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 6),
                  ),
                  //到期指示
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.due_date_indicate)),
                        Container(
                          child: Text(S.current.instruction_at_maturity_0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
                width: 3,
                height: 90,
                padding: EdgeInsets.fromLTRB(40, 20, 40, 15),
                child: RaisedButton(
                  onPressed: () {},
                  textColor: Colors.white,
                  color: Colors.blue[500],
                  child: (Text(S.current.repayment_type2)),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: (Text(
                S.current.deposit_declare,
                style: TextStyle(color: Color(0xFF8D8D8D), fontSize: 12),
              )),
            )
          ],
        ));
  }

  _loadDepositData(String conNo) {
    Future.wait({
      DepositDataRepository().getDepositLimitByConNo(
          GetDepositLimitByConNo(conNo), 'GetDepositLimitByConNo')
    }).then((value) {
      value.forEach((element) {
        if (element is DepositByLimitConNoResp) {
          setState(() {
            ciNo = element.ciNo;
            conNos = element.conNo;
            settDbAc = element.settDdAc;
            ccy = element.ccy;
            bal = element.bal;
            auctCale = element.auctCale;
            valDate = element.valDate;
            mtDate = element.mtDate;
          });
        }
      });
    });
  }
}
