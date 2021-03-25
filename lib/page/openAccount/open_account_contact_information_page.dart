/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 联系信息填入页面
/// Author: 李家伟
/// Date: 2021-03-20

import 'dart:convert';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';

class OpenAccountContactInformationPage extends StatefulWidget {
  @override
  _OpenAccountContactInformationPageState createState() =>
      _OpenAccountContactInformationPageState();
}

class _OpenAccountContactInformationPageState
    extends State<OpenAccountContactInformationPage> {
  ///数据上传请求体
  OpenAccountQuickSubmitDataReq _dataReq = new OpenAccountQuickSubmitDataReq();

  /// 注册公司地址请求体
  Address _registrationAddress = new Address(addressType: 'R');

  /// 营业地址请求体
  Address _businessAddress = new Address(addressType: 'P');

  /// 通讯地址请求体
  Address _communicationAddress = new Address(addressType: 'C');

  /// 注册公司地区（省市区）
  String _registrationAreaText = '';

  /// 注册地区（省市区）一级选择
  String _registrationAreaOneText = '';

  /// 注册地区（省市区）二级选择
  String _registrationAreaTwoText = '';

  /// 注册地区（省市区）三级选择
  String _registrationAreaThreeText = '';

  /// 注册公司地址详情
  String _registeredAddressText = '';

  /// 注册公司邮编
  String _registrationZipCodeText = '';

  /// 营业地址是否和注册公司地址一样
  bool _theSameForRegisterAndBusiness = false;

  /// 营业地区（省市区）
  String _businessAreaText = '';

  /// 营业地区（省市区）一级选择
  String _businessAreaOneText = '';

  /// 营业地区（省市区）二级选择
  String _businessAreaTwoText = '';

  /// 营业地区（省市区）三级选择
  String _businessAreaThreeText = '';

  /// 营业地址详情
  String _businessAddressText = '';

  /// 营业邮编
  String _businessZipCodeText = '';

  /// 通讯地址是否和注册公司地址一样
  bool _theSameForRegisterAndCommunication = false;

  /// 通讯地区（省市区）
  String _communicationAreaText = '';

  /// 通讯地区（省市区）一级选择
  String _communicationAreaOneText = '';

  /// 通讯地区（省市区）二级选择
  String _communicationAreaTwoText = '';

  /// 通讯地区（省市区）三级选择
  String _communicationAreaThreeText = '';

  /// 通讯地址详情
  String _correspondenceAddressText = '';

  /// 通讯邮编
  String _communicationsZipCodeText = '';

  /// 区号
  String _officeAreaCodeText = '';

  /// 办事处电话号码
  String _officePhoneText = '';

  /// 下一步按钮是否能点击
  bool _nextBtnEnabled = false;

  /// 城市数据列表
  List _cityDataList = [];

  /// 城市数据列表
  List _cityShowList = [];

  ///注册公司地址详情输入监听
  TextEditingController _registeredAddressTEC = TextEditingController();

  ///注册公司邮编输入监听
  TextEditingController _registrationZipCodeTEC = TextEditingController();

  ///营业地址详情输入监听
  TextEditingController _businessAddressTEC = TextEditingController();

  ///营业邮编输入监听
  TextEditingController _businessZipCodeTEC = TextEditingController();

  ///通讯地址详情输入监听
  TextEditingController _correspondenceAddressTEC = TextEditingController();

  ///通讯邮编输入监听
  TextEditingController _communicationsZipCodeTEC = TextEditingController();

  ///办事处电话号码输入监听
  TextEditingController _officePhoneTEC = TextEditingController();

  @override
  void initState() {
    _registeredAddressTEC.addListener(() {
      _registeredAddressText = _registeredAddressTEC.text;
      _registrationAddress.detail = _registeredAddressText;
      if (_theSameForRegisterAndBusiness == true) {
        _businessAddress.detail = _registeredAddressText;
      }
      if (_theSameForRegisterAndCommunication == true) {
        _communicationAddress.detail = _registeredAddressText;
      }
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _registrationZipCodeTEC.addListener(() {
      _registrationZipCodeText = _registrationZipCodeTEC.text;
      _registrationAddress.postCode = _registrationZipCodeText;
      if (_theSameForRegisterAndBusiness == true) {
        _businessAddress.postCode = _registrationZipCodeText;
      }
      if (_theSameForRegisterAndCommunication == true) {
        _communicationAddress.postCode = _registrationZipCodeText;
      }
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _businessAddressTEC.addListener(() {
      _businessAddressText = _businessAddressTEC.text;
      _businessAddress.detail = _businessAddressText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _businessZipCodeTEC.addListener(() {
      _businessZipCodeText = _businessZipCodeTEC.text;
      _businessAddress.postCode = _businessZipCodeText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _correspondenceAddressTEC.addListener(() {
      _correspondenceAddressText = _correspondenceAddressTEC.text;
      _communicationAddress.detail = _correspondenceAddressText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _communicationsZipCodeTEC.addListener(() {
      _communicationsZipCodeText = _communicationsZipCodeTEC.text;
      _communicationAddress.postCode = _communicationsZipCodeText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _officePhoneTEC.addListener(() {
      _officePhoneText = _officePhoneTEC.text;
      _dataReq.telNumber = _officePhoneText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });

    _getCityData();

    super.initState();
  }

  @override
  void dispose() {
    _registeredAddressTEC.dispose();
    _registrationZipCodeTEC.dispose();
    _businessAddressTEC.dispose();
    _businessZipCodeTEC.dispose();
    _correspondenceAddressTEC.dispose();
    _communicationsZipCodeTEC.dispose();
    _officePhoneTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataReq = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(S.of(context).openAccout_contactInformation),
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
                          List<Address> addressList = [
                            _registrationAddress,
                            _businessAddress,
                            _communicationAddress,
                          ];
                          _dataReq.addressList = addressList;

                          Navigator.pushNamed(
                            context,
                            pageOpenAccountRelatedIndividualsData,
                            arguments: _dataReq,
                          );
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
    if (_registrationAreaText == null || _registrationAreaText == '') {
      return false;
    }
    if (_registeredAddressText == null || _registeredAddressText == '') {
      return false;
    }
    if (_registrationZipCodeText == null || _registrationZipCodeText == '') {
      return false;
    }
    if (_theSameForRegisterAndBusiness == false) {
      if (_businessAreaText == null || _businessAreaText == '') {
        return false;
      }
      if (_businessAddressText == null || _businessAddressText == '') {
        return false;
      }
      if (_businessZipCodeText == null || _businessZipCodeText == '') {
        return false;
      }
    }
    if (_theSameForRegisterAndCommunication == false) {
      if (_communicationAreaText == null || _communicationAreaText == '') {
        return false;
      }
      if (_correspondenceAddressText == null ||
          _correspondenceAddressText == '') {
        return false;
      }
      if (_communicationsZipCodeText == null ||
          _communicationsZipCodeText == '') {
        return false;
      }
    }
    if (_officeAreaCodeText == null || _officeAreaCodeText == '') {
      return false;
    }
    if (_officePhoneText == null || _officePhoneText == '') {
      return false;
    }
    return true;
  }

  Widget _inputViewWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: _registeredAddressColumn(context),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: _businessColumn(context),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: _communicationColumn(context),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: _officePhoneColumn(context),
        )
      ],
    );
  }

  ///注册公司地址区域
  Widget _registeredAddressColumn(BuildContext context) {
    List<Widget> children = [
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          S.of(context).openAccout_registeredAddress,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: HsgColors.secondDegreeText,
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_registeredAddress,
          _registrationAreaText,
          S.of(context).openAccout_provinceCityArea,
          false,
          () {
            print('注册公司地址');
            _selectCity((Picker picker, List value) {
              String oneLevelStr = _cityDataList[value[0]]['name'];
              String twoLevelStr =
                  _cityDataList[value[0]]['children'][value[1]]['name'];
              // String threeLevelStr = _cityDataList[value[0]]['children'][value[1]]['children'][value[2]]['name'];
              _registrationAreaOneText = 'CN';
              _registrationAreaTwoText = oneLevelStr;
              _registrationAreaThreeText = twoLevelStr;

              _registrationAddress.country = _registrationAreaOneText;
              _registrationAddress.province = _registrationAreaTwoText;
              _registrationAddress.city = _registrationAreaThreeText;
              if (_theSameForRegisterAndBusiness == true) {
                _businessAddress.country = _registrationAreaOneText;
                _businessAddress.province = _registrationAreaTwoText;
                _businessAddress.city = _registrationAreaThreeText;
              }
              if (_theSameForRegisterAndCommunication == true) {
                _communicationAddress.country = _registrationAreaOneText;
                _communicationAddress.province = _registrationAreaTwoText;
                _communicationAddress.city = _registrationAreaThreeText;
              }

              setState(() {
                String dataStr = picker.adapter.text;
                dataStr = dataStr.replaceAll('[', '');
                dataStr = dataStr.replaceAll(']', '');
                dataStr = dataStr.replaceAll(',', '/');
                _registrationAreaText = dataStr;
                _nextBtnEnabled = _judgeButtonIsEnabled();
              });
            });
          },
        ),
      ),
      Container(
        child: _twoLayerInputWidget(
          context,
          S.of(context).openAccout_registeredAddress_details,
          S.of(context).please_enter,
          _registeredAddressTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(120),
          ],
          TextInputType.text,
        ),
      ),
      Container(
        child: _oneLayerInputWidget(
          context,
          S.of(context).openAccout_zipCode,
          S.of(context).not_required,
          _registrationZipCodeTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          TextInputType.number,
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  ///主要营业地址区域
  Widget _businessColumn(BuildContext context) {
    List<Widget> children = [
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          S.of(context).openAccout_businessAddress,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: HsgColors.secondDegreeText,
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
      Container(
        child: _oneLayerSwitchWidget(
          context,
          S.of(context).openAccout_theSameForRegister,
          _theSameForRegisterAndBusiness,
          false,
          (value) {
            if (_theSameForRegisterAndBusiness == true) {
              _businessAddress.detail = _registeredAddressText;
              _businessAddress.postCode = _registrationZipCodeText;

              _businessAddress.country = _registrationAreaOneText;
              _businessAddress.province = _registrationAreaTwoText;
              _businessAddress.city = _registrationAreaThreeText;
            } else {
              _businessAddress.detail = _businessAddressText;
              _businessAddress.postCode = _businessZipCodeText;

              _businessAddress.country = _businessAreaOneText;
              _businessAddress.province = _businessAreaTwoText;
              _businessAddress.city = _businessAreaThreeText;
            }
            setState(() {
              _theSameForRegisterAndBusiness = value;
              _nextBtnEnabled = _judgeButtonIsEnabled();
            });
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_businessAddress,
          _businessAreaText,
          S.of(context).openAccout_provinceCityArea,
          false,
          () {
            print('主要营业地址');
            _selectCity((Picker picker, List value) {
              String oneLevelStr = _cityDataList[value[0]]['name'];
              String twoLevelStr =
                  _cityDataList[value[0]]['children'][value[1]]['name'];
              // String threeLevelStr = _cityDataList[value[0]]['children'][value[1]]['children'][value[2]]['name'];
              _businessAreaOneText = 'CN';
              _businessAreaTwoText = oneLevelStr;
              _businessAreaThreeText = twoLevelStr;

              _businessAddress.country = _businessAreaOneText;
              _businessAddress.province = _businessAreaTwoText;
              _businessAddress.city = _businessAreaThreeText;

              setState(() {
                String dataStr = picker.adapter.text;
                dataStr = dataStr.replaceAll('[', '');
                dataStr = dataStr.replaceAll(']', '');
                dataStr = dataStr.replaceAll(',', '/');
                _businessAreaText = dataStr;
                _nextBtnEnabled = _judgeButtonIsEnabled();
              });
            });
          },
        ),
      ),
      Container(
        child: _twoLayerInputWidget(
          context,
          S.of(context).openAccout_businessAddress_details,
          S.of(context).please_enter,
          _businessAddressTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(120),
          ],
          TextInputType.text,
        ),
      ),
      Container(
        child: _oneLayerInputWidget(
          context,
          S.of(context).openAccout_zipCode,
          S.of(context).not_required,
          _businessZipCodeTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          TextInputType.number,
        ),
      ),
    ];

    if (_theSameForRegisterAndBusiness) {
      children = [children[0], children[1]];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  ///通讯地址区域
  Widget _communicationColumn(BuildContext context) {
    List<Widget> children = [
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          S.of(context).openAccout_mailingAddress,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: HsgColors.secondDegreeText,
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
      Container(
        child: _oneLayerSwitchWidget(
          context,
          S.of(context).openAccout_theSameForRegister,
          _theSameForRegisterAndCommunication,
          false,
          (value) {
            if (_theSameForRegisterAndCommunication == true) {
              _communicationAddress.detail = _registeredAddressText;
              _communicationAddress.postCode = _registrationZipCodeText;

              _communicationAddress.country = _registrationAreaOneText;
              _communicationAddress.province = _registrationAreaTwoText;
              _communicationAddress.city = _registrationAreaThreeText;
            } else {
              _communicationAddress.detail = _correspondenceAddressText;
              _communicationAddress.postCode = _communicationsZipCodeText;

              _communicationAddress.country = _communicationAreaOneText;
              _communicationAddress.province = _communicationAreaTwoText;
              _communicationAddress.city = _communicationAreaThreeText;
            }
            setState(() {
              _theSameForRegisterAndCommunication = value;
              _nextBtnEnabled = _judgeButtonIsEnabled();
            });
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_mailingAddress,
          _communicationAreaText,
          S.of(context).openAccout_provinceCityArea,
          false,
          () {
            print('通讯地址');
            _selectCity((Picker picker, List value) {
              String oneLevelStr = _cityDataList[value[0]]['name'];
              String twoLevelStr =
                  _cityDataList[value[0]]['children'][value[1]]['name'];
              // String threeLevelStr = _cityDataList[value[0]]['children'][value[1]]['children'][value[2]]['name'];
              _communicationAreaOneText = 'CN';
              _communicationAreaTwoText = oneLevelStr;
              _communicationAreaThreeText = twoLevelStr;

              _communicationAddress.country = _communicationAreaOneText;
              _communicationAddress.province = _communicationAreaTwoText;
              _communicationAddress.city = _communicationAreaThreeText;

              setState(() {
                String dataStr = picker.adapter.text;
                dataStr = dataStr.replaceAll('[', '');
                dataStr = dataStr.replaceAll(']', '');
                dataStr = dataStr.replaceAll(',', '/');
                _communicationAreaText = dataStr;
                _nextBtnEnabled = _judgeButtonIsEnabled();
              });
            });
          },
        ),
      ),
      Container(
        child: _twoLayerInputWidget(
          context,
          S.of(context).openAccout_mailingAddress_details,
          S.of(context).please_enter,
          _correspondenceAddressTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(120),
          ],
          TextInputType.text,
        ),
      ),
      Container(
        child: _oneLayerInputWidget(
          context,
          S.of(context).openAccout_zipCode,
          S.of(context).not_required,
          _communicationsZipCodeTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          TextInputType.number,
        ),
      ),
    ];

    if (_theSameForRegisterAndCommunication) {
      children = [children[0], children[1]];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  ///办公电话区域
  Widget _officePhoneColumn(BuildContext context) {
    List<Widget> children = [
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_areaCode,
          _officeAreaCodeText,
          S.of(context).please_select,
          false,
          () {
            print('区号');
            Navigator.pushNamed(context, countryOrRegionSelectPage)
                .then((value) {
              CountryRegionModel data = value;
              setState(() {
                _officeAreaCodeText = '+ ${data.code}';
                _dataReq.telCountryCode = data.code;
                _nextBtnEnabled = _judgeButtonIsEnabled();
              });
            });
          },
        ),
      ),
      Container(
        child: _oneLayerInputWidget(
          context,
          S.of(context).openAccout_officePhoneNo,
          S.of(context).please_enter,
          _officePhoneTEC,
          false,
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          TextInputType.number,
        ),
      ),
    ];

    return Column(
      children: children,
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
              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.bottom,
              // textDirection: TextDirection.ltr,
              maxLines: 2,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              // <TextInputFormatter>[
              //   LengthLimitingTextInputFormatter(maxLength) //限制长度
              // ],
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
    TextInputType keyboardType,
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
                textAlign: TextAlign.right,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                // <TextInputFormatter>[
                //   LengthLimitingTextInputFormatter(maxLength) //限制长度
                // ],
                textAlignVertical: TextAlignVertical.bottom,
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

  Widget _oneLayerSwitchWidget(
    BuildContext context,
    String titleStr,
    bool switchValue,
    bool isHiddenLine,
    ValueChanged<bool> switchValueChanged,
  ) {
    final size = MediaQuery.of(context).size;

    Widget _textWidget() {
      return Container(
        width: size.width - 30,
        height: 50,
        child: Row(
          children: [
            Container(
              width: 220,
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
            Expanded(child: Container()),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: HsgColors.theme,
                value: switchValue,
                onChanged: switchValueChanged,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textWidget(),
        isHiddenLine == true
            ? Divider()
            : Divider(
                height: 0.5,
                color: HsgColors.lineColor,
              ),
      ],
    );
  }

  void _getCityData() async {
    //加载城市列表
    rootBundle.loadString('assets/data/city.json').then((value) {
      _cityDataList = json.decode(value);
      List provinceList = json.decode(value);
      List<Map<String, List<Map<String, List<String>>>>> provinceShowList = [];
      provinceList.forEach((province) {
        List cityList = province['children'];
        List<Map<String, List<String>>> cityShowList = [];
        cityList.forEach((city) {
          List areaList = city['children'];
          List<String> areaShowList = [];
          areaList.forEach((area) {
            areaShowList.add(area['name']);
          });
          cityShowList.add({city['name']: areaShowList});
        });
        provinceShowList.add({province['name']: cityShowList});
      });
      _cityShowList = provinceShowList;
    });
  }

  void _selectCity(PickerConfirmCallback onConfirm) {
    Picker(
      adapter: PickerDataAdapter<String>(
        pickerdata: _cityShowList,
      ),
      changeToFirst: true,
      hideHeader: false,
      selectedTextStyle: TextStyle(
        color: HsgColors.theme,
      ),
      cancelText: S.of(context).cancel,
      cancelTextStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
      confirmText: S.of(context).confirm,
      confirmTextStyle: TextStyle(
        color: HsgColors.theme,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      onConfirm: onConfirm,
    ).showModal(this.context);
  }
}
