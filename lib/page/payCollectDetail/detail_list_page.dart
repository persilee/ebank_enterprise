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
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import '../../page_route.dart';

class DetailListPage extends StatefulWidget {
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  List<RevenueHistoryDTOList> revenueHistoryList = [];
  DateTime _nowDate = DateTime.now(); //当前日期
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
      body: Column(
        children: [
          Container(
            height: 40,
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: _getRow(_date),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _getCardList(),
              child: revenueHistoryList.length > 0
                  ? _buildFlutterTableView()
                  : _noDataContainer(context),
            ),
          ),
        ],
      ),
    );
  }

  Row _getRow(String _date) {
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
              Text(accList[_position] == ''
                  ? intl.S.current.all_account
                  : accList[_position]),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ],
    );
  }

  // Get row count.
  int _rowCountAtSection(int section) {
    return revenueHistoryList[section].ddFinHistDOList.length;
  }

  // Section header widget builder.
  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return Column(
      children: [
        Container(
          height: 10,
          color: HsgColors.backgroundColor,
        ),
        Container(
          height: 35,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16),
          color: Colors.white,
          child: Text(revenueHistoryList[section].transDate),
        ),
      ],
    );
  }

  // cell item widget builder.
  Widget _cellBuilder(BuildContext context, int section, int row) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _goToDetail(revenueHistoryList[section].ddFinHistDOList[row]);
            },
            child: _getContainer(section, row),
          ),
          Padding(
            padding: EdgeInsets.only(left: 68, right: 16),
            child: Divider(
              height: 0.5,
              color: HsgColors.divider,
            ),
          ),
        ],
      ),
    );
  }

  Container _getContainer(int section, int row) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 15),
      child: Row(
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
            child: _transactionInfo(section, row),
          ),
        ],
      ),
    );
  }

  Column _transactionInfo(int section, int row) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 160,
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                revenueHistoryList[section].ddFinHistDOList[row].acNo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
              ),
            ),
            Container(
              child: _transactionAmount(revenueHistoryList, section, row),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 160,
              child: Text(
                revenueHistoryList[section].ddFinHistDOList[row].txDateTime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Color(0xFFACACAC)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Each section header height;
  double _sectionHeaderHeight(BuildContext context, int section) {
    return 45;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 70;
  }

  FlutterTableView _buildFlutterTableView() {
    return FlutterTableView(
      sectionCount: revenueHistoryList.length,
      rowCountAtSection: _rowCountAtSection,
      sectionHeaderBuilder: _sectionHeaderBuilder,
      cellBuilder: _cellBuilder,
      sectionHeaderHeight: _sectionHeaderHeight,
      cellHeight: _cellHeight,
    );
  }

  Container _noDataContainer(BuildContext context) {
    return Container(
      color: HsgColors.backgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Column(
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
      ),
    );
  }

  Text _transactionAmount(
      List<RevenueHistoryDTOList> revenueHistoryList, int section, int row) {
    return Text(
      revenueHistoryList[section].ddFinHistDOList[row].drCrFlg == 'C'
          ? '+ ' +
              revenueHistoryList[section].ddFinHistDOList[row].txCcy +
              ' ' +
              revenueHistoryList[section].ddFinHistDOList[row].txAmt
          : '- ' +
              revenueHistoryList[section].ddFinHistDOList[row].txCcy +
              ' ' +
              revenueHistoryList[section].ddFinHistDOList[row].txAmt,
      style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
    );
  }

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

  void _goToDetail(DdFinHistDOList ddFinHist) {
    Navigator.pushNamed(context, pageDetailInfo, arguments: ddFinHist);
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
    HSProgressHUD.show();
    PayCollectDetailRepository()
        .getRevenueByCards(
            GetRevenueByCardsReq(localDateStart: startDate, cards: cards),
            'GetRevenueByCardsReq')
        .then((data) {
      HSProgressHUD.dismiss();
      if (data.revenueHistoryDTOList != null) {
        setState(() {
          revenueHistoryList = data.revenueHistoryDTOList;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.dismiss();
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
