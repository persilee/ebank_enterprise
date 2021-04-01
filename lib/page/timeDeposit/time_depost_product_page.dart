/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期产品列表页面
/// Author: wangluyao
/// Date: 2020-12-11

import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/time_deposit_data_repository.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/custom_pop_window_button.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../page_route.dart';

class TimeDepostProduct extends StatefulWidget {
  TimeDepostProduct({Key key}) : super(key: key);

  @override
  _TimeDepostProductState createState() => _TimeDepostProductState();
}

class _TimeDepostProductState extends State<TimeDepostProduct> {
  List<TdepProducHeadDTO> productList = []; //产品（大类）
  List<List<TdepProductDTOList>> producDTOList = []; //子产品
  // var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String language = Intl.getCurrentLocale();
  String _changedCcy = S.current.hint_please_select; //筛选币种
  String _changedTerm = S.current.hint_please_select; //筛选存期
  double _bal = 0.0; //筛选金额
  TextEditingController inputValue = TextEditingController();
  int page = 1;
  bool _isDate = false; //判断是否有数据
  List<String> terms = []; //存款期限
  List<String> termCodes = []; //存款期限代码
  String _accuPeriod = ''; //计提周期
  String _auctCale = ''; //档期
  List<String> ccyList = []; //币种列表
  bool _isLoading = false; //加载状态
  RefreshController _refreshController;

  void initState() {
    super.initState();
    _getTerm(); //获取存款期限列表
    _refreshController = RefreshController();
    _loadData(); //获取定期产品列表
    //下拉刷新
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   refrestIndicatorKey.currentState.show();
    // });

    NotificationCenter.instance.addObserver('timeDepositProduct', (object) {
      if (this.mounted) {
        setState(() {
          if (object) {
            _loadData(); //获取定期产品列表
          }
        });
      }
    });
  }

//背景
  Widget _background() {
    return Container(
      color: HsgColors.commonBackground,
      height: 15,
    );
  }

// 设置单侧边框的样式
  BorderSide _lineBorderSide() {
    return BorderSide(
      color: HsgColors.divider,
      width: 0.5,
      style: BorderStyle.solid,
    );
  }

  //定期产品列表上面的图片
  Widget _picture() {
    return Image.asset(
      'images/time_depost/time_depost_product.png',
      width: MediaQuery.of(context).size.width,
      height: 120.0,
      fit: BoxFit.cover,
    );
  }

  //右箭头图标
  Widget _rightArrow(Color color) {
    return Container(
      width: 20,
      child: Icon(
        Icons.arrow_drop_down,
        color: color,
      ),
    );
  }

//筛选条件文本
  Widget _condition() {
    return Container(
      width: (MediaQuery.of(context).size.width - 56) / 5 * 2,
      child: Text(
        S.current.screening_conditions,
        style: TextStyle(fontSize: 13),
      ),
    );
  }

//选择的筛选条件
  Widget _checked() {
    _bal = (inputValue.text).length == 0 ? 0.0 : double.parse(inputValue.text);
    return Container(
      width: (MediaQuery.of(context).size.width - 56) / 5 * 3,
      child: _textStyle(
          (_bal == 0.0
                  ? ""
                  : FormatUtil.formatSringToMoney(_bal.toString()) + "  ") +
              (_changedCcy == S.current.hint_please_select
                  ? ""
                  : _changedCcy + "  ") +
              (_changedTerm == S.current.hint_please_select
                  ? ""
                  : _changedTerm),
          HsgColors.aboutusTextCon,
          13,
          TextAlign.right),
    );
  }

//筛选条件title
  Widget _screenTitle() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: _lineBorderSide(),
          ),
        ),
        padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
        child: Row(
          children: [
            _condition(),
            _checked(),
            _rightArrow(HsgColors.nextPageIcon)
          ],
        ));
  }

  //筛选文本
  Widget _screenText(String text) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width - 36,
      child: Text(
        text,
        style: TRANSFER_RECORD_POP_TEXT_STYLE,
      ),
    );
  }

  //文本
  Widget _textStyle(
      String text, Color color, double fontSize, TextAlign textAlign) {
    return Text(
      text,
      style: TextStyle(
          color: color, fontSize: fontSize, fontWeight: FontWeight.normal),
      textAlign: textAlign,
    );
  }

//存入金额输入框
  Widget _moneyTextFiled() {
    return Container(
      color: Colors.white,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: inputValue,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 13, color: HsgColors.aboutusTextCon),
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          fillColor: HsgColors.inputBackground,
          filled: true,
          enabledBorder: null,
          disabledBorder: null,
          hintText: S.current.please_input,
          hintStyle: TextStyle(
            color: HsgColors.hintText,
            fontSize: 13.0,
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
          // FilteringTextInputFormatter.allow(RegExp('[0-9]|\\.|[0-9]')),
          // FilteringTextInputFormatter.allow(
          //     RegExp('([1-9]\d*\.?\d*)|(0\.?\d*[1-9])?')),
        ],
        onChanged: (value) {
          // double.parse(value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1'));
          // _bal = double.parse(value);
        },
      ),
    );
  }

//选择条件框
  Widget _selectionBox(BuildContext popcontext) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
      height: 300.0,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _screenText(S.current.deposit_amount),
            _moneyTextFiled(),
            _screenText(S.current.currency),
            _checkCcyButton(_changedCcy, popcontext),
            _screenText(S.current.deposit_time_limit),
            _checkTermButton(_changedTerm, popcontext),
            _screenBtnRow(popcontext),
          ],
        ),
      ),
    );
  }

//币种选择按钮
  Widget _checkCcyButton(String name, BuildContext popcontext) {
    return Container(
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width - 36,
      height: 40,
      decoration: BoxDecoration(
        color: HsgColors.inputBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        padding: EdgeInsets.only(left: 10, right: 10),
        borderSide: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 76,
              child: _textStyle(
                  name,
                  name == S.current.hint_please_select
                      ? HsgColors.hintText
                      : HsgColors.aboutusTextCon,
                  13,
                  TextAlign.left),
            ),
            _rightArrow(HsgColors.iconColor),
          ],
        ),
        onPressed: () {
          _selectCcy(popcontext);
        },
      ),
    );
  }

  //存期选择按钮
  Widget _checkTermButton(String name, BuildContext popcontext) {
    return Container(
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width - 36,
      height: 40,
      decoration: BoxDecoration(
        color: HsgColors.inputBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        padding: EdgeInsets.only(left: 10, right: 10),
        borderSide: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 76,
              child: _textStyle(
                  name,
                  name == S.current.hint_please_select
                      ? HsgColors.hintText
                      : HsgColors.aboutusTextCon,
                  13,
                  TextAlign.left),
            ),
            _rightArrow(HsgColors.iconColor),
          ],
        ),
        onPressed: () {
          _selectTerm(popcontext);
        },
      ),
    );
  }

//币种弹窗
  _selectCcy(BuildContext popcontext) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.currency,
              items: ccyList,
            ));
    if (result != null && result != false) {
      if (this.mounted) {
        setState(() {
          if (result != null && result != false) {
            _changedCcy = ccyList[result];
          }
        });
      }

      (popcontext as Element).markNeedsBuild();
    }
  }

  //存期弹窗
  _selectTerm(BuildContext popcontext) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.deposit_time_limit,
              items: terms,
            ));
    if (result != null && result != false) {
      if (this.mounted) {
        setState(() {
          if (result != null && result != false) {
            _changedTerm = terms[result];
            _judge(termCodes[result]);
          }
        });
      }

      (popcontext as Element).markNeedsBuild();
    }
  }

//筛选按钮
  Widget _screenButton() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
      width: 72,
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
          S.of(context).confirm,
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
        onPressed: () {
          if (this.mounted) {
            setState(() {
              _loadData();
            });
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  //重置按钮
  Widget _resetButton(BuildContext popcontext) {
    return Container(
      width: 72,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HsgColors.plainBtn, width: 0.5),
        borderRadius: BorderRadius.circular((5)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Text(
          S.of(context).reset,
          style: TextStyle(
            fontSize: 13,
            color: HsgColors.plainBtn,
          ),
        ),
        onPressed: () {
          if (this.mounted) {
            setState(() {
              inputValue.text = '';
              _changedCcy = S.current.hint_please_select;
              _changedTerm = S.current.hint_please_select;
              _accuPeriod = '';
              _auctCale = '';
              (popcontext as Element).markNeedsBuild();
              _loadData();
            });
          }
        },
      ),
    );
  }

//筛选框按钮行
  Widget _screenBtnRow(BuildContext popcontext) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: _resetButton(popcontext),
          ),
          Container(
            child: _screenButton(),
          ),
        ],
      ),
    );
  }

  //顶部弹窗
  Widget _screen() {
    return CustomPopupWindowButton(
      offset: Offset(MediaQuery.of(context).size.width / 2.3, 200),
      buttonBuilder: (BuildContext context) {
        return GestureDetector(
          child: _screenTitle(),
        );
      },
      windowBuilder: (BuildContext popcontext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: _selectionBox(popcontext),
          ),
        );
      },
    );
  }

  //定期产品名称
  Widget _productName(String productName) {
    return Container(
      height: 40.0,
      alignment: Alignment.centerLeft,
      child: Text(
        productName,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  //定期产品年利率
  Widget _rateAndRemark(double minRate, double maxRate, String remark) {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            //定期产品年利率
            '$minRate%~$maxRate%',
            style: TextStyle(fontSize: 17, color: HsgColors.redText),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 30) / 2 * 1,
            child: Text(
              //定期产品描述
              remark,
              style: TextStyle(
                fontSize: 15,
                color: HsgColors.aboutusTextCon,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  //年利率文本
  Widget _rateText() {
    return SizedBox(
      height: 70,
      child: Text(
        S.current.annual_interest_rate,
        style: TextStyle(
          fontSize: 13,
          color: HsgColors.secondDegreeText,
        ),
      ),
    );
  }

  //起存金额
  Widget _minAmt(String minAmt) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 30) / 2 * 1,
      height: 70,
      child: Text(
        //定期产品起存金额
        language == 'zh_CN'
            ? minAmt + S.current.deposit_min_with_value
            : S.current.deposit_min_with_value + minAmt,
        style: TextStyle(
          fontSize: 13,
          color: HsgColors.secondDegreeText,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //定期产品信息
  Widget _productInfo(String name, double minRate, double maxRate,
      String remark, String minAmt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _productName(name),
        Divider(height: 0.5, color: HsgColors.divider),
        _rateAndRemark(minRate, maxRate, remark),
        Container(
          padding: EdgeInsets.only(top: 0.0),
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _rateText(),
              _minAmt(minAmt),
            ],
          ),
        ),
      ],
    );
  }

  //定期产品列表
  List<Widget> _titleSection(List<TdepProducHeadDTO> tdepProductList,
      List<List<TdepProductDTOList>> tdepProducDTOList) {
    List<Widget> section = [];

    section.add(
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          //最小年利率
          double minRate = double.parse(FormatUtil.formatNum(
              double.parse(tdepProductList[index].minRate), 2));
          //最大年利率
          double maxRate = double.parse(FormatUtil.formatNum(
              double.parse(tdepProductList[index].maxRate), 2));
          //判断选择的语言并根据语言选择产品名称
          String name;
          if (language == 'zh_CN') {
            name = tdepProductList[index].lclName;
          } else {
            name = tdepProductList[index].engName;
          }
          //定期产品信息
          return FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              go2Detail(tdepProductList[index], tdepProducDTOList[index]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _background(),
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: _lineBorderSide(),
                      bottom: _lineBorderSide(),
                    ),
                  ),
                  child: _productInfo(
                      name, //产品名称
                      minRate, //最小利率
                      maxRate, //最大利率
                      tdepProductList[index].remark, //产品描述
                      tdepProductList[index].minAmt), //起存金额
                ),
              ],
            ),
          );
        }, childCount: tdepProductList.length),
      ),
    );
    return _isDate ? section : notDataContainer(context, S.current.no_data_now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.time_deposit),
        elevation: 1,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(top: language == 'zh_CN' ? 17.5 : 12),
            width: (MediaQuery.of(context).size.width - 36) / 4,
            margin: EdgeInsets.only(right: 18),
            child: Text.rich(
              TextSpan(
                  text: S.current.deposit_record,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, pageTimeDepositRecord);
                    }),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: HsgColors.commonBackground,
          child: Column(
            children: [
              _picture(),
              _screen(),
              Expanded(
                child: _isLoading
                    ? HsgLoading()
                    : productList.length > 0
                        ? CustomRefresh(
                            controller: _refreshController,
                            onLoading: () {
                              //加载更多完成
                              _refreshController.loadComplete();
                              //显示没有更多数据
                              // _refreshController.loadNoData();
                            },
                            onRefresh: () {
                              //刷新完成
                              _refreshController.refreshCompleted();
                              _refreshController.footerMode.value =
                                  LoadStatus.canLoading;
                            },
                            content: Container(
                              child: CustomScrollView(
                                slivers: _titleSection(
                                    productList, producDTOList), //产品列表
                              ),
                            ),
                          )
                        : notDataContainer(context, S.current.no_data_now),
              ),
            ],
          ),
        ),
      ),
    );
  }

//获取定期产品列表
  Future<void> _loadData() async {
    _isLoading = true;
    TimeDepositDataRepository()
        .getGetTimeDepositProduct(
            'getGetTimeDepositProduct',
            TimeDepositProductReq(
                _accuPeriod == '' ? null : _accuPeriod,
                _auctCale == '' ? null : _auctCale,
                _changedCcy == S.current.hint_please_select
                    ? null
                    : _changedCcy,
                _bal == 0.0 ? null : _bal,
                page,
                10,
                ''))
        .then((data) {
      if (data.length != 0) {
        // List ccys = [];
        _isDate = true;
        if (this.mounted) {
          setState(() {
            productList.clear();
            producDTOList.clear();
            data.forEach((element) {
              productList.add(element.tdepProducHeadDTO);
              producDTOList.add(element.tdepProductDTOList);
              element.tdepProductDTOList.forEach((data) {
                // ccys.add(data.ccy);
                bool isContainer = ccyList.contains(data.ccy);
                if (!isContainer) {
                  ccyList.add(data.ccy);
                }
              });
            });
            _isLoading = false;
          });
        }
      } else {
        _isDate = false;
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: "${e.toString()}");
      inputValue.text = '';
      _changedCcy = S.current.hint_please_select;
      _changedTerm = S.current.hint_please_select;
      _bal = 0.0;
      _accuPeriod = '';
      _auctCale = '';
      (context as Element).markNeedsBuild();
      // _loadData();
    });
  }

  //获取存款期限列表
  Future _getTerm() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("AUCT"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        data.publicCodeGetRedisRspDtoList.forEach((element) {
          if (this.mounted) {
            setState(() {
              if (language == 'zh_CN') {
                terms.add(element.cname);
              } else {
                terms.add(element.name);
              }
              termCodes.add(element.code);
            });
          }
        });
      }
    });
  }

  //根据存期判断计提周期和档期
  _judge(String code) {
    switch (code) {
      case 'D001':
        _accuPeriod = '1';
        _auctCale = '1';
        break;
      case 'D007':
        _accuPeriod = '1';
        _auctCale = '7';
        break;
      case 'M001':
        _accuPeriod = '2';
        _auctCale = '1';
        break;
      case 'M002':
        _accuPeriod = '2';
        _auctCale = '2';
        break;
      case 'M003':
        _accuPeriod = '2';
        _auctCale = '3';
        break;
      case 'M004':
        _accuPeriod = '2';
        _auctCale = '4';
        break;
      case 'M005':
        _accuPeriod = '2';
        _auctCale = '5';
        break;
      case 'M006':
        _accuPeriod = '2';
        _auctCale = '6';
        break;
      case 'M007':
        _accuPeriod = '2';
        _auctCale = '7';
        break;
      case 'M008':
        _accuPeriod = '2';
        _auctCale = '8';
        break;
      case 'M009':
        _accuPeriod = '2';
        _auctCale = '9';
        break;
      case 'M010':
        _accuPeriod = '2';
        _auctCale = '10';
        break;
      case 'M011':
        _accuPeriod = '2';
        _auctCale = '11';
        break;
      case 'M015':
        _accuPeriod = '2';
        _auctCale = '15';
        break;
      case 'Y001':
        _accuPeriod = '5';
        _auctCale = '1';
        break;
      case 'Y002':
        _accuPeriod = '5';
        _auctCale = '2';
        break;
      case 'Y003':
        _accuPeriod = '5';
        _auctCale = '3';
        break;
      case 'Y004':
        _accuPeriod = '5';
        _auctCale = '4';
        break;
      case 'Y005':
        _accuPeriod = '5';
        _auctCale = '5';
        break;
      case 'Y006':
        _accuPeriod = '5';
        _auctCale = '6';
        break;
    }
  }

//页面跳转传值
  void go2Detail(TdepProducHeadDTO tdepProduct,
      List<TdepProductDTOList> tdepProducDTOList) {
    Navigator.pushNamed(
      context,
      pageTimeDepositContract,
      arguments: {
        'tdepProduct': tdepProduct,
        'tdepProducDTOList': tdepProducDTOList
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }
}
