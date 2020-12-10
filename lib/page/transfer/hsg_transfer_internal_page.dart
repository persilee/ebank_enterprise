import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';

class TransferInternalPage extends StatefulWidget {
  TransferInternalPage({Key key}) : super(key: key);

  @override
  _TransferInternalPageState createState() => _TransferInternalPageState();
}

class _TransferInternalPageState extends State<TransferInternalPage> {
  SliverToBoxAdapter _gaySliver = SliverToBoxAdapter(
    child: Container(
      height: 15,
    ),
  );

  String limitMoney = FormatUtil.formatSringToMoney('20000000.12946');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transfer_type_0),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _gaySliver,
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          '转账金额',
                          style: TextStyle(
                              color: HsgColors.describeText, fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '限额：HKD$limitMoney', //2,000,000.00',
                          style: TextStyle(
                              color: HsgColors.describeText, fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: 30,
                          child: FlatButton(
                            padding: EdgeInsets.only(left: 0, right: 0),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    'HKD',
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
                            onPressed: () {
                              print('切换币种');
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: TextField(
                              //是否自动更正
                              autocorrect: false,
                              //是否自动获得焦点
                              autofocus: false,
                              style: TextStyle(
                                fontSize: 15,
                                color: HsgColors.firstDegreeText,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '请输入转账金额',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: HsgColors.textHintColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: HsgColors.divider,
                    height: 0.5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            '转出账号',
                            style: TextStyle(
                                color: HsgColors.firstDegreeText, fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print('选择账号');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    '老挝银行 (9999)',
                                    style: TextStyle(
                                      color: HsgColors.firstDegreeText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '余额：LAK100000.00',
                                    style: TextStyle(
                                      color: HsgColors.secondDegreeText,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3, left: 15),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: HsgColors.firstDegreeText,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
