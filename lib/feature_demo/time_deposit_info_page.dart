import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class PageDepositInfo extends StatefulWidget {
  PageDepositInfo({Key key}) : super(key: key);

  @override
  _PageDepositInfo createState() => _PageDepositInfo();
}

class _PageDepositInfo extends State<PageDepositInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.receipt_detail),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              //这里写获取合约号
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 0, 0, 10),
              //padding: EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  Expanded(child: Text(S.current.payment_account)),
                  Container(
                    child: Text("shuzi"),
                  )
                ],
              ),
            ),
            //整存整取
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(S.current.deposit_taking,
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Container()
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.contract_number)),
                        Container(
                          child: Text('heyuehaoshhuzi0'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.currency)),
                        Container(
                          child: Text('币种'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.deposit_amount)),
                        Container(
                          child: Text('cunrujine'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.deposit_term)),
                        Container(
                          child: Text('存期aa'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.effective_date)),
                        Container(
                          child: Text('生效日期'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.due_date)),
                        Container(
                          child: Text('到期日期'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Divider(),
                    margin: EdgeInsets.only(top: 8),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.due_date_indicate)),
                        Container(
                          child: Text('币种'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: (Text('anniu')),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
