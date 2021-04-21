import 'dart:convert';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_save_data.dart';
import 'package:ebank_mobile/data/source/open_account_repository.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client_openAccount.dart';
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
  final OpenAccountQuickSubmitDataReq dataReq;

  RelatedIndividualsDataPage({Key key, this.dataReq}) : super(key: key);

  @override
  _RelatedIndividualsDataPageState createState() =>
      _RelatedIndividualsDataPageState();
}

class _RelatedIndividualsDataPageState
    extends State<RelatedIndividualsDataPage> {
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

    _partner.partnerTypeIdType = null;
    _partner.partnerType = '002';

    _documentNumberTEC.addListener(() {
      _documentNumberText = _documentNumberTEC.text;
      _partner.idNo = _documentNumberText;
      setState(() {
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    });
    _changeShowData();

    super.initState();
  }

  @override
  void dispose() {
    _documentNumberTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                String areaCodeStr = prefs.getString(ConfigKey.USER_AREACODE);
                _partner.phone = phoneStr == null ? '' : phoneStr;
                _partner.areaCode = areaCodeStr == null ? '' : areaCodeStr;
                List<Partner> partnerList = [_partner];
                widget.dataReq.partnerList = partnerList;
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
    // if (_categoryText == null || _categoryText == '') {
    //   return false;
    // }
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
      // Container(
      //   child: _oneLayerSelectWidget(
      //     context,
      //     S.of(context).openAccout_capacity,
      //     _categoryText,
      //     S.of(context).please_select,
      //     false,
      //     () {
      //       print('类别');
      //       _selectCategory(context);
      //     },
      //   ),
      // ),
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
              CountryRegionNewModel data = value;
              String showText = '';
              if (_language == 'zh_CN') {
                showText = data.cntyCnm;
              } else if (_language == 'zh_HK') {
                showText = data.cntyTcnm;
              } else {
                showText = data.cntyNm;
              }

              _partner.nationalityCountryRegionModel = data;
              _partner.nationality = data.cntyCd;
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
      IdType data = _appellationTypes[result];
      _partner.appellationIdType = data;
      _partner.appellation = data.code;
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
    List<String> categoryList = [];
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
      _partner.partnerType = data.code;
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
    //称谓AOTPC
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq('AOTPC')) //AOTPC//SALUTATION
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _appellationTypes = data.publicCodeGetRedisRspDtoList;
        print('公共参数-称谓-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });

    // //个人职位类别COPC
    // // PublicParametersRepository()
    // ApiClientOpenAccount().getIdType(GetIdTypeReq('COPC')) //COPC//POSIT
    //     .then((data) {
    //   if (data.publicCodeGetRedisRspDtoList != null) {
    //     _categoryTypes = data.publicCodeGetRedisRspDtoList;
    //     print('公共参数-个人职位类别-  ${data.publicCodeGetRedisRspDtoList}');
    //   }
    // }).catchError((e) {
    //   Fluttertoast.showToast(
    //     msg: e.toString(),
    //     gravity: ToastGravity.CENTER,
    //   );
    // });

    //个人证件类型
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq('TORPC')) //TORPC//CERT_TYPE
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _documentTypes = data.publicCodeGetRedisRspDtoList;
        print('公共参数-个人证件类型-  ${data.publicCodeGetRedisRspDtoList}');
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //提交快速开户录入的数据
  void _openAccountQuickSubmitData() async {
    HSProgressHUD.show();

    // OpenAccountRepository()
    ApiClientOpenAccount().submitQuickCustTempInfo(widget.dataReq).then(
      (value) {
        print(value);
        HSProgressHUD.dismiss();
        if (value.businessId.length > 0) {
          Navigator.pushNamed(
            context,
            pageOpenAccountSelectDocumentType,
            arguments: {
              'businessId': value.businessId,
              'isQuick': true,
            },
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
    Map<String, dynamic> josnMap = widget.dataReq.toJson();
    String josnString = jsonEncode(josnMap);
    josnString.replaceAll('\\n', '');
    // OpenAccountRepository()
    ApiClientOpenAccount()
        .savePreCust(OpenAccountSaveDataReq(josnString))
        .then((data) {})
        .catchError((e) {});
  }

  void _changeShowData() {
    if (this.mounted) {
      setState(() {
        if (widget.dataReq.partnerList != null &&
            widget.dataReq.partnerList.length > 0) {
          _partner = widget.dataReq.partnerList[0];

          String _language = Intl.getCurrentLocale();
          if (_language == 'en') {
            _appellationText = _partner.appellationIdType.name ?? '';
            _categoryText = _partner.partnerTypeIdType.name ?? '';
            _documentTypeText = _partner.idTypeIdType.name ?? '';
            _nationalityText =
                _partner.nationalityCountryRegionModel.cntyNm ?? '';
          } else if (_language == 'zh_CN') {
            _appellationText = _partner.appellationIdType.cname ?? '';
            _categoryText = _partner.partnerTypeIdType.cname ?? '';
            _documentTypeText = _partner.idTypeIdType.cname ?? '';
            _nationalityText =
                _partner.nationalityCountryRegionModel.cntyCnm ?? '';
          } else {
            _appellationText = _partner.appellationIdType.cname ?? '';
            _categoryText = _partner.partnerTypeIdType.cname ?? '';
            _documentTypeText = _partner.idTypeIdType.cname ?? '';
            _nationalityText =
                _partner.nationalityCountryRegionModel.cntyTcnm ?? '';
          }

          _nextBtnEnabled = _judgeButtonIsEnabled();
        }
      });
    }
  }
}
