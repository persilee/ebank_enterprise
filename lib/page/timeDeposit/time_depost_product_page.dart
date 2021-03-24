/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期产品列表页面
/// Author: wangluyao
/// Date: 2020-12-11

import 'dart:math';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/time_deposit_data_repository.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/custom_pop_window_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../page_route.dart';

class TimeDepostProduct extends StatefulWidget {
  TimeDepostProduct({Key key}) : super(key: key);

  @override
  _TimeDepostProductState createState() => _TimeDepostProductState();
}

class _TimeDepostProductState extends State<TimeDepostProduct> {
  List<TdepProducHeadDTO> productList = [];
  List<List<TdepProductDTOList>> producDTOList = [];
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String language = Intl.getCurrentLocale();
  String _changedCcy = S.current.hint_please_select;
  String _changedTerm = S.current.hint_please_select;
  double _bal = 0.00;
  TextEditingController inputValue = TextEditingController();
  int page = 1;
  bool _isDate = false;
  List<String> terms = []; //存款期限

  void initState() {
    super.initState();
    _getTerm();
    //下拉刷新
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });

    NotificationCenter.instance.addObserver('timeDepositProduct', (object) {
      setState(() {
        if (object) {
          _loadData();
        }
      });
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
    _bal = (inputValue.text).length == 0 ? 0.00 : double.parse(inputValue.text);
    return Container(
      width: (MediaQuery.of(context).size.width - 56) / 5 * 3,
      child: _textStyle(
          (_bal == 0.00
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
          // FilteringTextInputFormatter.allow(RegExp('[0-9]|\\.|[0-9]')),
          FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
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
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _screenText(S.current.deposit_amount),
            _moneyTextFiled(),
            _screenText(S.current.currency),
            _checkCcyButton(_changedCcy, popcontext),
            _screenText(S.current.deposit_time_limit),
            _checkTermButton(_changedTerm, popcontext),
            _screenBtnRow(popcontext),
            _bottomBox(),
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
    List<String> ccys = [];

    for (List<TdepProductDTOList> dtoList in producDTOList) {
      for (TdepProductDTOList tdProduct in dtoList) {
        bool isContainer = ccys.contains(tdProduct.ccy);
        if (!isContainer) {
          ccys.add(tdProduct.ccy);
        }
      }
    }

    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.currency,
              items: ccys,
            ));
    if (result != null && result != false) {
      setState(() {
        if (result != null && result != false) {
          _changedCcy = ccys[result];
        }
      });
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
      setState(() {
        if (result != null && result != false) {
          _changedTerm = terms[result];
        }
      });
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
          Navigator.of(context).pop();
          print("筛选");
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
          setState(() {
            inputValue.text = '';
            _changedCcy = S.current.hint_please_select;
            _changedTerm = S.current.hint_please_select;
            print("重置");
            (popcontext as Element).markNeedsBuild();
          });
        },
      ),
    );
  }

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

  //弹窗底部
  Widget _bottomBox() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width - 36,
      height: 240,
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
      SliverToBoxAdapter(
        child: _picture(),
      ),
    );
    section.add(
      SliverToBoxAdapter(
        child: _screen(),
      ),
    );
    _isDate
        ? section.add(
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
                            name,
                            minRate,
                            maxRate,
                            tdepProductList[index].remark,
                            tdepProductList[index].minAmt),
                      ),
                    ],
                  ),
                );
              }, childCount: tdepProductList.length),
            ),
          )
        : section.add(
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 100),
                child: notDataContainer(context, S.current.no_data_now),
              ),
            ),
          );
    return section;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.time_deposit),
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
      body: RefreshIndicator(
          key: refrestIndicatorKey,
          child: Container(
            color: HsgColors.commonBackground,
            child: CustomScrollView(
              slivers: _titleSection(productList, producDTOList),
            ),
          ),
          //下拉刷新时调用_loadData
          onRefresh: _loadData),
    );
  }

// String accuPeriod, String auctCale, String ccy, double minAmt, int page, int pageSize, String sort
  Future<void> _loadData() async {
    TimeDepositDataRepository()
        .getGetTimeDepositProduct('getGetTimeDepositProduct',
            TimeDepositProductReq('', '', '', null, page, 10, ''))
        .then((data) {
      if (data.length != 0) {
        _isDate = true;
        setState(() {
          productList.clear();
          producDTOList.clear();
          data.forEach((element) {
            productList.add(element.tdepProducHeadDTO);
            producDTOList.add(element.tdepProductDTOList);
          });
        });
      } else {
        _isDate = false;
      }
    }).catchError(() {
      Fluttertoast.showToast(msg: "${e.toString()}");
    });
  }

  //获取存款期限列表
  Future _getTerm() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("AUCT"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        data.publicCodeGetRedisRspDtoList.forEach((element) {
          setState(() {
            if (language == 'zh_CN') {
              terms.add(element.cname);
            } else {
              terms.add(element.name);
            }
          });
        });
      }
    });
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
}
