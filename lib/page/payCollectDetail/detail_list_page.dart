/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 收支明细
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_pay_collect_detail.dart';
import 'package:ebank_mobile/data/source/pay_collect_detail_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import '../../page_route.dart';

class DetailListPage extends StatefulWidget {
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  DateTime _nowDate = DateTime.now(); //当前日期
  List<RevenueHistoryDTOList> revenueHistoryList = [];
  List<String> cards = [];
  List<String> accList = [''];
  String startDate = DateFormat('yyyy-MM-' + '01').format(DateTime.now());
  int _position = 0;

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCardList();
  }

  @override
  Widget build(BuildContext context) {
    var _date = formatDate(_nowDate, [yyyy, '-', mm]);
    return Scaffold(
      appBar: AppBar(
        title: Text(intl.S.of(context).transaction_details),
        centerTitle: true,
        // elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: Column(
          children: [
            Container(
              height: 40,
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(bottom: 10),
              child: _searchRow(_date),
            ),
            Expanded(
              child: RefreshIndicator(
                child: revenueHistoryList.length > 0
                    ? CustomScrollView(
                        slivers: _sliversSection(revenueHistoryList),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: _noDataColumn(context),
                      ),
                onRefresh: () => _getRevenueByCards(startDate, cards),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _sliversSection(List data) {
    List<Widget> section = [];

    for (var item in data) {
      RevenueHistoryDTOList listData = item;
      List<DdFinHistDOList> ddFinHistList = listData.ddFinHistDOList;

      section.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 15, top: 10),
            color: Colors.white,
            child: Text(listData.transDate),
          ),
        ),
      );

      section.add(SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Column(
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 23, 15, 20),
                  color: Colors.white,
                  child: _getRow(ddFinHistList, index),
                ),
                onTap: () {
                  _goToDetail(ddFinHistList[index]);
                },
              ),
              Container(
                padding: EdgeInsets.only(left: 70, right: 13),
                child: Divider(height: 0.5, color: HsgColors.divider),
              ),
            ],
          );
        }, childCount: listData.ddFinHistDOList.length),
      ));

      section.add(
        SliverToBoxAdapter(
          child: Container(
            color: HsgColors.commonBackground,
            height: 10,
          ),
        ),
      );
    }
    return section;
  }

  Column _noDataColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('images/noDataIcon/no_data_record.png'),
          width: 160,
        ),
        Padding(padding: EdgeInsets.only(top: 25)),
        Text(
          intl.S.of(context).no_transaction_record,
          style: TextStyle(fontSize: 15, color: HsgColors.firstDegreeText),
        )
      ],
    );
  }

  Row _searchRow(String _date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: _cupertinoPicker,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(_date), Icon(Icons.arrow_drop_down)],
          ),
        ),
        GestureDetector(
          onTap: _accountList,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(accList[_position]),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ],
    );
  }

  Row _getRow(List<DdFinHistDOList> ddFinHistList, int index) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 13),
          child: ClipOval(
            child: Image.asset(
              'images/home/listIcon/home_list_payments.png',
              height: 38,
              width: 38,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 160,
                    child: Text(
                      ddFinHistList[index].acNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
                    ),
                  ),
                  Container(
                    child: _transactionAmount(ddFinHistList, index),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 160,
                    child: Text(
                      ddFinHistList[index].txDateTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Color(0xFFACACAC)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text _transactionAmount(List<DdFinHistDOList> ddFinHistList, int index) {
    return Text(
      ddFinHistList[index].drCrFlg == 'C'
          ? '+ ' + ddFinHistList[index].txCcy + ' ' + ddFinHistList[index].txAmt
          : '- ' +
              ddFinHistList[index].txCcy +
              ' ' +
              ddFinHistList[index].txAmt,
      style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
    );
  }

  void _goToDetail(DdFinHistDOList ddFinHist) {
    Navigator.pushNamed(context, pageDetailInfo, arguments: ddFinHist);
  }

  //调起flutter_cupertino_date_picker选择器
  void _cupertinoPicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(intl.S.current.confirm,
            style: TextStyle(color: Colors.black, fontSize: 16)),
        cancel: Text(intl.S.current.cancel,
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      minDateTime: DateTime.parse('1900-01-01'),
      maxDateTime: DateTime.now(),
      initialDateTime: _nowDate,
      dateFormat: 'yyyy-MM',
      locale: DateTimePickerLocale.zh_cn,
      onConfirm: (dateTime, List<int> index) {
        //确定的时候
        setState(() {
          startDate = DateFormat('yyyy-MM-' + '01').format(dateTime);
          _nowDate = dateTime;
          _getRevenueByCards(startDate, cards);
        });
      },
    );
  }

  void _accountList() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: intl.S.of(context).account_lsit,
            items: accList,
            lastSelectedPosition: _position,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _position = result;
      });
      if (result != 0) {
        List<String> accNoList = [];
        accNoList.clear();
        accNoList.add(accList[result]);
        _getRevenueByCards(startDate, accNoList);
      } else {
        _getRevenueByCards(startDate, cards);
      }
    }
  }

  _getRevenueByCards(String localDateStart, List<String> cards) async {
    PayCollectDetailRepository()
        .getRevenueByCards(
            GetRevenueByCardsReq(localDateStart: startDate, cards: cards),
            'GetRevenueByCardsReq')
        .then((data) {
      if (data.revenueHistoryDTOList != null) {
        setState(() {
          revenueHistoryList = data.revenueHistoryDTOList;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getCardList() async {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          cards.clear();
          accList.clear();
          accList.add(intl.S.current.all_account);
          data.cardList.forEach((item) {
            cards.add(item.cardNo);
            accList.add(item.cardNo);
          });
          _getRevenueByCards(startDate, cards);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
