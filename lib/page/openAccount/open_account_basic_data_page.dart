/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 快速开户-基本信息录入
/// Author: 李家伟
/// Date: 2021-03-17

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class OpenAccountBasicDataPage extends StatefulWidget {
  @override
  _OpenAccountBasicDataPageState createState() =>
      _OpenAccountBasicDataPageState();
}

class _OpenAccountBasicDataPageState extends State<OpenAccountBasicDataPage> {
  /// 公司名称（英文）输入值
  String _companyNameEngText = '';

  /// 公司名称（中文）输入值
  String _companyNameCNText = '';

  /// 登记证件类型选择值
  String _documentTypeText = '';

  /// 登记证件号码输入值
  String _documentNumberText = '';

  /// 公司类别选择值
  String _companyTypeText = '';

  /// 公司类别（其他）输入值
  String _companyTypeOtherText = '';

  /// 注册国家地区选择值
  String _countryOrRegionText = '';

  /// 商业/行业性质选择值
  String _industrialNatureText = '';

  /// 是否显示公司类别（其他）输入框
  bool _isShowCompanyTypeOther = false;

  /// 下一步按钮是否能点击
  bool _nextBtnEnabled = true; //false;

  ///公司名称（英文）输入监听
  TextEditingController _companyNameEngTEC = TextEditingController();

  ///公司名称（中文）输入监听
  TextEditingController _companyNameCNTEC = TextEditingController();

  ///登记证件号码输入监听
  TextEditingController _documentNumberTEC = TextEditingController();

  ///公司类别（其他）输入监听
  TextEditingController _companyTypeOtherTEC = TextEditingController();

  ///登记注册文件请求类型
  List<IdType> _documentTypes = [];

  ///公司类别请求类型
  List<IdType> _companyTypes = [];

  ///商业行业性质请求类型
  List<IdType> _industrialNatures = [];

  @override
  void initState() {
    _companyNameEngTEC.addListener(() {
      _companyNameEngText = _companyNameEngTEC.text;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _companyNameCNTEC.addListener(() {
      _companyNameCNText = _companyNameCNTEC.text;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _documentNumberTEC.addListener(() {
      _documentNumberText = _documentNumberTEC.text;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _companyTypeOtherTEC.addListener(() {
      _companyTypeOtherText = _companyTypeOtherTEC.text;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });

    _getPublicParameters();
    super.initState();
  }

  @override
  void dispose() {
    _companyNameEngTEC.dispose();
    _companyNameCNTEC.dispose();
    _companyTypeOtherTEC.dispose();
    _companyTypeOtherTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(S.of(context).openAccout_basicInformation),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF0018EB),
              Color(0xFF01C1D9),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: HsgColors.commonBackground,
          child: ListView(
            children: [
              _inputViewWidget(context),
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: HsgButton.button(
                  title: S.of(context).next_step,
                  click: _nextBtnEnabled
                      ? () {
                          Navigator.pushNamed(
                              context, pageOpenAccountContactInformation);
                        }
                      : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///判断下一步按钮是否能点击
  bool _judgeButtonIsEnabled() {
    if (_companyNameEngText == null || _companyNameEngText == '') {
      return false;
    }
    if (_companyNameCNText == null || _companyNameCNText == '') {
      return false;
    }
    if (_documentTypeText == null || _documentTypeText == '') {
      return false;
    }
    if (_documentNumberText == null || _documentNumberText == '') {
      return false;
    }
    if (_companyTypeText == null || _companyTypeText == '') {
      return false;
    }
    if (_isShowCompanyTypeOther == true &&
        (_companyTypeOtherText == null || _companyTypeOtherText == '')) {
      return false;
    }
    if (_countryOrRegionText == null || _countryOrRegionText == '') {
      return false;
    }
    if (_industrialNatureText == null || _industrialNatureText == '') {
      return false;
    }
    return true;
  }

  Widget _inputViewWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 15, right: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              S.of(context).openAccout_basicInformation,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HsgColors.secondDegreeText,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            child: _twoLayerInputWidget(
              context,
              S.of(context).openAccount_companyNameEng,
              S.of(context).openAccount_companyNameEng_placeholder,
              _companyNameEngTEC,
              false,
              120,
              TextInputType.text,
            ),
          ),
          Container(
            child: _twoLayerInputWidget(
              context,
              S.of(context).openAccount_companyNameCN,
              S.of(context).openAccount_companyNameCN_placeholder,
              _companyNameCNTEC,
              false,
              60,
              TextInputType.text,
            ),
          ),
          Container(
            child: _oneLayerSelectWidget(
              context,
              S.of(context).openAccount_ocumentType,
              _documentTypeText,
              S.of(context).please_select,
              false,
              () {
                print('登记证件类型');
                _selectDocumentType(context);
              },
            ),
          ),
          Container(
            child: _oneLayerInputWidget(
              context,
              S.of(context).openAccount_documentNumber,
              S.of(context).openAccount_documentNumber_placeholder,
              _documentNumberTEC,
              false,
              1004,
            ),
          ),
          Container(
            child: _oneLayerSelectWidget(
              context,
              S.of(context).openAccount_companyType,
              _companyTypeText,
              S.of(context).please_select,
              false,
              () {
                print('公司类别');
                _selectCompanyType(context);
              },
            ),
          ),
          _isShowCompanyTypeOther == true
              ? Container(
                  child: _twoLayerInputWidget(
                    context,
                    S.of(context).openAccount_companyType_other,
                    S.of(context).openAccount_companyType_other_placeholder,
                    _companyTypeOtherTEC,
                    false,
                    120,
                    TextInputType.text,
                  ),
                )
              : Container(),
          Container(
            child: _oneLayerSelectWidget(
              context,
              S.of(context).openAccount_RegistrationCountryRegion,
              _countryOrRegionText,
              S.of(context).please_select,
              false,
              () {
                print('注册国家/地区');
                Navigator.pushNamed(context, countryOrRegionSelectPage)
                    .then((value) {
                  setState(() {
                    _countryOrRegionText = (value as CountryRegionModel).nameEN;
                    _nextBtnEnabled = _judgeButtonIsEnabled();
                  });
                });
              },
            ),
          ),
          Container(
            child: _oneLayerSelectWidget(
              context,
              S.of(context).openAccount_industryNature,
              _industrialNatureText,
              S.of(context).please_select,
              false,
              () {
                print('商业/行业性质');
                _selectIndustrialNature(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoLayerInputWidget(
    BuildContext context,
    String titleStr,
    String placeholderStr,
    TextEditingController textEdiC,
    bool isHiddenLine,
    int maxLength,
    TextInputType keyboardType,
  ) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width - 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              titleStr, //titleStr
              style: TextStyle(
                color: HsgColors.firstDegreeText,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            height: 60,
            child: TextField(
              //是否自动更正
              autocorrect: false,
              //是否自动获得焦点
              autofocus: false,
              controller: textEdiC,
              keyboardType: keyboardType,
              textAlign: TextAlign.end,
              // textAlignVertical: TextAlignVertical.top,
              // textDirection: TextDirection.ltr,
              maxLines: 2,
              // maxLength: maxLength,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(maxLength) //限制长度
              ],
              style: TextStyle(
                fontSize: 15,
                color: HsgColors.firstDegreeText,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholderStr,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
          isHiddenLine == true
              ? Divider()
              : Divider(
                  height: 0.5,
                  color: HsgColors.lineColor,
                ),
        ],
      ),
    );
  }

  Widget _oneLayerInputWidget(
    BuildContext context,
    String titleStr,
    String placeholderStr,
    TextEditingController textEdiC,
    bool isHiddenLine,
    int textFieldTag,
  ) {
    final size = MediaQuery.of(context).size;

    Widget _inputWidget() {
      return Container(
        width: size.width - 30,
        height: 50,
        child: Row(
          children: [
            Container(
              width: 120,
              child: Text(
                titleStr,
                maxLines: 2,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              height: 50,
              width: size.width - 30 - 125,
              margin: EdgeInsets.only(left: 5),
              child: TextField(
                //是否自动更正
                autocorrect: false,
                //是否自动获得焦点
                autofocus: false,
                controller: textEdiC,
                // obscureText: this.isCiphertext,
                textAlign: TextAlign.right,
                // textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 15,
                  color: HsgColors.firstDegreeText,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: placeholderStr,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: HsgColors.textHintColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputWidget(),
        isHiddenLine == true
            ? Divider()
            : Divider(
                height: 0.5,
                color: HsgColors.lineColor,
              ),
      ],
    );
  }

  Widget _oneLayerSelectWidget(
    BuildContext context,
    String titleStr,
    String textStr,
    String placeholderStr,
    bool isHiddenLine,
    VoidCallback btnClick,
  ) {
    final size = MediaQuery.of(context).size;

    TextEditingController textEC = TextEditingController(text: textStr);

    Widget _textWidget() {
      return Container(
        width: size.width - 30,
        height: 50,
        child: Row(
          children: [
            Container(
              width: 120,
              child: Text(
                titleStr,
                maxLines: 2,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              height: 50,
              width: size.width - 30 - 125 - 13,
              padding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
              child: TextField(
                //是否自动更正
                autocorrect: false,
                //是否自动获得焦点
                autofocus: false,
                controller: textEC,
                // scrollPadding: EdgeInsets.all(0),
                // obscureText: this.isCiphertext,
                textAlign: TextAlign.right,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  color: HsgColors.firstDegreeText,
                ),
                decoration: InputDecoration(
                  // isCollapsed: true,
                  border: InputBorder.none,
                  hintText: placeholderStr,
                  hintStyle: TextStyle(
                    // backgroundColor: Colors.yellow,
                    fontSize: 14,
                    color: HsgColors.textHintColor,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: HsgColors.firstDegreeText,
            ),
          ],
        ),
      );
    }

    Widget _selectWidget() {
      return Stack(
        alignment: Alignment.centerRight,
        children: [
          _textWidget(),
          Container(
            width: size.width - 30,
            child: MaterialButton(onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              btnClick();
            }),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _selectWidget(),
        isHiddenLine == true
            ? Divider()
            : Divider(
                height: 0.5,
                color: HsgColors.lineColor,
              ),
      ],
    );
  }

  /// 登记证件类型输入值
  void _selectDocumentType(BuildContext context) async {
    List<String> documentList = [
      'Certificate of Incorporation', // 公司注册证书',
      'Business Registration Certificate', // 商业登记证',
      'Other', // 其他'
    ];
    if (_documentTypes.length > 0) {
      documentList = [];
      String _language = Intl.getCurrentLocale();
      _documentTypes.forEach((element) {
        documentList.add(_language == 'en' ? element.name : element.cname);
      });
    }
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.of(context).openAccount_documentType_select,
        items: documentList,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _documentTypeText = documentList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  ///公司类别选择
  void _selectCompanyType(BuildContext context) async {
    List<String> companyList = [
      'Limited Company', // 有限公司',
      'Partnership', //合伙经营商号',
      'Sole Proprietorship', //独资经营商号',
      'Other (Please Specify)', //其他 (请注明)'
    ];
    if (_companyTypes.length > 0) {
      companyList = [];
      String _language = Intl.getCurrentLocale();
      _companyTypes.forEach((element) {
        companyList.add(_language == 'en' ? element.name : element.cname);
      });
    }
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.of(context).openAccount_companyType_select,
        items: companyList,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _companyTypeText = companyList[result];
        _isShowCompanyTypeOther =
            result == companyList.length - 1 ? true : false;
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 商业/行业性质选择
  void _selectIndustrialNature(BuildContext context) async {
    List<String> industrialList = [
      'Agriculture, forestry and fishing',
      'Mining and quarrying',
      'Manufacturing',
      'Electricity, gas, steam and air conditioning supply',
      'Water supply; sewerage, waste management and remediation activities',
      'Construction',
      'Wholesale and retail trade; repair of motor vehicles and motorcycles',
      'Transportation and storage',
      'Accommodation and food service activities',
      'Information and communication',
      'Financial and insurance activities',
      'Real estate activities',
      'Professional, scientific and technical activities',
      'Administrative and support service activities',
      'Public administration and defence; compulsory social security',
      'Education',
      'Human health and social work activities',
      'Arts, entertainment and recreation',
      'Other service activities',
      'Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use',
      'Activities of extraterritorial organizations and bodies',
      'Sensitive business'
    ];

    if (_industrialNatures.length > 0) {
      industrialList = [];
      String _language = Intl.getCurrentLocale();
      _industrialNatures.forEach((element) {
        industrialList.add(_language == 'en' ? element.name : element.cname);
      });
    }

    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.of(context).openAccount_industryNature_select,
        items: industrialList,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _industrialNatureText = industrialList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  //获取公共参数
  void _getPublicParameters() async {
    //获取登记注册文件类型
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('FIRM_CERT'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _documentTypes = data.publicCodeGetRedisRspDtoList;
        print('FIRM_CERT-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    //获取公司类别类型
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('ET'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _companyTypes = data.publicCodeGetRedisRspDtoList;
        print('ET-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    //获取商业行业性质类型
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('BIZ_IDU'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _industrialNatures = data.publicCodeGetRedisRspDtoList;
        print('BIZ_IDU-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
