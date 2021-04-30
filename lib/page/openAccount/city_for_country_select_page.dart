// Copyright (c) 2021 深圳高阳寰球科技有限公司
//
// Author: 李家伟
// Date: 2021-04-17

import 'package:azlistview/azlistview.dart';
import 'package:ebank_mobile/data/source/model/city_for_country.dart';
import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/widget/hsg_error_page.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpinyin/lpinyin.dart';

class CityForCountrySelectPage extends StatefulWidget {
  final CountryRegionNewModel countryData;
  CityForCountrySelectPage({Key key, this.countryData}) : super(key: key);

  @override
  _CityForCountrySelectPageState createState() =>
      _CityForCountrySelectPageState();
}

class _CityForCountrySelectPageState extends State<CityForCountrySelectPage> {
  List<CityForCountryModel> _cityList = List();
  List<CityForCountryModel> _hotCityList = List();
  bool _isLoading = false;
  bool _isShowErrorPage = false;
  Widget _hsgErrorPage;

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";
  String _language = Language.ZH_CN;
  String _navTitleStr = '';

  @override
  void initState() {
    _initLanguage();
    _loadData();
    super.initState();
  }

  _initLanguage() async {
    String language = await Language.getSaveLangage();
    _language = language;

    switch (language) {
      case Language.ZH_CN:
        _navTitleStr = widget.countryData.cntyCnm;
        break;
      case Language.ZH_HK:
        _navTitleStr = widget.countryData.cntyTcnm;
        break;
      default:
        _navTitleStr = widget.countryData.cntyNm;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget contentListView = Column(
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
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // S.of(context).select_country,
          _navTitleStr,
        ),
      ),
      body: _isLoading
          ? HsgLoading()
          : _cityList != null && _cityList.length > 0
              ? contentListView
              : HsgErrorPage(
                  isEmptyPage: true,
                  buttonAction: () {
                    _loadData();
                  },
                ),
    );
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });
    ApiClientOpenAccount()
        .getCntAllBpCtCit(
            CityForCountryListReq(widget.countryData.cntyCd ?? ''))
        .then((data) {
      setState(() {
        _isLoading = false;
        _isShowErrorPage = false;
      });
      if (data != null &&
          data.bpCtCitRspDTOS != null &&
          data.bpCtCitRspDTOS.length > 0) {
        List list = data.bpCtCitRspDTOS;
        list.forEach((value) {
          CityForCountryModel model = value;
          _cityList.add(
            model,
          );
        });
        _handleList(_cityList);
        setState(() {
          if (_hotCityList != null && _hotCityList.length > 0) {
            _suspensionTag = _hotCityList[0].getSuspensionTag();
          } else if (_cityList != null && _cityList.length > 0) {
            _suspensionTag = _cityList[0].getSuspensionTag();
          }
        });
      }
    }).catchError((e) {
      if (e is NeedLogin) {
      } else {
        _hsgErrorPage = HsgErrorPage(
          error: e.error,
          buttonAction: () {
            _loadData();
          },
        );
      }

      setState(() {
        _isLoading = false;
        _isShowErrorPage = true;
      });
    });
  }

  void _handleList(List<CityForCountryModel> list) {
    if (list == null || list.isEmpty || _language == null) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin;

      switch (_language) {
        case Language.ZH_CN:
          pinyin = PinyinHelper.getPinyinE(list[i].cityCnm);
          break;
        case Language.ZH_HK:
          pinyin = PinyinHelper.getPinyinE(list[i].cityCnm);
          break;
        default:
          pinyin = PinyinHelper.getPinyinE(list[i].cityNm);
      }
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

  Widget _buildListItem(CityForCountryModel model) {
    if (_language == null) return Container();
    String name;
    if (_language == 'zh_cn') {
      name = model.cityCnm;
    } else if (_language == 'zh_hk') {
      name = model.cityCnm;
    } else {
      name = model.cityNm;
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
              Map popMap = {
                'countryModel': widget.countryData,
                'cityModel': model,
              };
              Navigator.of(context)..pop()..pop(popMap);
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
}
