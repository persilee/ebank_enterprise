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

  void initState() {
    super.initState();
    //下拉刷新
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderSide _lineBorderSide() {
      return BorderSide(
        // 设置单侧边框的样式
        color: HsgColors.divider,
        width: 0.5,
        style: BorderStyle.solid,
      );
    }

    //定期产品列表
    List<Widget> _titleSection(List<TdepProducHeadDTO> tdepProductList,
        List<List<TdepProducDTOList>> tdepProducDTOList) {
      List<Widget> section = [];
      section.add(
        //定期产品列表上面的图片
        SliverToBoxAdapter(
          child: Image.asset(
            'images/time_depost/time_depost_product.png',
            width: 500.0,
            height: 120.0,
            fit: BoxFit.cover,
          ),
        ),
      );
      section.add(SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        //最小年利率
        double minRate = double.parse(tdepProductList[index].minRate) * 100;
        minRate = double.parse(FormatUtil.formatNum(minRate, 2));
        //最大年利率
        double maxRate = double.parse(tdepProductList[index].maxRate) * 100;
        maxRate = double.parse(FormatUtil.formatNum(maxRate, 2));
        //判断选择的语言并根据语言选择产品名称
        String name;
        String language = Intl.getCurrentLocale();
        if (language == 'zh_CN') {
          name = tdepProductList[index].lclName;
        } else {
          name = tdepProductList[index].engName;
        }
        //定期产品信息
        return FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            print('>>>>>>$tdepProducDTOList $tdepProductList');
            go2Detail(tdepProductList[index], tdepProducDTOList[index]);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: HsgColors.commonBackground,
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                //边框设置
                decoration: BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周边框
                  border: Border(
                    top: _lineBorderSide(),
                    bottom: _lineBorderSide(),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        //定期产品名称
                        '$name',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Divider(height: 0.5, color: HsgColors.divider),
                    Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            //定期产品年利率
                            '$minRate%~$maxRate%',
                            style:
                                TextStyle(fontSize: 17, color: Colors.red[500]),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 30) /
                                2 *
                                1,
                            child: Text(
                              //定期产品描述
                              tdepProductList[index].remark,
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
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 0.0),
                      height: 30.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 70,
                            child: Text(
                              S.current.annual_interest_rate,
                              style: TextStyle(
                                fontSize: 13,
                                color: HsgColors.describeText,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 30) /
                                2 *
                                1,
                            height: 70,
                            child: Text(
                              //定期产品起存金额
                              language == 'zh_CN'
                                  ? '${tdepProductList[index].minAmt}' +
                                      S.current.deposit_min_with_value
                                  : S.current.deposit_min_with_value +
                                      '${tdepProductList[index].minAmt}',
                              style: TextStyle(
                                fontSize: 13,
                                color: HsgColors.describeText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }, childCount: tdepProductList.length)));
      return section;
    }

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
                      debugPrint("我的存单");
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

  void go2Detail(TdepProducHeadDTO tdepProduct,
      List<TdepProducDTOList> tdepProducDTOList) {
    Navigator.popAndPushNamed(
      context,
      pageTimeDepositContract,
      arguments: {
        'tdepProduct': tdepProduct,
        'tdepProducDTOList': tdepProducDTOList
      },
    );
  }
}
