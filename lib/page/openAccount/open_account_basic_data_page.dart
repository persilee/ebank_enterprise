/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 快速开户-基本信息录入
/// Author: 李家伟
/// Date: 2021-03-17

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    _companyNameEngTEC.dispose();
    _companyNameCNTEC.dispose();
    _companyTypeOtherTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('基本信息'),
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
    // if (_countryOrRegionText == null || _countryOrRegionText == '') {
    //   return false;
    // }
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
              '基本信息',
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
              '公司名称（英文）',
              '请输入公司名称（英文）',
              _companyNameEngTEC,
              false,
              1001,
            ),
          ),
          Container(
            child: _twoLayerInputWidget(
              context,
              '公司名称（中文）',
              '请输入公司名称（中文）',
              _companyNameCNTEC,
              false,
              1002,
            ),
          ),
          Container(
            child: _oneLayerSelectWidget(
              context,
              '登记证件类型',
              _documentTypeText,
              '请选择',
              false,
              1003,
              () {
                print('登记证件类型');
                _selectDocumentType(context);
              },
            ),
          ),
          Container(
            child: _oneLayerInputWidget(
              context,
              '登记证件号码',
              '请输入登记证件号码',
              _documentNumberTEC,
              false,
              1004,
            ),
          ),
          Container(
            child: _oneLayerSelectWidget(
              context,
              '公司类别',
              _companyTypeText,
              '请选择',
              false,
              1005,
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
                    '公司类别（其他）',
                    '请输入公司类别（其他）',
                    _companyTypeOtherTEC,
                    false,
                    1006,
                  ),
                )
              : Container(),
          Container(
            child: _oneLayerSelectWidget(
              context,
              '注册国家/地区',
              _countryOrRegionText,
              '请选择',
              false,
              1002,
              () {
                print('注册国家/地区');
                Navigator.pushNamed(context, countryOrRegionSelectPage)
                    .then((value) {
                  setState(() {
                    _countryOrRegionText = (value as CountryRegionModel).nameEN;
                  });
                });
              },
            ),
          ),
          Container(
            child: _oneLayerSelectWidget(
              context,
              '商业/行业性质',
              _industrialNatureText,
              '请选择',
              false,
              1007,
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
    int textFieldTag,
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
              // obscureText: this.isCiphertext,
              // onChanged: ,
              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.bottom,
              textDirection: TextDirection.ltr,
              maxLines: 2,
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
        height: 45,
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
              height: 45,
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
                textAlignVertical: TextAlignVertical.bottom,
                textDirection: TextDirection.ltr,
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
    int textFieldTag,
    VoidCallback btnClick,
  ) {
    final size = MediaQuery.of(context).size;

    TextEditingController textEC = TextEditingController(text: textStr);

    textEC.addListener(() {
      // setState(() {
      //   if (textFieldTag == 1001) {
      //     _companyNameEngText = textEC.text;
      //   }
      //   if (textFieldTag == 1002) {
      //     _companyNameCNText = textEC.text;
      //   }
      //   _nextBtnEnabled = _judgeButtonIsEnabled();
      // });
    });

    Widget _textWidget() {
      return Container(
        width: size.width - 30,
        height: 45,
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
              height: 45,
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
                textAlignVertical: TextAlignVertical.bottom,
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
    List<String> documentTypes = [
      'Certificate of Incorporation 公司注册证书',
      'Business Registration Certificate 商业登记证',
      'Other 其他'
    ];
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: '登记证件类型选择',
        items: documentTypes,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _documentTypeText = documentTypes[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  ///公司类别选择
  void _selectCompanyType(BuildContext context) async {
    List<String> companyTypes = [
      'Limited Company 有限公司',
      'Partnership合伙经营商号',
      'Sole Proprietorship独资经营商号',
      'Other (please specify)其他 (请注明)'
    ];
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: '公司类别选择',
        items: companyTypes,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _companyTypeText = companyTypes[result];
        _isShowCompanyTypeOther =
            result == companyTypes.length - 1 ? true : false;
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 商业/行业性质选择
  void _selectIndustrialNature(BuildContext context) async {
    List<String> industrialNatures = [
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
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: '公司类别选择',
        items: industrialNatures,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _industrialNatureText = industrialNatures[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }
}
