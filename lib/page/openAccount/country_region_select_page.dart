/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///  国家地区、区号选择
/// Author: 李家伟
/// Date: 2021-03-18

import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:flutter/material.dart';
// import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';

class CountryOrRegionSelectPage extends StatefulWidget {
  @override
  _CountryOrRegionSelectPageState createState() =>
      _CountryOrRegionSelectPageState();
}

class _CountryOrRegionSelectPageState extends State<CountryOrRegionSelectPage> {
  List<CountryRegionModel> _cityList = List();
  List<CountryRegionModel> _hotCityList = List();

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";
  String _language = Language.ZH_CN;

  @override
  void initState() {
    _initLanguage();
    loadData();
    super.initState();
  }

  _initLanguage() async {
    String language = await Language.getSaveLangage();
    print('language: $language');
    _language = language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).select_country,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: AzListView(
                data: _cityList,
                topData: _hotCityList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                //showCenterTip: false,
              )),
        ],
      ),
    );
  }

  void loadData() async {
    // //获取国家地区类型
    // PublicParametersRepository()
    //     .getIdType(GetIdTypeReq('COUNTRY'), 'GetIdTypeReq')
    //     .then((data) {
    //   if (data.publicCodeGetRedisRspDtoList != null) {
    //     print('COUNTRY-  ${data.publicCodeGetRedisRspDtoList}');
    //   }
    // }).catchError((e) {
    //   Fluttertoast.showToast(msg: e.toString(),gravity: ToastGravity.CENTER,);
    // });

    //加载城市列表
    rootBundle.loadString('assets/data/country.json').then((value) {
      Map countryMap = json.decode(value);
      List list = countryMap['countryLists'];
      list.forEach((value) {
        CountryRegionModel model = CountryRegionModel.fromJson(value);
        _cityList.add(
          model,
        );
        if (['CN', 'HK'].contains(model.countryCode)) {
          //需要新增一个模型，共用后会无法改变tagIndex
          CountryRegionModel modelHot = CountryRegionModel.fromJson(value);
          modelHot.tagIndex = '★';
          _hotCityList.add(modelHot);
        }
      });
      _handleList(_cityList);
      setState(() {
        _suspensionTag = _hotCityList[0].getSuspensionTag();
      });
    });
  }

  void _handleList(List<CountryRegionModel> list) {
    if (list == null || list.isEmpty || _language == null) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = _language == Language.ZH_CN
          ? PinyinHelper.getPinyinE(list[i].nameZhCN)
          : list[i].nameEN;
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }

    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildListItem(CountryRegionModel model) {
    if (_language == null) return Container();
    String name = model.nameEN;
    if (_language == 'zh_cn') {
      name = model.nameZhCN;
    } else if (_language == 'zh_hk') {
      name = model.nameZhHK;
    } else {
      name = model.nameEN;
    }
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? S.of(context).hot_countries : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(name),
            onTap: () {
              print("OnItemClick: $model");
              Navigator.pop(context, model);
            },
          ),
        )
      ],
    );
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? S.of(context).hot_countries : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 35}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }
}
