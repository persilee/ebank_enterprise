/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///转账记录
/// Author: fangluyao
/// Date: 2020-12-24

import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_record.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_transfer.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_pop_window_button.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_dotted_line.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class TrsnsferRecordPage extends StatefulWidget {
  @override
  _TrsnsferRecordPageState createState() => _TrsnsferRecordPageState();
}

class _TrsnsferRecordPageState extends State<TrsnsferRecordPage> {
  List<TransferRecord> _transferHistoryList = []; //转账记录列表
  String _card = intl.S.current.all_account; //银行卡
  List<String> _cradLists = []; //银行卡列表
  List<String> _imageUrl = []; //银行卡图标列表
  List<String> paymentCardNos = []; //账户
  int _position = 0;
  // String _time = intl.S.current.the_same_month; //时间
  String _time = intl.S.current.custom_autofilter;
  String _endDate =
      DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()); //结束时间
  String _startDate = DateFormat('yyyy-MM-dd 00:00:00')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1)); //开始时间
  String _start = formatDate(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      [yyyy, mm, dd]); //显示开始时间
  String _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
  String _actualName = ""; //用户真实姓名
  bool _isButton1 = false; //交易时间第一个按钮
  bool _isButton2 = true; //交易时间第二个按钮
  bool _isButton3 = false; //交易时间第三个按钮
  bool _isButton4 = false; //交易时间第四个按钮
  ScrollController _scrollController = ScrollController(); //滚动监听
  int _page = 1; //第几页数据
  int _totalPage = 1; //数据总页数
  bool _loadMore = false; //是否加载更多
  bool _isLoading = false; //加载状态
  TextEditingController _startAmountController = TextEditingController();
  TextEditingController _endAmountController = TextEditingController();
  RefreshController _refreshController;
  String _language = Intl.getCurrentLocale();
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _actualNameReqData();
    _loadData();
    _getCardList();

    //滚动监听
    // _scrollController.addListener(() {
    //   setState(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       if (_page < _totalPage) {
    //         _loadMore = true;
    //       }
    //       _page++;
    //       _loadData();
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(intl.S.of(context).transfer_record),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        child: Column(
          children: [
            _headerWidget(),
            Expanded(
              child:
                  // _getlistViewList(context),
                  _isLoading
                      ? HsgLoading()
                      : _transferHistoryList.length > 0
                          ? CustomRefresh(
                              controller: _refreshController,
                              onLoading: () {
                                if (_page < _totalPage) {
                                  _loadMore = true;
                                  _page++;
                                }
                                //加载更多完成
                                if (_loadMore) {
                                  _loadData();
                                } else {
                                  //显示没有更多数据
                                  _refreshController.loadNoData();
                                }
                              },
                              onRefresh: () {
                                //刷新完成
                                _page = 1;
                                _transferHistoryList.clear();
                                _loadData();
                                _refreshController.refreshCompleted();
                                _refreshController.footerMode.value =
                                    LoadStatus.canLoading;
                              },
                              content: _getlistViewList(context),
                            )
                          : _noDataContainer(context),
            ),
          ],
        ),
      ),
    );
  }

  //没有数据时显示页面
  Container _noDataContainer(BuildContext context) {
    // HSProgressHUD.show();
    // Future.delayed(Duration(seconds: 1), () {
    //   HSProgressHUD.dismiss();
    // });
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
          Text(
            intl.S.of(context).no_transfer_record,
            style: FIRST_DEGREE_TEXT_STYLE,
          )
        ],
      ),
    );
  }

  //单个转账记录
  Widget _getListViewBuilder(Widget function) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (BuildContext context, int position) {
        return function;
      },
    );
  }

  //多个转账记录列表
  Widget _getlistViewList(BuildContext context) {
    List<Widget> _list = new List();
    bool _isData = false;
    //添加转账记录
    for (int i = 0; i < _transferHistoryList.length; i++) {
      if (_position == 0) {
        _isData = true;
        _list.add(_getListViewBuilder(_contentWidget(_transferHistoryList[i])));
      } else if ((_cradLists[_position] ==
              _transferHistoryList[i].paymentCardNo) ||
          (_cradLists[_position] == _transferHistoryList[i].receiveCardNo)) {
        _list.add(_getListViewBuilder(_contentWidget(_transferHistoryList[i])));
        _isData = true;
      }
    }
    // _list.add(
    //   _loadMore ? _loadMoreData() : _toLoad(intl.S.current.load_more_finished),
    //   // _loadMore ? Container() : _toLoad(intl.S.current.load_more_finished),
    // );

    // return RefreshIndicator(
    //   onRefresh: () => _loadData(),
    //   child: _isData
    //       ? ListView(controller: _controller, children: _list)
    //       : _noDataContainer(context),
    // );
    return _isData ? ListView(children: _list) : _noDataContainer(context);
  }

  //转账记录内容
  Widget _contentWidget(TransferRecord _transferHistory) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, pageTransferDetail,
            arguments: _transferHistory);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(0, 14, 0, 16),
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            //转账记录账号及图标
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _transferAccount(
                    _actualName, _transferHistory?.paymentCardNo ?? ''),
                _transferRecordImage("images/transferIcon/transfert_to.png"),
                _transferAccount(_transferHistory?.receiveName ?? '',
                    _transferHistory?.receiveCardNo ?? ''),
              ],
            ),
            //虚线
            Container(
              padding: EdgeInsets.fromLTRB(19.5, 10, 19.5, 10),
              child: DottedLine(),
            ),
            //转账记录金额、时间、状态
            _transferAmount(
                intl.S.of(context).transfer_amount,
                FormatUtil.formatSringToMoney(_transferHistory.debitAmount),
                _transferHistory.status),
            _rowContent(intl.S.of(context).transfer_time,
                _transferHistory.transactionTime),
            _rowContent(
                intl.S.current.transfer_type_with_value,
                _transferHistory.transferType == '0'
                    ? intl.S.current.transfer_type_0_short
                    : intl.S.current.transfer_type_1_short),
            _rowContent(
                intl.S.of(context).transfer_status, _transferHistory.status),
          ],
        ),
      ),
    );
  }

//转账记录图标
  Widget _transferRecordImage(String imgurl) {
    return Container(
      width: MediaQuery.of(context).size.width / 7,
      child: Image.asset(
        imgurl,
        width: 25,
        height: 25,
      ),
    );
  }

  //转账账号
  Widget _transferAccount(String name, String card) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        children: [
          Text(
            name,
            style: FIRST_DEGREE_TEXT_STYLE,
            textAlign: TextAlign.center,
          ),
          Text(
            card,
            style: SECOND_DEGREE_TEXT_STYLE,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  //头部
  Widget _headerWidget() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //时间
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: _popDialog(),
          ),
          //银行卡
          GestureDetector(
            onTap: _chooseBankCard,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: _headerText(_card),
            ),
          ),
        ],
      ),
    );
  }

//头部文字
  Widget _headerText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: SECOND_DEGREE_TEXT_STYLE,
        ),
        Icon(Icons.arrow_drop_down),
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
          opacity: animation, //animation
          // alwaysIncludeSemantics: true,
          child: SizeTransition(
            sizeFactor: animation,
            child: _popDialogContent(popcontext),
          ),
        );
      },
    );
  }

  //顶部弹窗内容
  Widget _popDialogContent(BuildContext popcontext) {
    return Container(
      color: Colors.white,
      // height: 335,
      height: 260,
      // padding: EdgeInsets.all(10),
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width,
              height: 12,
              color: Color(0xffF7F7F7),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //交易时间
                  _timeText(intl.S.of(context).transaction_time),
                  _tradingHour(popcontext),
                  //自定义时间
                  _timeText(intl.S.of(context).user_defined),
                  _userDefind(popcontext),
                  //金额
                  // _timeText(intl.S.current.amount),
                  // _amountDuration(),
                  //按钮
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _resetButton(popcontext),
                        _confimrButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  //至
  Widget _zhi() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(
        intl.S.of(context).zhi,
        style: TextStyle(
          fontSize: 12,
          color: HsgColors.aboutusTextCon,
          decoration: TextDecoration.none,
        ),
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
        _zhi(),
        //结束时间按钮
        _timeButton(_end, 1, popcontext),
      ],
    );
  }

  //金额
  Widget _amountDuration() {
    return Row(
      children: [
        _amountInput(_startAmountController),
        _zhi(),
        _amountInput(_endAmountController),
        // _amountConfimrButton(),
      ],
    );
  }

  //金额输入框
  Widget _amountInput(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(5),
      // margin: EdgeInsets.only(left: 5,right: 5),
      width: MediaQuery.of(context).size.width / 2.5,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xffECECEC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        // margin: EdgeInsets.only(top: 15),
        height: 30,
        child: Theme(
          data: new ThemeData(
              // primaryColor: Color(0xffECECEC),
              ),
          child: TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: 14,
                color: HsgColors.textHintColor,
              ),
              hintText: intl.S.current.not_required,
              contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 0),
              // contentPadding: EdgeInsets.all(0),
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

  //金额确定按钮
  Widget _amountConfimrButton() {
    return Container(
      margin: EdgeInsets.all(4),
      width: 75,
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
          Navigator.of(context).pop(_loadData());
        },
      ),
    );
  }

  //确定按钮
  Widget _confimrButton() {
    return Container(
      margin: EdgeInsets.all(5),
      width: (MediaQuery.of(context).size.width - 50) / 3,
      height: 30,
      decoration: BoxDecoration(
        // color: HsgColors.blueTextColor,
        gradient: LinearGradient(colors: [
          Color(0xFF1775BA),
          Color(0xFF3A9ED1),
        ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        padding: EdgeInsets.all(0),
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
            _isButton2 = false;
            _isButton1 = false;
            _isButton3 = false;
            _isButton4 = false;
          });
          Navigator.of(context).pop(_loadData());
        },
      ),
    );
  }

  //重置按钮
  Widget _resetButton(BuildContext popcontext) {
    return Container(
      width: (MediaQuery.of(context).size.width - 50) / 3,
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

  //交易时间
  Widget _tradingHour(popcontext) {
    return Row(
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
    );
  }

//交易时间按钮
  Widget _trandingHourButton(int i, bool isButton, String time, popcontext) {
    return Container(
      // margin: EdgeInsets.all(3),
      margin: EdgeInsets.only(top: 3, left: 3),
      width: (MediaQuery.of(context).size.width - 50) / 3,
      height: 30,
      child: OutlineButton(
        padding: EdgeInsets.all(0),
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
            // _transferHistoryList.clear();
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
          // Navigator.of(context).pop(_loadData());
          (popcontext as Element).markNeedsBuild();
        },
      ),
    );
  }

  //自定义时间按钮
  Widget _timeButton(String name, int i, BuildContext popcontext) {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 2.5,
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

  //银行卡弹窗
  _chooseBankCard() async {
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return
            // HsgBottomCardChoice(
            //   title: intl.S.of(context).select_bank_card,
            //   items: _cradLists,
            //   lastSelectedPosition: _position,
            //   imageUrl: _imageUrl,
            // );
            HsgBottomSingleChoice(
          title: intl.S.of(context).select_bank_card,
          items: _cradLists,
          lastSelectedPosition: _position,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _position = result;
        _card = _cradLists[result];
        paymentCardNos = [];
        _transferHistoryList.clear();
        // paymentCardNos.add(_card);
      });
      _loadData();
    }
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
      initialDateTime:
          i == 0 ? DateTime.parse(_startDate) : DateTime.parse(_endDate),
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          if (i == 0) {
            _start = formatDate(dateTime, [yyyy, mm, dd]);
            _startDate = DateFormat('yyyy-MM-dd 00:00:00').format(dateTime);
          } else {
            _end = formatDate(dateTime, [yyyy, mm, dd]);
            _endDate = DateFormat('yyyy-MM-dd 23:59:59').format(dateTime);
          }
        });
        (popcontext as Element).markNeedsBuild();
      },
    );
  }

  //单行内容
  Widget _rowContent(String left, String right) {
    Color statusColor;
    switch (right) {
      case 'N':
        right = intl.S.current.success;
        statusColor = HsgColors.describeText;
        break;
      case 'E':
        right = intl.S.current.failed;
        statusColor = Color(0xffA61F23);
        break;
      case 'P':
        right = intl.S.current.on_processing;
        statusColor = HsgColors.blueTextColor;
        break;
      default:
        statusColor = HsgColors.describeText;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20.5, 0, 20.5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: FIRST_DEGREE_TEXT_STYLE),
          Text(
            right == null ? '' : right,
            style: TextStyle(fontSize: 12, color: statusColor),
          ),
        ],
      ),
    );
  }

  //转账金额
  Widget _transferAmount(String left, String right, String status) {
    Color acountColor;
    switch (status) {
      case 'N':
        acountColor = Color(0xffF1454E);
        break;
      case 'E':
        acountColor = HsgColors.describeText;
        break;
      case 'P':
        acountColor = Color(0xff1F1F1F);
        break;
      default:
        acountColor = HsgColors.describeText;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20.5, 0, 20.5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: FIRST_DEGREE_TEXT_STYLE,
          ),
          Text(
            right,
            style: TextStyle(fontSize: 12, color: acountColor),
          ),
        ],
      ),
    );
  }

  //获取用户真实姓名
  Future<void> _actualNameReqData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _actualName = (_language == 'zh_CN' || _language == 'zh_HK')
          ? prefs.getString(ConfigKey.CUST_LOCAL_NAME)
          : prefs.getString(ConfigKey.CUST_ENG_NAME);
    });
    // String userID = prefs.getString(ConfigKey.USER_ID);
    // // UserDataRepository()
    // ApiClientPackaging().getUserInfo(GetUserInfoReq(userID)).then((data) {
    //   if (this.mounted) {
    //     setState(() {
    //       _actualName = data?.actualName ?? '';
    //     });
    //   }
    // }).catchError((e) {
    //   // HSProgressHUD.showToast(e);
    // });
  }

  //获取银行卡
  _getCardList() {
    // CardDataRepository()
    ApiClientAccount().getCardList(GetCardListReq()).then((data) {
      if (data.cardList != null) {
        if (this.mounted) {
          setState(() {
            _cradLists.clear();
            _imageUrl.clear();
            _cradLists.add(intl.S.current.all_account);
            // _imageUrl.add("images/transferIcon/transfer_wallet.png");
            data.cardList.forEach((e) {
              _cradLists.add(e.cardNo);
              _imageUrl.add(e.imageUrl);
            });
            _cradLists = _cradLists.toSet().toList();
          });
        }
      }
    }).catchError((e) {
      // HSProgressHUD.showToast(e);
    });
  }

  //转账记录
  Future _loadData() async {
    _isLoading = true;
    //请求参数
    String ccy = '';
    int pageSize = 10;
    String sort = '';
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    String userAccount = prefs.getString(ConfigKey.USER_ACCOUNT);
    // String loginName = '18033412021';
    // String userId = '778309634589982720';
    // HSProgressHUD.show();
    // TransferDataRepository()
    //     .getTransferRecord(
    //         GetTransferRecordReq(ccy, _endDate, _page, pageSize, paymentCardNos,
    //             sort, _startDate, userAccount, userID),
    //         'getTransferRecord')
    Transfer()
      ..getTransferRecord(GetTransferRecordReq(ccy, _endDate, _page, pageSize,
              paymentCardNos, sort, _startDate, userAccount, userID))
          .then((data) {
        if (this.mounted) {
          setState(() {
            if (data.transferRecord != null) {
              _totalPage = data.totalPage;
              _transferHistoryList.addAll(data.transferRecord);
            }
            _loadMore = false;
            _isLoading = false;
            _refreshController.loadComplete();
          });
        }

        // HSProgressHUD.dismiss();
      }).catchError((e) {
        // HSProgressHUD.showToast(e);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
  }
}
