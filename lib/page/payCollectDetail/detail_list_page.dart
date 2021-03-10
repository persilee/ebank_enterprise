/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 收支明细
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_pay_collect_detail.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_record.dart';
import 'package:ebank_mobile/data/source/pay_collect_detail_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_pop_window_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:popup_window/popup_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class DetailListPage extends StatefulWidget {
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  List<RevenueHistoryDTOList> revenueHistoryList = [];
  DateTime _nowDate = DateTime.now(); //当前日期
  List<String> _allAccNoList = [];
  List<String> _accNoList = [];
  List<String> _cardList = [];
  List<String> _cardIcon = [];
  String _startDate = DateFormat('yyyy-MM-' + '01').format(DateTime.now());
  int _position = 0;
  bool _isButton1 = false; //交易时间第一个按钮
  bool _isButton2 = true; //交易时间第二个按钮
  bool _isButton3 = false; //交易时间第三个按钮
  bool _isButton4 = false; //交易时间第四个按钮
  String _time = intl.S.current.the_same_month; //时间
  int _page = 1; //几页数据
  String _endDate =
      DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()); //结束时间
  String _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
  String _start = formatDate(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      [yyyy, mm, dd]); //显示开始时间
  List<TransferRecord> _transferHistoryList = []; //转账记录列表
  GlobalKey _textKey = GlobalKey();

  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCardList();

    //下拉刷新
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    String _date = formatDate(_nowDate, [yyyy, '-', mm]);
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
            child: _getSelectButRow(_date),
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

  //头部选择
  Row _getSelectButRow(String _date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
//        GestureDetector(
//          onTap: _cupertinoPicker,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[Text(_date), Icon(Icons.arrow_drop_down)],
//          ),
//        ),

        _popDialog(),
        GestureDetector(
          onTap: _accountList,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _cardList.length > 0
                  ? Text(_cardList[_position] == ''
                      ? intl.S.current.all_account
                      : _cardList[_position])
                  : Text(intl.S.current.all_account),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ],
    );
  }

  //顶部弹窗
  Widget _popDialog() {
    return CustomPopupWindowButton(
      offset: Offset(0, 200),
      isRelative: true,
      buttonBuilder: (BuildContext context) {
        return GestureDetector(
          child: _headerText(_time),
        );
      },
      windowBuilder: (BuildContext popcontext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: _popDialogContent(popcontext),
          ),
        );
      },
    );
  }

  //头部文字
  Widget _headerText(String text) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    print(overlay);
    print(overlay.size);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          key: _textKey,
        ),
        Icon(Icons.arrow_drop_down),
      ],
    );
  }

  //顶部弹窗内容
  Widget _popDialogContent(BuildContext popcontext) {
    return Container(
      color: Colors.white,
      height: 180,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //交易时间
          _timeText(intl.S.of(context).transaction_time),
          _tradingHour(),
          //自定义时间
          _timeText(intl.S.of(context).user_defined),
          _userDefind(popcontext),
        ],
      ),
    );
  }

  //时间文本
  Widget _timeText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.5, 12, 0, 12),
      child: Text(
        text,
        style: TRANSFER_RECORD_POP_TEXT_STYLE,
      ),
    );
  }

  //交易时间
  Widget _tradingHour() {
    return Row(
      children: [
        _trandingHourButton(1, _isButton1, intl.S.current.the_same_day),
        _trandingHourButton(2, _isButton2, intl.S.current.the_same_month),
        _trandingHourButton(3, _isButton3, intl.S.current.last_three_month),
        _trandingHourButton(4, _isButton4, intl.S.current.last_half_year),
      ],
    );
  }

  //交易时间按钮
  Widget _trandingHourButton(int i, bool isButton, String time) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 78,
      height: 30,
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        borderSide: BorderSide(
          color: isButton ? HsgColors.blueTextColor : Color(0xffD1D1D1),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 10,
            color: isButton ? HsgColors.blueTextColor : Color(0xff7A7A7A),
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            _time = time;
            _page = 1;
            _transferHistoryList.clear();
            _endDate = DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now());
            _end = formatDate(DateTime.now(), [yyyy, mm, dd]);
            switch (i) {
              case 1:
                _isButton1 = true;
                _isButton2 = false;
                _isButton3 = false;
                _isButton4 = false;
                _startDate =
                    DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now());
                _start = formatDate(DateTime.now(), [yyyy, mm, dd]);
                break;
              case 2:
                _isButton1 = false;
                _isButton2 = true;
                _isButton3 = false;
                _isButton4 = false;
                _startDate = DateFormat('yyyy-MM-dd 00:00:00').format(
                  DateTime(DateTime.now().year, DateTime.now().month, 1),
                );
                _start = formatDate(
                  DateTime(DateTime.now().year, DateTime.now().month, 1),
                  [yyyy, mm, dd],
                );
                break;
              case 3:
                _isButton1 = false;
                _isButton2 = false;
                _isButton3 = true;
                _isButton4 = false;
                _startDate = DateFormat('yyyy-MM-dd 00:00:00').format(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month - 3,
                    DateTime.now().day,
                  ),
                );
                _start = formatDate(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month - 3,
                    DateTime.now().day,
                  ),
                  [yyyy, mm, dd],
                );
                break;
              case 4:
                _isButton1 = false;
                _isButton2 = false;
                _isButton3 = false;
                _isButton4 = true;
                _startDate = DateFormat('yyyy-MM-dd 00:00:00').format(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month - 6,
                    DateTime.now().day,
                  ),
                );
                _start = formatDate(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month - 6,
                    DateTime.now().day,
                  ),
                  [yyyy, mm, dd],
                );
                break;
            }
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  //自定义时间
  Widget _userDefind(BuildContext popcontext) {
    return Row(
      children: [
        //开始时间按钮
        _timeButton(_start, 0, popcontext),
        //至
        Text(
          intl.S.of(context).zhi,
          style: TextStyle(
            fontSize: 12,
            color: HsgColors.aboutusTextCon,
            decoration: TextDecoration.none,
          ),
        ),
        //结束时间按钮
        _timeButton(_end, 1, popcontext),
        //确定按钮
        _confimrButton(),
      ],
    );
  }

  Widget _confimrButton() {
    return Container(
      margin: EdgeInsets.all(4),
      width: 73,
      height: 23.5,
      decoration: BoxDecoration(
        color: HsgColors.blueTextColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        borderSide: BorderSide(color: Colors.white),
        child: Text(
          intl.S.of(context).confirm,
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            _time = _start + "—" + _end;
            _page = 1;
            _transferHistoryList.clear();
          });
          Navigator.of(context).pop();
//        Navigator.of(context).pop(_loadData());
        },
      ),
    );
  }

//自定义时间按钮
  Widget _timeButton(String name, int i, BuildContext popcontext) {
    return Container(
      margin: EdgeInsets.all(5),
      width: 111.5,
      height: 23.5,
      decoration: BoxDecoration(
        color: Color(0xffECECEC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 13, color: Color(0xff212121)),
            ),
            Container(
              width: 8,
              height: 7,
              margin: EdgeInsets.only(bottom: 20),
              child: Icon(
                Icons.arrow_drop_down,
                color: Color(0xffAAAAAA),
              ),
            ),
          ],
        ),
        onPressed: () {
//        _timePicker(i, popcontext);
        },
      ),
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

  //页面无数据显示
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

  //交易金额
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

  //日期选择
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
          _startDate = DateFormat('yyyy-MM-' + '01').format(dateTime);
          _nowDate = dateTime;
        });
        if (_position != 0) {
          _getRevenueByCards(_startDate, _accNoList);
        } else {
          _getRevenueByCards(_startDate, _allAccNoList);
        }
      },
    );
  }

  //账户选择
  void _accountList() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          // return HsgBottomCardChoice(
          //   title: intl.S.of(context).account_lsit,
          //   items: _cardList,
          //   lastSelectedPosition: _position,
          //   imageUrl: _cardIcon,
          // );
          return HsgBottomSingleChoice(
            title: intl.S.of(context).select_bank_card,
            items: _cardList,
            lastSelectedPosition: _position,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _position = result;
      });
      if (_position != 0) {
        _accNoList.clear();
        _accNoList.add(_cardList[result]);
        _getRevenueByCards(_startDate, _accNoList);
      } else {
        _getRevenueByCards(_startDate, _allAccNoList);
      }
    }
  }

  void _goToDetail(DdFinHistDOList ddFinHist) {
    Navigator.pushNamed(context, pageDetailInfo, arguments: ddFinHist);
  }

  _getRevenueByCards(String localDateStart, List<String> cards) async {
    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);

    HSProgressHUD.show();
    PayCollectDetailRepository()
        .getRevenueByCards(
            GetRevenueByCardsReq(
              localDateStart: localDateStart,
              page: '1',
              pageSize: '10',
              ciNo: custID,
              cards: cards,
            ),
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

  _getCardList() {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          _cardList.clear();
          _cardIcon.clear();
          _allAccNoList.clear();
          _cardList.add(intl.S.current.all_account);
          // _cardIcon.add("images/transferIcon/transfer_wallet.png");
          data.cardList.forEach((item) {
            _allAccNoList.add(item.cardNo);
            _cardList.add(item.cardNo);
            // String cardIconUrl = (item.imageUrl == null || item.imageUrl == '')
            //     ? "images/transferIcon/transfer_wallet.png"
            //     : item.imageUrl;
            _cardIcon.add(item.imageUrl);
          });
        });
        _getRevenueByCards(_startDate, _allAccNoList);
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
