import 'dart:ui';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///转账记录
/// Author: fangluyao
/// Date: 2020-12-24

import 'package:date_format/date_format.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_record.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:popup_window/popup_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class TrsnsferRecordPage extends StatefulWidget {
  @override
  _TrsnsferRecordPageState createState() => _TrsnsferRecordPageState();
}

class _TrsnsferRecordPageState extends State<TrsnsferRecordPage> {
  List<Rows> _transferHistoryList = [];
  String _card = intl.S.current.card;
  List<String> _cradLists = []; //银行卡列表
  int _position = 0;
  String _startConfirm = "";
  String _endConfirm = "";
  String _time = intl.S.current.the_same_month;
  String _endDate =
      DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()); //结束时间
  String _startDate = DateFormat('yyyy-MM-dd 00:00:00').format(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  )); //开始时间
  String _start = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示开始时间
  String _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
  String _actualName = ""; //用户真实姓名
  String language = Intl.getCurrentLocale(); //获取当前语言
  bool isButton1 = true;
  bool isButton2 = false;
  bool isButton3 = true;
  bool isButton4 = true;

  @override
  void initState() {
    super.initState();

    _actualNameReqData();
    _loadData();
  }

  //用户信息
  Future<void> _actualNameReqData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(GetUserInfoReq(userID), "getUserInfo")
        .then((data) {
      setState(() {
        _actualName = data.actualName;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

//转账记录
  Future<void> _loadData() async {
    //国际化
    if (language == 'zh_CN') {
      _cradLists = ['全部账户', '一网通账户（9396）', '招商银行储蓄卡（9396）'];
    } else {
      _cradLists = ['All account', 'One network (9396)', 'A cash Card (9396)'];
    }
    //请求参数
    String ccy = '';
    int page = 1;
    int pageSize = 10;
    List<String> paymentCardNos = [];
    String sort = '';
    String loginName = '18033412021';
    String userId = '778309634589982720';
    TransferDataRepository()
        .getTransferRecord(
            GetTransferRecordReq(ccy, _endDate, page, pageSize, paymentCardNos,
                sort, _startDate, loginName, userId),
            'getTransferRecord')
        .then((data) {
      if (data.rows != null) {
        setState(() {
          _transferHistoryList.clear();
          _transferHistoryList.addAll(data.rows);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(intl.S.of(context).transfer_record),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _headerWidget(),
            Expanded(
              child: _transferHistoryList.length > 0
                  ? _getlistViewList(context)
                  : _noDataContainer(context),
            ),
          ],
        ));
  }

//没有数据时显示页面
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
            intl.S.of(context).no_transfer_record,
            style: TextStyle(fontSize: 15, color: HsgColors.firstDegreeText),
          )
        ],
      ),
    );
  }

  //封装ListView.Builder
  Widget _getListViewBuilder(Widget function) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  //多个列表
  Widget _getlistViewList(BuildContext context) {
    List<Widget> _list = new List();
    for (int i = 0; i < _transferHistoryList.length; i++) {
      _list.add(_getListViewBuilder(_contentWidget(_transferHistoryList[i])));
    }
    _list.add(_toLoad());
    return RefreshIndicator(
      onRefresh: () => _loadData(),
      child: ListView(
        children: _list,
      ),
    );
  }

  //加载完毕
  Widget _toLoad() {
    return Container(
      height: 80,
      padding: EdgeInsets.only(top: 20),
      child: Text(
        intl.S.current.load_more_finished,
        style: TextStyle(fontSize: 14, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  //转账记录内容
  Widget _contentWidget(Rows _transferHistory) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Column(
                    children: [
                      Text(
                        _actualName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff262626),
                        ),
                      ),
                      Text(
                        _transferHistory.paymentCardNo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff262626),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  child: Image.asset(
                    "images/transferIcon/transfert_to.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Text(
                        _transferHistory.receiveName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff262626),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _transferHistory.receiveCardNo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff262626),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(19.5, 10, 19.5, 10),
              child: DottedLine(),
            ),
            _transferAmount(intl.S.of(context).transfer_amount,
                _transferHistory.amount, _transferHistory.status),
            _rowContent(intl.S.of(context).transfer_time,
                _transferHistory.transactionHour),
            _rowContent(
                intl.S.of(context).transfer_status, _transferHistory.status),
          ],
        ),
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
          GestureDetector(
            onTap: _chooseBankCard,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _card,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff262626),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: _popDialog(),
          ),
        ],
      ),
    );
  }

  //顶部弹窗
  Widget _popDialog() {
    return PopupWindowButton(
      offset: Offset(MediaQuery.of(context).size.width / 2.6, 200),
      buttonBuilder: (BuildContext context) {
        return GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _time,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff262626),
                ),
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        );
      },
      windowBuilder: (BuildContext popcontext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: Container(
              color: Colors.white,
              height: 180,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(2.5, 0, 0, 10),
                    child: Text(
                      intl.S.of(context).transaction_time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff262626),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  //交易时间
                  _tradingHour(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(2.5, 14, 0, 16),
                    child: Text(
                      intl.S.of(context).user_defined,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff262626),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  //自定义时间
                  _userDefind(popcontext),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //自定义时间
  Widget _userDefind(BuildContext popcontext) {
    return Row(
      children: [
        //开始时间按钮
        _timeButton(_start, 0, popcontext),
        Text(
          intl.S.of(context).zhi,
          style: TextStyle(
            fontSize: 13,
            color: Color(0xff262626),
            decoration: TextDecoration.none,
          ),
        ),
        //结束时间按钮
        _timeButton(_end, 1, popcontext),
        //确定按钮
        Container(
          margin: EdgeInsets.all(4),
          width: 72,
          height: 23.5,
          decoration: BoxDecoration(
            color: Color(0xff4871FF),
            borderRadius: BorderRadius.circular(5),
          ),
          child: OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            borderSide: BorderSide(color: Colors.white),
            child: Text(
              intl.S.of(context).confirm,
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _time = _start + "—" + _end;
                _startDate = _startConfirm;
                _endDate = _endConfirm;
              });
              Navigator.of(context).pop(_loadData());
            },
          ),
        ),
      ],
    );
  }

  //交易时间
  Widget _tradingHour() {
    return Row(
      children: [
        _trandingHourButton(1, isButton1, intl.S.current.the_same_day),
        _trandingHourButton(2, isButton2, intl.S.current.the_same_month),
        _trandingHourButton(3, isButton3, intl.S.current.last_three_month),
        _trandingHourButton(4, isButton4, intl.S.current.last_half_year),
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
        borderSide:
            BorderSide(color: isButton ? Color(0xffD1D1D1) : Color(0xff4871FF)),
        child: Text(
          time,
          style: TextStyle(
              fontSize: 10,
              color: isButton ? Color(0xff7A7A7A) : Color(0xff4871FF)),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            _time = time;
            _endDate = DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now());
            switch (i) {
              case 1:
                isButton1 = false;
                isButton2 = true;
                isButton3 = true;
                isButton4 = true;
                _startDate =
                    DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now());
                break;
              case 2:
                isButton1 = true;
                isButton2 = false;
                isButton3 = true;
                isButton4 = true;
                _startDate = DateFormat('yyyy-MM-dd 00:00:00').format(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  1,
                ));
                break;
              case 3:
                isButton1 = true;
                isButton2 = true;
                isButton3 = false;
                isButton4 = true;
                _startDate = DateFormat('yyyy-MM-dd 00:00:00')
                    .format(DateTime.now().subtract(Duration(days: 90)));
                break;
              case 4:
                isButton1 = true;
                isButton2 = true;
                isButton3 = true;
                isButton4 = false;
                _startDate = DateFormat('yyyy-MM-dd 00:00:00')
                    .format(DateTime.now().subtract(Duration(days: 180)));
                break;
            }
          });
          Navigator.of(context).pop(_loadData());
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
          _cupertinoPicker(i, popcontext);
        },
      ),
    );
  }

  //银行卡弹窗
  _chooseBankCard() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: intl.S.of(context).select_bank_card,
            items: _cradLists,
            lastSelectedPosition: _position,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _position = result;
      });
      _card = _cradLists[result];
    }
  }

//时间弹窗
  _cupertinoPicker(int i, BuildContext popcontext) {
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
      initialDateTime: DateTime.now(),
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          if (i == 0) {
            _start = formatDate(dateTime, [yyyy, mm, dd]);
            _startConfirm = DateFormat('yyyy-MM-dd 00:00:00').format(dateTime);
          } else {
            _end = formatDate(dateTime, [yyyy, mm, dd]);
            _endConfirm = DateFormat('yyyy-MM-dd 23:59:59').format(dateTime);
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
        statusColor = Color(0xff9C9C9C);
        break;
      case 'E':
        right = intl.S.current.failed;
        statusColor = Color(0xffA61F23);
        break;
      case 'P':
        right = intl.S.current.on_processing;
        statusColor = Color(0xff4871FF);
        break;
      default:
        statusColor = Color(0xff9C9C9C);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20.5, 0, 20.5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff9C9C9C),
            ),
          ),
          Text(
            right,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
            ),
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
        acountColor = Color(0xff9C9C9C);
        break;
      case 'P':
        acountColor = Color(0xff1F1F1F);
        break;
      default:
        acountColor = Color(0xff9C9C9C);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20.5, 0, 20.5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff9C9C9C),
            ),
          ),
          Text(
            right,
            style: TextStyle(
              fontSize: 12,
              color: acountColor,
            ),
          ),
        ],
      ),
    );
  }
}

// 虚线
class DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final Axis direction;

  const DottedLine({
    this.height = 1,
    this.color = HsgColors.divider,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWidth : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
        );
      },
    );
  }
}
