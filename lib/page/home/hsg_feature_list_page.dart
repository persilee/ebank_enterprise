/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-03

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

class FeatureListPage extends StatefulWidget {
  FeatureListPage({Key key}) : super(key: key);

  @override
  _FeatureListPageState createState() => _FeatureListPageState();
}

class _FeatureListPageState extends State<FeatureListPage> {
  List<Map<String, Object>> _features = [
    {
      'title': S.current.my_account,
      'btnList': [
        {
          'btnIcon': 'images/home/listIcon/home_list_overview.png',
          'btnTitle': S.current.account_summary
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_card_bank.png',
          'btnTitle': S.current.my_account
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_payments.png',
          'btnTitle': S.current.transaction_details
        },
      ]
    },
    {
      'title': S.current.transfer_collection,
      'btnList': [
        {
          'btnIcon': 'images/home/listIcon/home_list_transfer.png',
          'btnTitle': S.current.transfer
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_transfer_appointment.png',
          'btnTitle': S.current.transfer_appointment
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_transfer_plan.png',
          'btnTitle': S.current.transfer_plan
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_partner.png',
          'btnTitle': S.current.transfer_model
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_transfer_record.png',
          'btnTitle': S.current.transfer_record
        },
      ]
    },
    {
      'title': S.current.time_deposit,
      'btnList': [
        {
          'btnIcon': 'images/home/listIcon/home_list_time_deposit.png',
          'btnTitle': S.current.deposit_open
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_deposit_rates.png',
          'btnTitle': S.current.deposit_rate
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_deposit_records.png',
          'btnTitle': S.current.deposit_record
        },
      ]
    },
    {
      'title': S.current.loan,
      'btnList': [
        {
          'btnIcon': 'images/home/listIcon/home_list_loan_apply.png',
          'btnTitle': S.current.loan_apply
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_loan_recoeds.png',
          'btnTitle': S.current.loan_record
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_loan_rate.png',
          'btnTitle': S.current.loan_rate
        },
      ]
    },
    {
      'title': S.current.other,
      'btnList': [
        {
          'btnIcon': 'images/home/listIcon/home_list_FOREX.png',
          'btnTitle': S.current.foreign_exchange
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_exchange.png',
          'btnTitle': S.current.exchange_rate
        },
        {
          'btnIcon': 'images/home/listIcon/home_list_statement.png',
          'btnTitle': S.current.electronic_statement
        },
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).all_features),
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: _sliversSection(_features),
        ),
      ),
    );
  }

  List<Widget> _sliversSection(List data) {
    List<Widget> section = [];
    for (var item in data) {
      List btnList = item['btnList'];

      section.add(SliverToBoxAdapter(
        child: Container(
          color: HsgColors.commonBackground,
          height: 10,
        ),
      ));

      section.add(SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 15, top: 20, bottom: 10),
          child: Text(
            item['title'],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: HsgColors.firstDegreeText),
          ),
        ),
      ));
      section.add(SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              color: Colors.white,
              height: 200,
              child: _graphicButton(
                btnList[index]['btnTitle'],
                btnList[index]['btnIcon'],
                35,
              ),
            );
          },
          childCount: btnList.length,
        ),
      ));
    }

    section.add(SliverToBoxAdapter(
      child: Container(
        color: HsgColors.commonBackground,
        height: 20,
      ),
    ));

    return section;
  }

  ///上图下文字的按钮
  Widget _graphicButton(
      String title, String iconName, double iconWidth, VoidCallback onClick) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.only(left: 2, right: 2),
        onPressed: onClick,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Image(
                image: AssetImage(iconName),
                width: iconWidth,
                height: iconWidth,
              ),
            ),
            Container(
              height: 8.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HsgColors.describeText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
