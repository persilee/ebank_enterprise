import 'dart:convert';


import 'package:azlistview/azlistview.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          '选择国家',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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


    //加载城市列表
    rootBundle.loadString('assets/data/country.json').then((value) {
      Map countryMap = json.decode(value);
      List list = countryMap['countryLists'];
      list.forEach((value) {
        _cityList.add(
          CountryRegionModel(
            nameZhCN: value['nameZhCN'],
            nameEN: value['nameEN'],
          ),
        );
      });
      _hotCityList.add(
          CountryRegionModel(nameZhCN: '安哥拉', nameEN: 'Andorra', tagIndex: "★"));
      _hotCityList.add(CountryRegionModel(
          nameZhCN: '阿拉伯', nameEN: 'United Arab Emirates', tagIndex: "★"));
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
    String name = _language == 'zh_cn' ? model.nameZhCN : model.nameEN;
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "热门国家" : susTag);
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
    susTag = (susTag == "★" ? "热门城市" : susTag);
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

  // //自定义头部
  // Widget _buildHeader() {
  //   List<CityInfo> hotCityList = List();
  //   hotCityList.addAll([
  //     CityInfo(name: "北京市"),
  //     CityInfo(name: "上海市"),
  //     CityInfo(name: "广州市"),
  //     CityInfo(name: "深圳市"),
  //     CityInfo(name: "杭州市"),
  //     CityInfo(name: "成都市"),
  //   ]);
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Wrap(
  //       alignment: WrapAlignment.center,
  //       runAlignment: WrapAlignment.center,
  //       spacing: 10.0,
  //       children: hotCityList.map((e) {
  //         return OutlineButton(
  //           borderSide: BorderSide(color: Colors.grey[300], width: .5),
  //           child: Text(e.name),
  //           onPressed: () {
  //             print("OnItemClick: $e");
  //             Navigator.pop(context, e.name);
  //           },
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

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

  // //自定义tag
  // Widget _buildSusWidget(String susTag) {
  //   return Container(
  //     height: _suspensionHeight.toDouble(),
  //     padding: const EdgeInsets.only(left: 15.0),
  //     color: Color(0xfff3f4f5),
  //     alignment: Alignment.centerLeft,
  //     child: Text(
  //       '$susTag',
  //       softWrap: false,
  //       style: TextStyle(
  //         fontSize: 14.0,
  //         color: Color(0xff999999),
  //       ),
  //     ),
  //   );
  // }

  // //自定义item
  // Widget _buildListItem(int index) {
  //   CityInfo model = _cityList[index];
  //   String susTag = model.getSuspensionTag();
  //   return Column(
  //     children: <Widget>[
  //       Offstage(
  //         offstage: model.isShowSuspension != true,
  //         child: _buildSusWidget(susTag),
  //       ),
  //       SizedBox(
  //         height: _itemHeight.toDouble(),
  //         child: ListTile(
  //           title: Text(model.nameZhCN),
  //           onTap: () {
  //             print("OnItemClick: $model");
  //             Navigator.pop(context, model.nameZhCN);
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }
}

// class CityInfo extends ISuspensionBean {
//   String nameEN;
//   String flZh;
//   String code;
//   String countryCode;
//   String flEN;
//   String nameZhCN;
//   String nameZhHK;

//   CityInfo({
//     this.nameEN,
//     this.flZh,
//     this.code,
//     this.countryCode,
//     this.flEN,
//     this.nameZhCN,
//     this.nameZhHK,
//   });

//   CityInfo.fromJson(Map<String, dynamic> json);

//   Map<String, dynamic> toJson() => {
//         'nameEN': nameEN,
//         'flZh': flZh,
//         'code': code,
//         'countryCode': countryCode,
//         'flEN': flEN,
//         'nameZhCN': nameZhCN,
//         'nameZhHK': nameZhHK,
//         'isShowSuspension': isShowSuspension
//       };

//   @override
//   String getSuspensionTag() => code;
// }
