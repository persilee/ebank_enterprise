import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';

class CountryOrRegionSelectPage extends StatefulWidget {
  @override
  _CountryOrRegionSelectPageState createState() =>
      _CountryOrRegionSelectPageState();
}

class _CountryOrRegionSelectPageState extends State<CountryOrRegionSelectPage> {
  // List<CityInfo> _cityList = List();
  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  //加载城市数据
  void _loadData() async {
    try {
      var value =
          await rootBundle.loadString('lib/data/source/json/countryCode.json');
      List list = json.decode(value);
      list.forEach((value) {
        // _cityList.add(CityInfo(nameZhCN: value['nameZhCN']));
      });
      // _handleList(_cityList);
      setState(() {
        // _cityList = _cityList;
      });
    } catch (e) {
      print(e);
    }
  }

  // //排序
  // void _handleList(List<CityInfo> list) {
  //   if (list == null || list.isEmpty) return;
  //   for (int i = 0, length = list.length; i < length; i++) {
  //     String pinyin = PinyinHelper.getPinyinE(list[i].name);
  //     String tag = pinyin.substring(0, 1).toUpperCase();
  //     list[i].namePinyin = pinyin;
  //     if (RegExp("[A-Z]").hasMatch(tag)) {
  //       list[i].tagIndex = tag;
  //     } else {
  //       list[i].tagIndex = "#";
  //     }
  //   }
  //   //根据A-Z排序
  //   SuspensionUtil.sortListBySuspensionTag(_cityList);
  // }

  //tag更改
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择城市'),
      ),
      body: Column(
        children: <Widget>[
          // ListTile(
          //     title: Text("定位城市"),
          //     trailing: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         Icon(
          //           Icons.place,
          //           size: 20.0,
          //         ),
          //         Text(" 西安市"),
          //       ],
          //     )),
          TextField(),
          Expanded(
            flex: 1,
            child: Text('AzListView'),
            // AzListView(
            //   data: _cityList,
            //   itemCount: _cityList.length,
            //   itemBuilder: (context, model) => _buildListItem(model),
            //   padding: EdgeInsets.zero,
            //   susItemBuilder: (BuildContext context, int index) {
            //     CityInfo model = _cityList[index];
            //     String tag = model.getSuspensionTag();
            //     return getSusItem(context, tag);
            //   },
            //   // indexBarData: ['★', ...kIndexBarData],
            // ),
          ),
        ],
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
