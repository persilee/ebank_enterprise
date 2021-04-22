/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///转账计划列表页面
/// Author: wangluyao
/// Date: 2021-01-15

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/cancel_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_plan_list.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/transfer.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_dotted_line.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransferPlanPage extends StatefulWidget {
  TransferPlanPage({Key key}) : super(key: key);

  @override
  _TransferPlanPageState createState() => _TransferPlanPageState();
}

class _TransferPlanPageState extends State<TransferPlanPage> {
  String groupValue = '0';
  List<String> _statusList = ['P', 'A']; //转账计划状态
  List<TransferPlan> transferPlanList = [];
  String frequency = '';
  String transferType = '';
  String planId = '';
  String nextDate = '--';
  String btnTitle = S.current.cancel_plan;
  Color btnColor = HsgColors.accent;
  Color textColor = Colors.white;
  bool _isDate = false;
  bool _isColor = false;
  BorderRadius borderRadius;
  bool _isLoading = false; //加载状态
  int _page = 1; //第几页数据
  int _totalPage = 1; //数据总页数
  bool _loadMore = false; //是否加载更多
  bool _enableClick = true; //是否能点击
  RefreshController _refreshController;
  // var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List state = [
    {
      "title": S.current.in_progress,
      "type": "0",
    },
    {
      "title": S.current.already_finished,
      "type": "1",
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    _getTransferPlanList();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   refrestIndicatorKey.currentState.show();
    // });
  }

  //改变groupValue
  void updateGroupValue(String value) {
    setState(() {
      groupValue = value;
    });
  }

  //文本样式
  Widget _textStyle(String text, Color textColor, double textSize,
      FontWeight textWeight, TextAlign align) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          color: textColor, fontSize: textSize, fontWeight: textWeight),
    );
  }

  //提示对话框
  _alertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.current.prompt,
            message: S.current.confirm_cancel_transfer_plan,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      if (value == true) {
        _cancleTransferPlan();
      }
    });
  }

//显示一行信息
  Widget _showOneLine(
    String leftText,
    String rightText,
  ) {
    return Container(
      padding: EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 2,
            child: _textStyle(leftText, HsgColors.detailText, 12.0,
                FontWeight.normal, TextAlign.left),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 2,
            child: _textStyle(rightText, HsgColors.detailText, 12.0,
                FontWeight.normal, TextAlign.right),
          ),
        ],
      ),
    );
  }

  //转账计划信息
  Widget _planInfo(String amountAndCcy, String frequency, String startDate,
      String endDate, String nextDate, String transferType) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 7),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          _showOneLine(S.current.transfer_amount_each_time, amountAndCcy),
          _showOneLine(S.current.transfer_frequency, frequency),
          _showOneLine(S.current.first_time_of_transfer_with_value, startDate),
          _showOneLine(S.current.stop_time, endDate),
          _showOneLine(S.current.next_transfer_time, nextDate),
          _showOneLine(S.current.transfer_type_with_value, transferType),
        ],
      ),
    );
  }

  //按钮样式
  Widget _btnStyle(
    String btnTitle,
    String btnType,
    Color btnColor,
    Color textColor,
    BorderSide borderSide,
    double textSize,
    BorderRadius borderRadius,
    bool enableClick,
  ) {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //       colors: _isColor
      //           ? [
      //               Color(0xFF1775BA),
      //               Color(0xFF3A9ED1),
      //             ]
      //           : [btnColor, btnColor],
      //       begin: Alignment.centerLeft,
      //       end: Alignment.centerRight),
      //   borderRadius: BorderRadius.circular(5),
      // ),
      child: FlatButton(
        padding: EdgeInsets.zero,
        color: btnColor,
        shape: RoundedRectangleBorder(
            side: borderSide, borderRadius: borderRadius),
        onPressed: !enableClick
            ? () {}
            : () {
                setState(() {
                  if (btnTitle == S.current.in_progress) {
                    _statusList = ['P', 'A'];
                    updateGroupValue(btnType);
                    transferPlanList.clear();
                    _page = 1;
                    _getTransferPlanList();
                  } else if (btnTitle == S.current.already_finished) {
                    _statusList = ['C', 'E'];
                    updateGroupValue(btnType);
                    transferPlanList.clear();
                    _page = 1;
                    _getTransferPlanList();
                  } else if (btnTitle == S.current.cancel_plan) {
                    _alertDialog();
                  } else {
                    _statusList = ['C', 'E'];
                    transferPlanList.clear();
                    _page = 1;
                    _getTransferPlanList();
                  }
                });
              },
        child: _textStyle(
            btnTitle, textColor, textSize, FontWeight.normal, TextAlign.center),
      ),
    );
  }

  //切换按钮
  Widget _toggleButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: GridView.count(
        padding: EdgeInsets.only(left: 75, right: 75),
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1 / 0.25,
        children: state.map((value) {
          borderRadius = value['title'] == S.current.in_progress
              ? BorderRadius.horizontal(left: Radius.circular(5))
              : BorderRadius.horizontal(right: Radius.circular(5));
          return groupValue == value['type']
              ? _btnStyle(
                  value['title'],
                  value['type'],
                  Color(0xff3394D4),
                  HsgColors.aboutusText,
                  BorderSide.none,
                  14.0,
                  borderRadius,
                  true,
                )
              : _btnStyle(
                  value['title'],
                  value['type'],
                  Colors.white,
                  HsgColors.notSelectedBtn,
                  BorderSide(color: HsgColors.divider),
                  14.0,
                  borderRadius,
                  true,
                );
        }).toList(),
      ),
    );
  }

//计划名称
  Widget _planName(String name) {
    return Container(
      color: Colors.white,
      height: 40,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                _transferRecordImage(
                    'images/transferIcon/transfer_plan.png', 15, 13, 13),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: ((MediaQuery.of(context).size.width - 30) / 2),
                  child: _textStyle(S.current.plan_name_with_value + name,
                      Colors.black, 12.0, FontWeight.normal, TextAlign.left),
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 4,
            height: 25,
            child: _btnStyle(
              btnTitle,
              null,
              btnColor,
              // Colors.white,
              textColor,
              BorderSide.none,
              13.0,
              BorderRadius.all(
                Radius.circular(13),
              ),
              _enableClick,
            ),
          ),
        ],
      ),
    );
  }

  //图标
  Widget _transferRecordImage(
      String imgurl, double width, double imageWidth, double imageHeight) {
    return Container(
      width: width,
      child: Image.asset(
        imgurl,
        width: imageWidth,
        height: imageHeight,
      ),
    );
  }

//虚线
  Widget _dottedLine() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(19.5, 15, 19.5, 15),
      child: DottedLine(),
    );
  }

//付款银行和收款银行
  Widget _bank(String bankName, String cardNo) {
    return Container(
      width: (MediaQuery.of(context).size.width -
              50 -
              (MediaQuery.of(context).size.width / 7)) /
          2,
      child: Column(
        children: [
          _textStyle(bankName, Colors.black, 15.0, FontWeight.normal,
              TextAlign.center),
          SizedBox(
            height: 10,
          ),
          _textStyle(cardNo, HsgColors.aboutusTextCon, 12.0, FontWeight.normal,
              TextAlign.center),
        ],
      ),
    );
  }

  Widget _transferPlan(int index) {
    planId = transferPlanList[index].planId;
    //判断转账频率
    switch (transferPlanList[index].frequency) {
      case '0':
        frequency = S.current.only_once;
        break;
      case '1':
        frequency = S.current.daily;
        break;
      case '2':
        frequency = S.current.monthly;
        break;
      default:
        frequency = S.current.yearly;
    }
    //判断转账类型
    switch (transferPlanList[index].transferType) {
      case '0':
        transferType = S.current.transfer_type_0;
        break;
      default:
        frequency = S.current.transfer_type_2;
    }
    //根据转账计划的状态改变按钮颜色
    if (transferPlanList[index].status == 'P') {
      btnTitle = S.current.cancel_plan;
      // btnColor = HsgColors.accent;
      // _isColor = true;
      btnColor = Color(0xff1775BA);
      textColor = Colors.white;
      _enableClick = true;
    } else if (transferPlanList[index].status == 'C') {
      btnTitle = S.current.canceled;
      // _isColor = false;
      btnColor = HsgColors.canceledBtn;
      textColor = Colors.white;
      _enableClick = false;
    } else if (transferPlanList[index].status == 'A') {
      btnTitle = S.current.under_review;
      // _isColor = false;
      // btnColor = Color(0xFF48b4ff);
      btnColor = Colors.white;
      textColor = Color(0xFF48b4ff);
      _enableClick = false;
    } else {
      btnTitle = S.current.finished;
      // _isColor = false;
      btnColor = HsgColors.finishedBtn;
      _enableClick = false;
    }
    nextDate = transferPlanList[index].nextDate == null
        ? '--'
        : transferPlanList[index].nextDate;
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        go2Detail(transferPlanList[index]);
      },
      child: Column(
        children: [
          //计划名称
          _planName(transferPlanList[index].planName),
          //付款账户和收款账户
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              children: [
                _bank(
                    transferPlanList[index].payerName,
                    FormatUtil.formatSpace4(
                        transferPlanList[index].payerCardNo)),
                _transferRecordImage('images/transferIcon/transfert_to.png',
                    MediaQuery.of(context).size.width / 7, 25, 25),
                _bank(
                  transferPlanList[index].payeeName,
                  FormatUtil.formatSpace4(
                    transferPlanList[index].payeeCardNo,
                  ),
                ),
              ],
            ),
          ),
          _dottedLine(),
          //转账计划信息
          _planInfo(
            transferPlanList[index].debitCurrency +
                ' ' +
                transferPlanList[index].amount,
            frequency,
            transferPlanList[index].startDate,
            transferPlanList[index].endDate,
            nextDate,
            transferType,
          ),
        ],
      ),
    );
  }

  // //转账计划列表
  // List<Widget> _transferPlanList() {
  //   List<Widget> section = [];
  //   section.add(
  //     SliverToBoxAdapter(
  //       child: _toggleButton(),
  //     ),
  //   );
  //   section.add(
  //     _isDate
  //         ? SliverList(
  //             delegate: SliverChildBuilderDelegate((context, index) {
  //               planId = transferPlanList[index].planId;
  //               //判断转账频率
  //               switch (transferPlanList[index].frequency) {
  //                 case '0':
  //                   frequency = S.current.only_once;
  //                   break;
  //                 case '1':
  //                   frequency = S.current.daily;
  //                   break;
  //                 case '2':
  //                   frequency = S.current.monthly;
  //                   break;
  //                 default:
  //                   frequency = S.current.yearly;
  //               }
  //               //判断转账类型
  //               switch (transferPlanList[index].transferType) {
  //                 case '0':
  //                   transferType = S.current.transfer_type_0;
  //                   break;
  //                 default:
  //                   frequency = S.current.transfer_type_2;
  //               }
  //               //根据转账计划的状态改变按钮颜色
  //               if (transferPlanList[index].status == 'P') {
  //                 btnTitle = S.current.cancel_plan;
  //                 // btnColor = HsgColors.accent;
  //                 _isColor = true;
  //               } else if (transferPlanList[index].status == 'C') {
  //                 btnTitle = S.current.canceled;
  //                 _isColor = false;
  //                 btnColor = HsgColors.canceledBtn;
  //               } else if (transferPlanList[index].status == 'A') {
  //                 btnTitle = S.current.under_review;
  //                 _isColor = false;
  //                 // btnColor = Color(0xFF48b4ff);
  //                 btnColor = Colors.white;
  //                 textColor = Color(0xFF48b4ff);
  //               } else {
  //                 btnTitle = S.current.finished;
  //                 _isColor = false;
  //                 btnColor = HsgColors.finishedBtn;
  //               }
  //               nextDate = transferPlanList[index].nextDate == null
  //                   ? '--'
  //                   : transferPlanList[index].nextDate;
  //               return FlatButton(
  //                 padding: EdgeInsets.all(0),
  //                 onPressed: () {
  //                   go2Detail(transferPlanList[index]);
  //                 },
  //                 child: Column(
  //                   children: [
  //                     //计划名称
  //                     _planName(transferPlanList[index].planName),
  //                     //付款账户和收款账户
  //                     Container(
  //                       color: Colors.white,
  //                       padding: EdgeInsets.only(left: 15, right: 15, top: 15),
  //                       child: Row(
  //                         children: [
  //                           _bank(
  //                               transferPlanList[index].payerName,
  //                               FormatUtil.formatSpace4(
  //                                   transferPlanList[index].payerCardNo)),
  //                           _transferRecordImage(
  //                               'images/transferIcon/transfert_to.png',
  //                               MediaQuery.of(context).size.width / 7,
  //                               25,
  //                               25),
  //                           _bank(
  //                               transferPlanList[index].payeeName,
  //                               FormatUtil.formatSpace4(
  //                                   transferPlanList[index].payeeCardNo)),
  //                         ],
  //                       ),
  //                     ),
  //                     _dottedLine(),
  //                     //转账计划信息
  //                     _planInfo(
  //                         transferPlanList[index].debitCurrency +
  //                             ' ' +
  //                             transferPlanList[index].amount,
  //                         frequency,
  //                         transferPlanList[index].startDate,
  //                         transferPlanList[index].endDate,
  //                         nextDate,
  //                         transferType),
  //                   ],
  //                 ),
  //               );
  //             }, childCount: transferPlanList.length),
  //           )
  //         : SliverToBoxAdapter(
  //             //暂无数据页面
  //             child: Container(
  //               height: MediaQuery.of(context).size.height * 3.5 / 5,
  //               child: notDataContainer(context, S.current.no_data_now),
  //             ),
  //           ),
  //   );
  //   return section;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(S.current.transfer_plan),
        ),
        body: Column(
          children: [
            _toggleButton(),
            Expanded(
              child: _isLoading
                  ? HsgLoading()
                  : transferPlanList.length > 0
                      ? CustomRefresh(
                          controller: _refreshController,
                          onLoading: () {
                            if (_page < _totalPage) {
                              _loadMore = true;
                              _page++;
                              // _isColor = false;
                            }
                            //加载更多完成
                            if (_loadMore) {
                              _getTransferPlanList();
                            } else {
                              //显示没有更多数据
                              _refreshController.loadNoData();
                            }
                          },
                          onRefresh: () {
                            _page = 1;
                            transferPlanList.clear();
                            _getTransferPlanList();
                            //刷新完成
                            _refreshController.refreshCompleted();
                            _refreshController.footerMode.value =
                                LoadStatus.canLoading;
                          },
                          content: ListView.builder(
                            itemCount: transferPlanList.length,
                            itemBuilder: (context, index) {
                              return _transferPlan(index);
                            },
                          ),
                        )
                      : notDataContainer(context, S.current.no_data_now),
            ),
          ],
        )
        // RefreshIndicator(
        //     key: refrestIndicatorKey,
        //     child: CustomScrollView(
        //       slivers: _transferPlanList(),
        //     ),
        //     onRefresh: _getTransferPlanList),
        );
  }

  Future<void> _getTransferPlanList() async {
    _isLoading = true;
    // TransferDataRepository()
    Transfer()
        .getTransferPlanList(
            GetTransferPlanListReq(_page, 10, '', _statusList, '0'))
        .then((value) {
      if (value is GetTransferPlanListResp) {
        if (this.mounted) {
          setState(() {
            if (value.rows != null) {
              _totalPage = value.totalPage;
              // transferPlanList.clear();
              transferPlanList.addAll(value.rows);
            }
            if (transferPlanList.length != 0) {
              _isDate = true;
            } else {
              _isDate = false;
            }
            _isLoading = false;
            _loadMore = false;
            _refreshController.loadComplete();
          });
        }
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

//页面跳转
  void go2Detail(TransferPlan transferPlan) {
    Navigator.pushNamed(context, pageTransferPlanDetails,
        arguments: transferPlan);
  }

  void _cancleTransferPlan() {
    Future.wait({
      // TransferDataRepository()
      Transfer().cancelTransferPlan(CancelTransferPlanReq(planId))
    }).then((data) {
      setState(() {
        _statusList = ['P', 'A'];
        _getTransferPlanList();
      });
    });
  }
}
