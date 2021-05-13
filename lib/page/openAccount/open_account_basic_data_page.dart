import 'dart:convert';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 快速开户-基本信息录入
/// Author: 李家伟
/// Date: 2021-03-17

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/openAccount/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/openAccount/open_account_Industry_two_data.dart';
import 'package:ebank_mobile/data/source/model/openAccount/open_account_get_data.dart';
import 'package:ebank_mobile/data/source/model/openAccount/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/data/source/model/openAccount/open_account_save_data.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class OpenAccountBasicDataPage extends StatefulWidget {
  @override
  _OpenAccountBasicDataPageState createState() =>
      _OpenAccountBasicDataPageState();
}

class _OpenAccountBasicDataPageState extends State<OpenAccountBasicDataPage> {
  ///数据上传请求体
  OpenAccountQuickSubmitDataReq _dataReq = new OpenAccountQuickSubmitDataReq();

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

  /// 商业/行业性质二级选择值
  String _industrialNatureTwoText = '';

  /// 是否显示公司类别（其他）输入框
  bool _isShowCompanyTypeOther = false;

  /// 下一步按钮是否能点击
  bool _nextBtnEnabled = false;

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

  ///商业行业性质二级请求类型
  List<RedisRspDto> _industrialNaturesTwo = [];

  // bool _isShowErrorPage = false;
  // Widget _hsgErrorPage;

  @override
  void initState() {
    _companyNameEngTEC.addListener(() {
      _companyNameEngText = _companyNameEngTEC.text;
      _dataReq.custNameEng = _companyNameEngText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _companyNameCNTEC.addListener(() {
      _companyNameCNText = _companyNameCNTEC.text;
      _dataReq.custNameLoc = _companyNameCNText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _documentNumberTEC.addListener(() {
      _documentNumberText = _documentNumberTEC.text;
      _dataReq.idNo = _documentNumberText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _companyTypeOtherTEC.addListener(() {
      _companyTypeOtherText = _companyTypeOtherTEC.text;
      _dataReq.otherCategory = _companyTypeOtherText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });

    _getPublicParameters();
    _getPreCustByStep();
    super.initState();
  }

  @override
  void dispose() {
    _companyNameEngTEC.dispose();
    _companyNameCNTEC.dispose();
    _documentNumberTEC.dispose();
    _companyTypeOtherTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).openAccout_basicInformation),
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
                          _savePreCust();
                          Navigator.pushNamed(
                            context,
                            pageOpenAccountContactInformation,
                            arguments: {'data': _dataReq},
                          );
                        }
                      : null,
                  isColor: _nextBtnEnabled,
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
    if (_industrialNatureTwoText == null || _industrialNatureTwoText == '') {
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
              <TextInputFormatter>[
                LengthLimitingTextInputFormatter(140),
                // FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')), //只允许输入字母
                FilteringTextInputFormatter.deny(
                    RegExp("[\u4e00-\u9fa5]")), //不允许输入汉字
                FilteringTextInputFormatter.deny(
                    RegExp(InputFormartterRegExp.REGEX_EMOJI)), //不允许表情
              ],
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
              <TextInputFormatter>[
                LengthLimitingTextInputFormatter(45),
                FilteringTextInputFormatter.deny(
                    RegExp(InputFormartterRegExp.REGEX_EMOJI)), //不允许表情
              ],
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
              <TextInputFormatter>[
                LengthLimitingTextInputFormatter(30),
                FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z0-9]')), //只允许输入字母
              ],
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
                    <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(45),
                      FilteringTextInputFormatter.deny(
                          RegExp(InputFormartterRegExp.REGEX_EMOJI)), //不允许表情
                    ],
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
                  String _language = Intl.getCurrentLocale();
                  CountryRegionNewModel data = value;
                  String showText = '';
                  if (_language == 'zh_CN') {
                    showText = data.cntyCnm;
                  } else if (_language == 'zh_HK') {
                    showText = data.cntyTcnm;
                  } else {
                    showText = data.cntyNm;
                  }

                  _dataReq.idIssuePlace = data.cntyCd;
                  _dataReq.registePlace = data.cntyCd;
                  _dataReq.idIssuePlaceCountryRegionModel = data;
                  setState(() {
                    _countryOrRegionText = showText;
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
          Container(
            child: _oneLayerSelectWidget(
              context,
              S.of(context).openAccount_industryNatureTwo,
              _industrialNatureTwoText,
              S.of(context).please_select,
              false,
              () {
                print('商业/行业性质二级选择');
                _selectIndustrialNatureTwo(context);
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
    List<TextInputFormatter> inputFormatters,
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
              inputFormatters: inputFormatters,
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
    List<TextInputFormatter> inputFormatters,
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
                inputFormatters: inputFormatters,
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
      // 'Certificate of Incorporation', // 公司注册证书',
      // 'Business Registration Certificate', // 商业登记证',
      // 'Other', // 其他'
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
      IdType data = _documentTypes[result];
      _dataReq.idType = data.code;
      _dataReq.idTypeIdType = data;
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
      // 'Limited Company', // 有限公司',
      // 'Partnership', //合伙经营商号',
      // 'Sole Proprietorship', //独资经营商号',
      // 'Other (Please Specify)', //其他 (请注明)'
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
      IdType data = _companyTypes[result];
      _dataReq.custCategory = data.code;
      _dataReq.custCategoryIdType = data;
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
    List<String> industrialList = [];

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
      IdType data = _industrialNatures[result];
      if (data != null && data != _dataReq.corporatinAttributesIdType) {
        _industrialNatureTwoText = '';
        _getIndustrialNaturesTwo(data);
      }
      _dataReq.corporatinAttributes = data.code;
      _dataReq.corporatinAttributesIdType = data;
      setState(() {
        _industrialNatureText = industrialList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 商业/行业性质二级选择
  void _selectIndustrialNatureTwo(BuildContext context) async {
    List<String> industrialTwoList = [];

    if (_industrialNaturesTwo.length > 0) {
      industrialTwoList = [];
      String _language = Intl.getCurrentLocale();
      _industrialNaturesTwo.forEach((element) {
        industrialTwoList
            .add(_language == 'en' ? element.engName : element.localName);
      });
    } else {
      HSProgressHUD.showToastTip(
        S.of(context).openAccount_industryNatureNotSelect_tip,
      );
      return;
    }

    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.of(context).openAccount_industryNatureTwo_select,
        items: industrialTwoList,
      ),
    );

    if (result != null && result != false) {
      RedisRspDto data = _industrialNaturesTwo[result];
      _dataReq.offeredProduct = data.code;
      _dataReq.corporatinAttributesIdTypeTwo = data;
      setState(() {
        _industrialNatureTwoText = industrialTwoList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  //获取公共参数
  void _getPublicParameters() async {
    //获取登记注册文件类型
    ApiClientOpenAccount().getIdType(GetIdTypeReq('CGCT')) //CGCT//FIRM_CERT
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _documentTypes = data.publicCodeGetRedisRspDtoList;
      }
    }).catchError((e) {
      if (e is NeedLogin) {
      } else {
        HSProgressHUD.showToast(e);
      }
    });

    //获取公司类别类型CORP_TYPE
    ApiClientOpenAccount().getIdType(GetIdTypeReq('CORP_TYPE')) //CORP_TYPE//ET
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _companyTypes = data.publicCodeGetRedisRspDtoList;
      }
    }).catchError((e) {
      if (e is NeedLogin) {
      } else {
        HSProgressHUD.showToast(e);
      }
    });

    //获取商业行业性质类型NOCI
    ApiClientOpenAccount().getIdType(GetIdTypeReq('NOCI')) //BIZ_IDU//NOCI
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _industrialNatures = data.publicCodeGetRedisRspDtoList;
      }
    }).catchError((e) {
      if (e is NeedLogin) {
      } else {
        HSProgressHUD.showToast(e);
      }
    });
  }

  /// 通过商业行业性质一级Code获取二级列表接口
  void _getIndustrialNaturesTwo(IdType data) async {
    final prefs = await SharedPreferences.getInstance();
    String userAccount = prefs.getString(ConfigKey.USER_ACCOUNT);
    String userId = prefs.getString(ConfigKey.USER_ID);

    HSProgressHUD.show();
    SubPublicCodeByTypeReq req = SubPublicCodeByTypeReq(
      'PS', //BIZ_IDU_SUB
      userAccount,
      userId,
      data.code,
    );
    ApiClientOpenAccount().getSubPublicCodeByType(req).then((data) {
      HSProgressHUD.dismiss();
      if (data.publicCodeGetRedisRspDtoList != null) {
        _industrialNaturesTwo = data.publicCodeGetRedisRspDtoList;
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  ///上传本页数据后台保存
  void _savePreCust() async {
    Map<String, dynamic> josnMap = _dataReq.toJson();
    String josnString = jsonEncode(josnMap);
    josnString.replaceAll('\\n', '');
    // OpenAccountRepository()
    ApiClientOpenAccount()
        .savePreCust(OpenAccountSaveDataReq(josnString))
        .then((data) {})
        .catchError((e) {});
  }

  ///获取后台保存的数据
  void _getPreCustByStep() async {
    HSProgressHUD.show();
    // OpenAccountRepository()
    ApiClientOpenAccount()
        .getPreCustByStep(OpenAccountGetDataReq())
        .then((data) {
      HSProgressHUD.dismiss();
      var content = jsonDecode(data.content);
      _dataReq = OpenAccountQuickSubmitDataReq.fromJson(content);
      if (_dataReq.corporatinAttributesIdType != null &&
          _dataReq.corporatinAttributesIdType.code != null) {
        _getIndustrialNaturesTwo(_dataReq.corporatinAttributesIdType);
      }
      _changeShowData();
    }).catchError((e) {
      HSProgressHUD.dismiss();
      print('getdata = ${e.toString()}');
    });
  }

  void _changeShowData() {
    if (this.mounted) {
      setState(() {
        String _language = Intl.getCurrentLocale();
        _companyNameEngTEC.text = _companyNameEngText = _dataReq.custNameEng;
        _companyNameCNTEC.text = _companyNameCNText = _dataReq.custNameLoc;
        _documentNumberTEC.text = _documentNumberText = _dataReq.idNo;
        _companyTypeOtherTEC.text =
            _companyTypeOtherText = _dataReq.otherCategory;
        if (_language == 'en') {
          _documentTypeText = _dataReq.idTypeIdType.name;
          _companyTypeText = _dataReq.custCategoryIdType.name;
          _countryOrRegionText = _dataReq.idIssuePlaceCountryRegionModel.cntyNm;
          _industrialNatureText = _dataReq.corporatinAttributesIdType.name;
          _industrialNatureTwoText =
              _dataReq.corporatinAttributesIdTypeTwo.engName;
        } else if (_language == 'zh_CN') {
          _documentTypeText = _dataReq.idTypeIdType.cname;
          _companyTypeText = _dataReq.custCategoryIdType.cname;
          _countryOrRegionText =
              _dataReq.idIssuePlaceCountryRegionModel.cntyCnm;
          _industrialNatureText = _dataReq.corporatinAttributesIdType.cname;
          _industrialNatureTwoText =
              _dataReq.corporatinAttributesIdTypeTwo.localName;
        } else {
          _documentTypeText = _dataReq.idTypeIdType.cname;
          _companyTypeText = _dataReq.custCategoryIdType.cname;
          _countryOrRegionText =
              _dataReq.idIssuePlaceCountryRegionModel.cntyTcnm;
          _industrialNatureText = _dataReq.corporatinAttributesIdType.cname;
          _industrialNatureTwoText =
              _dataReq.corporatinAttributesIdTypeTwo.localName;
        }

        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    }
  }
}
