import 'dart:convert';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_save_data.dart';
import 'package:ebank_mobile/data/source/open_account_repository.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelatedIndividualsDataPage extends StatefulWidget {
  RelatedIndividualsDataPage({Key key}) : super(key: key);

  @override
  _RelatedIndividualsDataPageState createState() =>
      _RelatedIndividualsDataPageState();
}

class _RelatedIndividualsDataPageState
    extends State<RelatedIndividualsDataPage> {
  ///数据上传请求体
  OpenAccountQuickSubmitDataReq _dataReq = new OpenAccountQuickSubmitDataReq();

  ///有关人士请求体
  Partner _partner = new Partner();

  /// 称谓
  String _appellationText = '';

  /// 类别
  String _categoryText = '';

  /// 证件类型
  String _documentTypeText = '';

  /// 登记证件号码输入值
  String _documentNumberText = '';

  /// 国籍（国家地区）
  String _nationalityText = '';

  /// 下一步按钮是否能点击
  bool _nextBtnEnabled = false;

  ///登记证件号码输入监听
  TextEditingController _documentNumberTEC = TextEditingController();

  ///称谓请求类型
  List<IdType> _appellationTypes = [];

  ///类别请求类型
  List<IdType> _categoryTypes = [];

  ///证件类型请求类型
  List<IdType> _documentTypes = [];

  @override
  void initState() {
    _getPublicParameters();

    _documentNumberTEC.addListener(() {
      _documentNumberText = _documentNumberTEC.text;
      _partner.idNo = _documentNumberText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _documentNumberTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataReq = ModalRoute.of(context).settings.arguments;
    _changeShowData();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title:
            Text(S.of(context).openAccout_details_of_connected_parties_title),
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
              _nextBtnWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  ///下一步按钮
  Widget _nextBtnWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 20),
      child: HsgButton.button(
        title: S.of(context).next_step,
        click: _nextBtnEnabled
            ? () async {
                final prefs = await SharedPreferences.getInstance();
                String phoneStr = prefs.getString(ConfigKey.USER_PHONE);
                _partner.phone = phoneStr == null ? '' : phoneStr;
                List<Partner> partnerList = [_partner];
                _dataReq.partnerList = partnerList;
                _savePreCust();

                _openAccountQuickSubmitData();
              }
            : null,
        isColor: _nextBtnEnabled,
      ),
    );
  }

  ///判断下一步按钮是否能点击
  bool _judgeButtonIsEnabled() {
    if (_appellationText == null || _appellationText == '') {
      return false;
    }
    if (_categoryText == null || _categoryText == '') {
      return false;
    }
    if (_documentTypeText == null || _documentTypeText == '') {
      return false;
    }
    // if (_documentNumberText == null || _documentNumberText == '') {
    //   return false;
    // }
    if (_nationalityText == null || _nationalityText == '') {
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
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: _contentColumn(context),
        ),
      ],
    );
  }

  ///选择内容区域
  Widget _contentColumn(BuildContext context) {
    List<Widget> children = [
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          S.of(context).openAccout_details_of_connected_parties,
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
          S.of(context).openAccout_appellation,
          _appellationText,
          S.of(context).please_select,
          false,
          () {
            print('称谓');
            _selectAppellation(context);
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_capacity,
          _categoryText,
          S.of(context).please_select,
          false,
          () {
            print('类别');
            _selectCategory(context);
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_documentType,
          _documentTypeText,
          S.of(context).please_select,
          false,
          () {
            print('证件类型');
            _selectDocumentType(context);
          },
        ),
      ),
      // Container(
      //   child: _oneLayerInputWidget(
      //     context,
      //     S.of(context).openAccount_documentNumber,
      //     S.of(context).openAccount_documentNumber_placeholder,
      //     _documentNumberTEC,
      //     false,
      //     <TextInputFormatter>[
      //       LengthLimitingTextInputFormatter(30) //限制长度
      //     ],
      //   ),
      // ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_nationality,
          _nationalityText,
          S.of(context).please_select,
          false,
          () {
            print('国籍（国家地区）');
            Navigator.pushNamed(context, countryOrRegionSelectPage)
                .then((value) {
              String _language = Intl.getCurrentLocale();
              CountryRegionModel data = value;
              String showText = '';
              if (_language == 'zh_CN') {
                showText = data.nameZhCN;
              } else if (_language == 'zh_HK') {
                showText = data.nameZhHK;
              } else {
                showText = data.nameEN;
              }

              _partner.nationalityCountryRegionModel = data;
              _partner.nationality = data.countryCode;
              setState(() {
                _nationalityText = showText;
                _nextBtnEnabled = _judgeButtonIsEnabled();
              });
            });
          },
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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

  /// 称谓输入值
  void _selectAppellation(BuildContext context) async {
    List<String> appellationList = [
      // 'Mr', // 先生
      // 'Mrs', // 太太
      // 'Miss', // 小姐
      // 'Ms', // 女士
    ];
    if (_appellationTypes.length > 0) {
      appellationList = [];
      String _language = Intl.getCurrentLocale();
      _appellationTypes.forEach((element) {
        appellationList.add(_language == 'en' ? element.name : element.cname);
      });
    }
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.of(context).openAccout_appellation,
        items: appellationList,
      ),
    );

    if (result != null && result != false) {
      IdType data = _documentTypes[result];
      _partner.appellationIdType = data;
      _partner.appellation = 'A'; //data.code;
      setState(() {
        _appellationText = appellationList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 类别输入值
  void _selectCategory(BuildContext context) async {
    List<String> categoryList = [
      // 'Sole Proprietor', // 獨資經營者
      // 'Partner', // 合夥人
      // 'Director', // 董事
      // 'Legal Representative', //企業法人
      // 'Authorised Signatory', //授權簽署人
      // 'Ultimate Beneficial Owner', //最終實益擁有人
      // 'Key Controller', //主要管理人
      // 'Direct Appointee', //受任人
      // 'Contact Person', //聯絡人
      // 'Primary Users of Ebank', //網上理財主要使用者
    ];
    if (_categoryTypes.length > 0) {
      categoryList = [];
      String _language = Intl.getCurrentLocale();
      _categoryTypes.forEach((element) {
        categoryList.add(_language == 'en' ? element.name : element.cname);
      });
    }
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.of(context).openAccout_capacity,
        items: categoryList,
      ),
    );

    if (result != null && result != false) {
      IdType data = _categoryTypes[result];
      _partner.partnerTypeIdType = data;
      _partner.partnerType = '001'; //data.code;
      setState(() {
        _categoryText = categoryList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 证件类型输入值
  void _selectDocumentType(BuildContext context) async {
    List<String> documentList = [
      // 'Identity Card', //身分證
      // 'Passport', //護照
      // 'Other', //其他:
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
        title: S.of(context).openAccout_documentType,
        items: documentList,
      ),
    );

    if (result != null && result != false) {
      IdType data = _documentTypes[result];
      _partner.idTypeIdType = data;
      _partner.idType = data.code;
      setState(() {
        _documentTypeText = documentList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  //获取公共参数
  void _getPublicParameters() async {
    //称谓
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('SALUTATION'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _appellationTypes = data.publicCodeGetRedisRspDtoList;
        print('SALUTATION-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    //个人职位类别
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('POSIT'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _categoryTypes = data.publicCodeGetRedisRspDtoList;
        print('POSIT-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    //个人证件类型
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('CERT_TYPE'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _documentTypes = data.publicCodeGetRedisRspDtoList;
        print('CERT_TYPE-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //提交快速开户录入的数据
  void _openAccountQuickSubmitData() async {
    HSProgressHUD.show();

    OpenAccountRepository()
        .submitQuickCustTempInfo(_dataReq, 'GetIdTypeReq')
        .then(
      (value) {
        print(value);
        HSProgressHUD.dismiss();
        if (value.businessId.length > 0) {
          Navigator.pushNamed(
            context,
            pageOpenAccountSelectDocumentType,
            arguments: value.businessId,
          );
        } else {}
      },
    ).catchError(
      (e) {
        HSProgressHUD.dismiss();
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER,
        );
      },
    );
  }

  ///上传本页数据后台保存
  void _savePreCust() async {
    Map<String, dynamic> josnMap = _dataReq.toJson();
    String josnString = jsonEncode(josnMap);
    josnString.replaceAll('\\n', '');
    print('josnString>>>>>>>>>>>>>>>>>>>>> == $josnString');
    //获取登记注册文件类型
    OpenAccountRepository()
        .savePreCust(OpenAccountSaveDataReq(josnString), 'savePreCust')
        .then((data) {})
        .catchError((e) {});
  }

  void _changeShowData() {
    if (this.mounted) {
      setState(() {
        if (_dataReq.partnerList != null && _dataReq.partnerList.length > 0) {
          Partner partner = _dataReq.partnerList[0];

          String _language = Intl.getCurrentLocale();
          if (_language == 'en') {
            _appellationText = partner.appellationIdType.name;
            _categoryText = partner.partnerTypeIdType.name;
            _documentTypeText = partner.idTypeIdType.name;
            _nationalityText = partner.nationalityCountryRegionModel.nameEN;
          } else if (_language == 'zh_CN') {
            _appellationText = partner.appellationIdType.cname;
            _categoryText = partner.partnerTypeIdType.cname;
            _documentTypeText = partner.idTypeIdType.cname;
            _nationalityText = partner.nationalityCountryRegionModel.nameZhCN;
          } else {
            _appellationText = partner.appellationIdType.cname;
            _categoryText = partner.partnerTypeIdType.cname;
            _documentTypeText = partner.idTypeIdType.cname;
            _nationalityText = partner.nationalityCountryRegionModel.nameZhHK;
          }

          _nextBtnEnabled = _judgeButtonIsEnabled();
        }
      });
    }
  }
}
