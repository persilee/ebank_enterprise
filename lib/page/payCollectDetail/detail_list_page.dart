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
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_pop_window_button.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class DetailListPage extends StatefulWidget {
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  List<DdFinHisDTOList> ddFinHisDTOList = [];
  DateTime _nowDate = DateTime.now(); //当前日期
  List<String> _allAccNoList = [];
  List<String> _accNoList = [];
  List<String> _cardList = [];
  List<String> _cardIcon = [];
  String _startDate = DateFormat('yyyy-MM-01').format(DateTime.now());
  int _position = 0;
  bool _isButton1 = false; //交易时间第一个按钮
  bool _isButton2 = true; //交易时间第二个按钮
  bool _isButton3 = false; //交易时间第三个按钮
  bool _isButton4 = false; //交易时间第四个按钮
  String _time = intl.S.current.the_same_month; //时间
  int _page = 1; //几页数据
  //int _totalPage = 1; //数据总页数
  bool _loadMore = false; //是否加载更多
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); //结束时间

  String _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
  String _start = formatDate(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      [yyyy, mm, dd]); //显示开始时间
  List<TransferRecord> _transferHistoryList = []; //转账记录列表
  GlobalKey _textKey = GlobalKey();
  TextEditingController _moneyController = TextEditingController();
  // var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>(); //下拉刷新
  TextEditingController _startAmountController = TextEditingController();
  TextEditingController _endAmountController = TextEditingController();
  String selectAccNo;
  bool _isLoading = true; //加载状态
  RefreshController _refreshController;
  ScrollController _scrollController = ScrollController(); //滚动监听

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    //
    setState(() {
      _getCardList();
    });
    //_getRevenueByCards(_startDate, _allAccNoList);
    _refreshController = RefreshController();
    // //下拉刷新
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   refrestIndicatorKey.currentState.show();
    // });
  }

  @override
  Widget build(BuildContext context) {
    String _date = formatDate(_nowDate, [yyyy, '-', mm]);
    return Scaffold(
      appBar: AppBar(
        title: Text(intl.S.of(context).transaction_details),
        centerTitle: true,
        elevation: 0,
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
            child: _isLoading
                ? HsgLoading()
                : ddFinHisDTOList.length > 0
                    ? CustomRefresh(
                        controller: _refreshController,
                        //上拉加载
                        onLoading: () {
                          _refreshController.loadNoData();
                        },
                        //下拉刷新
                        onRefresh: () {
                          //刷新完成
                          if (_position != 0) {
                            _getRevenueByCards(_startDate, _accNoList);
                          } else {
                            _getRevenueByCards(_startDate, _allAccNoList);
                          }
                        },
                        content: _buildFlutterTableView(),
                      )
                    : _noDataContainer(context),
            //  RefreshIndicator(
            // onRefresh: () => _getCardList(),
            // child: ddFinHisDTOList.length > 0
            //     ? _buildFlutterTableView()
          ),
          //  ),
        ],
      ),
    );
  }

  //头部选择
  Row _getSelectButRow(String _date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //顶部选择时间
        _popDialog(),
        GestureDetector(
          onTap: _accountList,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _cardList.length > 0
                  ? Text(
                      _cardList[_position] == ''
                          ? intl.S.current.all_account
                          : _cardList[_position],
                      overflow: TextOverflow.clip,
                    )
                  : Text(
                      intl.S.current.all_account,
                      overflow: TextOverflow.clip,
                    ),
              Icon(
                Icons.arrow_drop_down,
                size: 22,
              )
            ],
          ),
        ),
      ],
    );
  }

  //顶部弹窗--选择时间
  Widget _popDialog() {
    return CustomPopupWindowButton(
      offset: Offset(0, 200),
      isRelative: true,
      buttonBuilder: (BuildContext context) {
        return GestureDetector(
          child: _headerText(_time),
          // intl.S.of(context).custom_autofilter   自定义选择
        );
      },
      windowBuilder: (BuildContext popcontext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: Column(
              children: [
                Container(
                  color: Color(0xFFF8F8F8),
                  height: 10,
                ),
                _popDialogContent(popcontext),
              ],
            ),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(text, key: _textKey, overflow: TextOverflow.clip),
        Icon(
          Icons.arrow_drop_down,
          size: 22,
        ),
      ],
    );
  }

  //顶部弹窗内容
  Widget _popDialogContent(BuildContext popcontext) {
    return Container(
      color: Colors.white,
      height: 230,
      padding: EdgeInsets.all(10),
      child: Material(
          child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: 20,
                //   color: Color(0xFFF7F7F7),
                // ),
                //交易时间
                _timeText(intl.S.of(context).transaction_time),
                _tradingHour(popcontext),
                //自定义时间
                _timeText(intl.S.of(context).user_defined),
                _userDefind(popcontext),
                //金额
                // _timeText(intl.S.of(context).amount),
                // _amountDuration(),
                //按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _resetButton(popcontext),
                    _confimrButton(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  //时间文本
  Widget _timeText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 12, 0, 12),
      child: Text(
        text,
        style: TRANSFER_RECORD_POP_TEXT_STYLE,
      ),
    );
  }

  //交易时间
  Widget _tradingHour(popcontext) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _trandingHourButton(
                1, _isButton1, intl.S.current.the_same_day, popcontext),
            _trandingHourButton(
                2, _isButton2, intl.S.current.the_same_month, popcontext),
            _trandingHourButton(
                3, _isButton3, intl.S.current.last_three_month, popcontext),
            // _trandingHourButton(
            //     4, _isButton4, intl.S.current.last_half_year, popcontext),
          ],
        ));
  }

  //交易时间按钮
  Widget _trandingHourButton(int i, bool isButton, String time, popcontext) {
    return Container(
      margin: EdgeInsets.all(3),
      width: MediaQuery.of(popcontext).size.width / 3.6,
      //width: 73,
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
            _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
            _end = formatDate(DateTime.now(), [yyyy, mm, dd]);
            switch (i) {
              case 1:
                _isButton1 = true;
                _isButton2 = false;
                _isButton3 = false;
                _isButton4 = false;
                _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                _start = formatDate(DateTime.now(), [yyyy, mm, dd]);
                break;
              case 2:
                _isButton1 = false;
                _isButton2 = true;
                _isButton3 = false;
                _isButton4 = false;
                _startDate = DateFormat('yyyy-MM-dd').format(
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
                _startDate = DateFormat('yyyy-MM-dd').format(
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
                _startDate = DateFormat('yyyy-MM-dd').format(
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

          //选择之后不立马放下弹窗
          (popcontext as Element).markNeedsBuild();
        },
      ),
    );
  }

  //自定义时间
  Widget _userDefind(BuildContext popcontext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      ],
    );
  }

  //确定按钮
  Widget _confimrButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
      width: MediaQuery.of(context).size.width / 3.6,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1775BA),
            Color(0xFF3A9ED1),
          ],
        ),
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
          if (_position != 0) {
            _getRevenueByCards(_startDate, _accNoList);
          } else {
            _getRevenueByCards(_startDate, _allAccNoList);
          }
        },
      ),
    );
  }

  //金额
  Widget _amountDuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _amountInput(context, _startAmountController),
        Text(
          intl.S.of(context).zhi,
          style: TextStyle(
            fontSize: 12,
            color: HsgColors.aboutusTextCon,
            decoration: TextDecoration.none,
          ),
        ),
        _amountInput(context, _endAmountController),
        //  _amountConfimrButton(context),
      ],
    );
  }

  //金额确定按钮
  Widget _amountConfimrButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width / 4.4,
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
            _transferHistoryList.clear();
          });
          Navigator.of(context)
              .pop(_getRevenueByCards(_startDate, _allAccNoList));
        },
      ),
    );
  }

  //重置按钮
  Widget _resetButton(BuildContext popcontext) {
    return Container(
      width: MediaQuery.of(popcontext).size.width / 3.6,
      height: 30,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0x77939393), width: 0.5),
        borderRadius: BorderRadius.circular((5)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        // disabledColor: HsgColors.btnDisabled,
        child: Text(
          intl.S.of(context).reset,
          style: TextStyle(
            fontSize: 13,
            // color: HsgColors.accent,
          ),
        ),
        onPressed: () {
          setState(() {
            _time = intl.S.current.the_same_month;
            _isButton2 = true;
            _isButton1 = false;
            _isButton3 = false;
            _isButton4 = false;
            _start = formatDate(
                DateTime(DateTime.now().year, DateTime.now().month, 1),
                [yyyy, mm, dd]); //显示开始时间
            _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
            (popcontext as Element).markNeedsBuild();
            _startAmountController.text = '';
            _endAmountController.text = '';
          });
        },
      ),
    );
  }

  //金额输入框
  Widget _amountInput(BuildContext context, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width / 2.7,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xffECECEC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        child: Theme(
          data: new ThemeData(
            primaryColor: Color(0xffECECEC),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: 14,
                color: HsgColors.textHintColor,
              ),
              hintText: intl.S.current.not_required,
              contentPadding: EdgeInsets.all(0),
              border:
                  // InputBorder.none,
                  OutlineInputBorder(
                gapPadding: 0,
                borderRadius: ((BorderRadius.circular(5))),
                borderSide: BorderSide(
                  color: Color(0xffECECEC),
                ),
              ),
            ),
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              LengthLimitingTextInputFormatter(12),
            ],
            style: TextStyle(
              fontSize: 14,
            ),
            autocorrect: false,
            autofocus: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) {},
          ),
        ),
      ),
    );
  }

//自定义时间按钮
  Widget _timeButton(String name, int i, BuildContext popcontext) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
      width: MediaQuery.of(context).size.width / 2.7,
      height: 30,
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
              margin: EdgeInsets.only(bottom: 20, left: 10),
              child: Icon(
                Icons.arrow_drop_down,
                color: Color(0xffAAAAAA),
              ),
            ),
          ],
        ),
        onPressed: () {
          _timePicker(i, popcontext);
        },
      ),
    );
  }

  // Get row count.
  int _rowCountAtSection(int section) {
    return ddFinHisDTOList.length;
  }

  //交易时间 --头标题
  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    //String _titileTime =  DateFormat('yyyy-MM-dd').format(dateTime);
    RegExp characters = new RegExp("/\d{4}-\d{1,2}-\d{1,2}/g");
    //var newDate=/\d{4}-\d{1,2}-\d{1,2}/g.exec(date)
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
          //交易时间
          //  child: Text(ddFinHisDTOList[section].transDate),
          child: Text(ddFinHisDTOList[section].txDateTime.substring(0, 10)),
        ),
      ],
    );
  }

  Widget _cellBuilder(BuildContext context, int section, int row) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _goToDetail(ddFinHisDTOList[section]);
            },
            child: _getContainer(section, row, context),
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

  Container _getContainer(
    int section,
    int row,
    BuildContext context,
  ) {
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
            child: _transactionInfo(section, row, context),
          ),
        ],
      ),
    );
  }

  Column _transactionInfo(int section, int row, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.4,
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                //账号
                ddFinHisDTOList[section].acNo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2.85,
              child: _transactionAmount(ddFinHisDTOList, section, row, context),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 160,
              child: Text(
                ddFinHisDTOList[section].txDateTime,
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
      controller: _scrollController,
      sectionCount: ddFinHisDTOList.length,
      rowCountAtSection: _rowCountAtSection,
      sectionHeaderBuilder: _sectionHeaderBuilder,
      cellBuilder: _cellBuilder,
      sectionHeaderHeight: _sectionHeaderHeight,
      cellHeight: _cellHeight,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // listViewFatherWidgetBuilder :_noDataContainer(context),//( ddFinHisDTOList.length > 0) ? Container()
      // : _noDataContainer(context),
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
  Text _transactionAmount(List<DdFinHisDTOList> ddFinHisDTOList, int section,
      int row, BuildContext context) {
    return Text(
      ddFinHisDTOList[section].drCrFlg == 'C'
          ? '+ ' +
              ddFinHisDTOList[section].txCcy +
              ' ' +
              FormatUtil.formatSringToMoney(ddFinHisDTOList[section].txAmt)
          : '- ' +
              ddFinHisDTOList[section].txCcy +
              ' ' +
              FormatUtil.formatSringToMoney(ddFinHisDTOList[section].txAmt),
      style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
      textAlign: TextAlign.right,
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
          _startDate = DateFormat('yyyy-MM-01').format(dateTime);
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

  //时间选择器弹窗
  _timePicker(int i, BuildContext popcontext) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          intl.S.current.confirm,
          style: TRANSFER_RECORD_TIME_PICKER_TEXT_STYLE,
        ),
        cancel: Text(
          intl.S.current.cancel,
          style: TRANSFER_RECORD_TIME_PICKER_TEXT_STYLE,
        ),
      ),
      minDateTime: DateTime.parse('1900-01-01'),
      maxDateTime: DateTime.now(),
      initialDateTime: i == 0
          ? DateTime.parse(_startDate)
          : DateTime.parse(_endDate), //DateTime.now(),
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          if (i == 0) {
            _start = formatDate(dateTime, [yyyy, mm, dd]);
            _startDate = DateFormat('yyyy-MM-dd').format(dateTime);
          } else {
            _end = formatDate(dateTime, [yyyy, mm, dd]);
            _endDate = DateFormat('yyyy-MM-dd').format(dateTime);
          }
        });
        (popcontext as Element).markNeedsBuild();
      },
    );
  }

  //账户选择
  void _accountList() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: intl.S.of(context).select_bank_card,
            items: _cardList,
            lastSelectedPosition: _position,
          );
        });
    if (result != null && result != false) {
      if (mounted) {
        setState(() {
          _position = result;
          selectAccNo = _cardList[result];
        });
      }

      if (_position != 0) {
        _accNoList.clear();
        _accNoList.add(_cardList[result]);
        _getRevenueByCards(_startDate, _accNoList);
      } else {
        _getRevenueByCards(_startDate, _allAccNoList);
      }
    }
  }

  void _goToDetail(DdFinHisDTOList ddFinHist) {
    Navigator.pushNamed(context, pageDetailInfo, arguments: ddFinHist);
  }

  //获取账号
  _getCardList() {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (mounted) {
        setState(() {
          if (data.cardList != null) {
            _cardList.clear();
            _cardIcon.clear();
            _allAccNoList.clear();
            _cardList.add(intl.S.current.all_account);
            data.cardList.forEach((item) {
              _allAccNoList.add(item.cardNo);
              _cardList.add(item.cardNo);
              _cardIcon.add(item.imageUrl);
            });

            _getRevenueByCards(_startDate, _allAccNoList);
          } else if (data.cardList == null) {
            _isLoading = false;
          }
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    });
  }

  //获取所有历史记录
  _getRevenueByCards(String localDateStart, List<String> cards) async {
    String localCcy;
    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);
    // String accNo = _accNoList.toString();
    if (_cardList.length < 1) {
      selectAccNo = '';
    } else {
      selectAccNo = selectAccNo == _cardList[0] ? '' : selectAccNo;
    }

    localCcy = prefs.getString(ConfigKey.LOCAL_CCY);

    int pageSize = 10;

    PayCollectDetailRepository()
        .getRevenueByCards(
            GetRevenueByCardsReq(
                localCcy,
                '$_endDate', //结束时间     '$_endDate'
                '$_startDate', //开始时间   '$_startDate'
                0, //分页page
                20, //分页pageSize
                acNo: '$selectAccNo',
                ciNo: '$custID'), //'818000000113'
            'GetRevenueByCardsReq')
        .then((data) {
      HSProgressHUD.dismiss();
      if (data.ddFinHisDTOList != null) {
        if (mounted) {
          setState(() {
            ddFinHisDTOList = data.ddFinHisDTOList;
            _isLoading = false;
            _refreshController.refreshCompleted();
            _refreshController.footerMode.value = LoadStatus.canLoading;
          });
        }
      }
    }).catchError((e) {
      _isLoading = false;
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      // HSProgressHUD.dismiss();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    // _scrollController.dispose();
  }
}
