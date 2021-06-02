/*
 * Created Date: Friday, December 4th 2020, 10:08:07 am
 * Author: pengyikang
 * 我的存单页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_record_info.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_timeDeposit.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_error_page.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class TimeDepositRecordPage extends StatefulWidget {
  TimeDepositRecordPage({Key key}) : super(key: key);

  @override
  _TimeDepositRecordPageState createState() => _TimeDepositRecordPageState();
}

class _TimeDepositRecordPageState extends State<TimeDepositRecordPage> {
  var ccy = ''; //币种
  var _totalAmtStr = ''; //定期存单总额
  var _defaultCcy = ''; //默认币种
  List<DepositRecord> rowList = []; //定期存单列表
  List<IdType> typeList = []; //定期公共代码接口
  String _languageType = Intl.getCurrentLocale();

  double conRate; //利率
  int _page = 1;
  int _totalPage = 10;
  String _stsNo = 'N';
  bool _isNomal = true; //是否是正常
  ScrollController _scrollController;
  RefreshController _refreshController;
  bool _isLoading = false; //加载状态
  bool _isShowErrorPage = false;
  Widget _hsgErrorPage;

  @override
  void initState() {
    super.initState();
    _loadPublicStatus();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    //获取定期存单列表
    _loadDeopstData();
    //接收通知
    EventBusUtils.getInstance().on<UpdateTDRecordEvent>().listen((event) {
      _page = 1;
      _loadDeopstData();
    });
  }

  void _loadPublicStatus() async {
// 获取状态
    try {
      GetIdTypeResp getIdTypeResp =
          await ApiClientOpenAccount().getIdType(GetIdTypeReq('TD_STATE'));
      List<IdType> _tenorList = getIdTypeResp.publicCodeGetRedisRspDtoList;
      if (_tenorList.isNotEmpty) {
        setState(() {
          typeList.addAll(_tenorList);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _isLoading
          ? HsgLoading()
          : CustomRefresh(
              controller: _refreshController,
              onLoading: () {
                //是否加载更多
                _page++;
                _loadDeopstData();
              },
              onRefresh: () {
                //刷新完成
                _page = 1;
                _loadDeopstData();
              },
              content: _isShowErrorPage
                  ? _hsgErrorPage
                  : rowList.isNotEmpty && rowList.length > 0
                      ? ListView.separated(
                          itemCount: rowList.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return _recordList(rowList[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            height: 10.0,
                            color: Colors.transparent,
                          ),
                        )
                      : HsgErrorPage(
                          isEmptyPage: true,
                          buttonAction: () {
                            _loadDeopstData();
                          },
                        ),
            ),
    );
  }

  //存单总额（币种）
  Widget _totalCcy() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.only(left: 0, top: 10, bottom: 20),
      child: Text(
        ' ${S.current.receipts_total_amt} (' + _defaultCcy + ')',
        textAlign: TextAlign.center,
        style: TextStyle(height: 1, fontSize: 15, color: Colors.white54),
      ),
    );
  }

  //存单总额
  Widget _totalAmt() {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
      child: Text(
        FormatUtil.formatSringToMoney(_totalAmtStr),
        textAlign: TextAlign.center,
        style: TextStyle(height: 1, fontSize: 40, color: Colors.white),
      ),
    );
  }

  Widget _selectBtn(String title, bool isSelect, VoidCallback callback) {
    FlatButton btn = FlatButton(
      onPressed: () {
        if (isSelect) {
          return;
        }
        callback();
      },
      child: Text(
        title,
        style: TextStyle(
          color: isSelect ? HsgColors.accent : HsgColors.canceledBtn,
          fontSize: 15,
        ),
      ),
    );
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: btn,
    );
  }

  //存单状态选择
  Widget _selectBtnWidget() {
    return Container(
      color: HsgColors.backgroundColor,
      height: 50,
      // padding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
      child: Row(
        children: [
          _selectBtn(
            S.of(context).time_deposit_record_Status_N,
            _isNomal,
            () {
              print('正常');
              if (mounted) {
                setState(() {
                  _isNomal = true;
                });
              }
              _page = 1;
              _stsNo = 'N';
              _loadDeopstData();
            },
          ),
          _selectBtn(
            S.of(context).time_deposit_record_Status_C,
            !_isNomal,
            () {
              print('已结清');
              if (mounted) {
                setState(() {
                  _isNomal = false;
                });
              }
              _page = 1;
              _stsNo = 'C';
              _loadDeopstData();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: Text(S.current.deposit_record),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Color(0xffFEFEFE),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Color(0xffFEFEFE),
          fontSize: 18,
          fontStyle: FontStyle.normal,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF1775BA),
            Color(0xFF3A9ED1),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
      bottom: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF1775BA),
              Color(0xFF3A9ED1),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                _totalAmt(),
                _totalCcy(),
                _selectBtnWidget(),
              ],
            ),
          ),
        ),
        preferredSize: Size(30, 170),
      ),
    );
  }

  //存单列表信息
  Widget _recordList(DepositRecord rows) {
    String bal = FormatUtil.formatSringToMoney('${rows.bal}');

    double conRate = double.parse(rows.conRate);
    conRate = double.parse(FormatUtil.formatNum(conRate, 2));
    var endTime = Row(
      //结束时间。倒着写的
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.current.due_date,
          style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
        ),
        Text(
          //到期时间
          rows?.mtDate ?? '',
          style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
        ),
      ],
    );

    String _statusText = '';
    typeList.forEach((element) {
      if (rows.conSts == element.code) {
        if (_languageType == 'zh_CN') {
          _statusText = element.cname;
        } else if (_languageType == 'zh_HK') {
          _statusText = element.chName;
        } else {
          _statusText = element.name;
        }
      }
    });
    // if (rows.conSts == 'C') {
    //   //状态为关闭显示 结清
    //   _statusText = S.current.time_deposit_record_Status_C;
    // } else if (rows.conSts == 'N') {
    //   //显示正常
    //   _statusText = S.current.time_deposit_record_Status_N;
    // }

    var _orderStatus = Row(
      //当前订单状态
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.current.approve_state,
          style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
        ),
        Text(
          //到期状态
          _statusText,
          style: TextStyle(fontSize: 15, color: Colors.red),
        ),
      ],
    );

    //存入金额
    var rate = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.deposit_amount,
            style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
          ),
          Text(
            '$bal  ${rows.ccy}',
            style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
          )
        ],
      ),
      // //到期本息以及收益
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       rows.conSts == 'C'
      //           ? S.current.contract_principal_and_interest
      //           : S.current.time_deposit_record_earnings,
      //       style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
      //     ),
      //     Text(
      //       rows.expTdAml + ' ' + rows.ccy,
      //       style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
      //     )
      //   ],
      // ),
      //利率
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.interest_rate,
            style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
          ),
          Text(
            //利率
            '$conRate%',
            style: TextStyle(fontSize: 15, color: Colors.red),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.effective_date,
            style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
          ),
          Text(
            //生效时间
            rows?.valDate ?? '',
            style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
          ),
        ],
      ),
      endTime, //时间
      _orderStatus //状态
    ];
    var startTime = rate;
    String _language = Intl.getCurrentLocale();
    String _nameStr = '';
    if (_language == 'zh_CN') {
      _nameStr = rows.lclName ?? rows.engName;
    } else if (_language == 'zh_HK') {
      _nameStr = rows.lclName ?? rows.engName;
    } else {
      _nameStr = rows.engName;
    }

    //整存整取 名称标题
    var taking = [
      SizedBox(
        // height: 37,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, //设置方式
          children: [
            //这是头部控件
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                _nameStr,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      Divider(height: 0, color: HsgColors.textHintColor),
      SizedBox(
        height: 120,
        child: Padding(
          //底部控件
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: startTime,
          ),
        ),
      )
    ];
    var raisedButton = RaisedButton(
        onPressed: () {
          if (rows.conSts == 'C') {
            //存单结清的详情
            Navigator.pushNamed(context, pageTimeDepositCloseDetail,
                arguments: rows);
          } else if (rows.conSts == 'N') {
            //存单正常的详情
            Navigator.pushNamed(context, pageDepositInfo, arguments: rows);
          }
        },
        padding: EdgeInsets.only(bottom: 12),
        color: Colors.white,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: taking,
        ));

    return raisedButton;
  }

  //获取定期存单列表
  Future<void> _loadDeopstData() async {
    _isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    String ciNo = prefs.getString(ConfigKey.CUST_ID);
    Future.wait({
      ApiClientTimeDeposit().getDepositRecordRows(
        DepositRecordReq(
          ciNo: ciNo,
          conNo: '',
          page: _page,
          pageSize: _totalPage,
          stsNo: _stsNo,
          nextKey: _page > 1 ? 'Y' : '',
        ),
      )
    }).then((value) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isShowErrorPage = false;
        });
        value.forEach((element) {
          setState(() {
            if (_page == 1) {
              _totalAmtStr = element.totalAmt;
            }
            _defaultCcy = element.defaultCcy;
            if (_page == 1) {
              rowList = element.rows;
            } else {
              rowList.addAll(element.rows);
            }

            if (element.rows.length < _totalPage ||
                element.toatalPage == _page) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete(); //加载完成
              _refreshController.loadNoData();
            } else {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete(); //加载完成
              _refreshController.footerMode.value = LoadStatus.canLoading;
            }
          });
          _isLoading = false;
        });
      }
    }).catchError((e) {
      if (e is NeedLogin) {
      } else {
        _hsgErrorPage = HsgErrorPage(
          error: e.error,
          buttonAction: () {
            _loadDeopstData();
          },
        );
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isShowErrorPage = true;
        });
      }
      // HSProgressHUD.showToast(e);
    });
  }

//抽取公共代码
  _elementDataOf(List valueData) {
    _refreshController.refreshCompleted(); //刷新完成
    valueData.forEach((element) {
      rowList.addAll(element.rows);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }
}
