/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///提交定期产品列表页面
/// Author: wangluyao
/// Date: 2020-12-11

import 'dart:math';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/time_deposit_data_repository.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
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
  List<List<TdepProducDTOList>> producDTOList = [];
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String language = Intl.getCurrentLocale();

  void initState() {
    super.initState();
    //下拉刷新
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
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
      width: 500.0,
      height: 120.0,
      fit: BoxFit.cover,
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
            style: TextStyle(fontSize: 17, color: Colors.red[500]),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 30) / 2 * 1,
            child: Text(
              //定期产品描述
              remark,
              style: TextStyle(
                fontSize: 15,
                color: HsgColors.firstDegreeText,
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
          color: HsgColors.describeText,
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
          color: HsgColors.describeText,
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
      List<List<TdepProducDTOList>> tdepProducDTOList) {
    List<Widget> section = [];
    section.add(
      SliverToBoxAdapter(
        child: _picture(),
      ),
    );
    section.add(
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          //最小年利率
          double minRate = double.parse(tdepProductList[index].minRate) * 100;
          minRate = double.parse(FormatUtil.formatNum(minRate, 2));
          //最大年利率
          double maxRate = double.parse(tdepProductList[index].maxRate) * 100;
          maxRate = double.parse(FormatUtil.formatNum(maxRate, 2));
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
              child: Text.rich(TextSpan(
                  text: S.current.deposit_record,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 3.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, pageTimeDepositRecord);
                    })),
            )
          ],
        ),
        body: RefreshIndicator(
            key: refrestIndicatorKey,
            child: CustomScrollView(
              slivers: _titleSection(productList, producDTOList),
            ),
            //下拉刷新时调用_loadData
            onRefresh: _loadData));
  }

  Future<void> _loadData() async {
    TimeDepositDataRepository()
        .getGetTimeDepositProduct('getGetTimeDepositProduct')
        .then((data) {
      productList.clear();
      producDTOList.clear();
      data.forEach((element) {
        productList.add(element.tdepProducHeadDTO);
        producDTOList.add(element.tdepProductDTOList);
      });
      setState(() {});
    }).catchError(() {
      Fluttertoast.showToast(msg: "${e.toString()}");
    });
  }

//页面跳转传值
  void go2Detail(TdepProducHeadDTO tdepProduct,
      List<TdepProducDTOList> tdepProducDTOList) {
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
