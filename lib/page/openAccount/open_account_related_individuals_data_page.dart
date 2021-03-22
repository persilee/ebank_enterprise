import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class RelatedIndividualsDataPage extends StatefulWidget {
  RelatedIndividualsDataPage({Key key}) : super(key: key);

  @override
  _RelatedIndividualsDataPageState createState() =>
      _RelatedIndividualsDataPageState();
}

class _RelatedIndividualsDataPageState
    extends State<RelatedIndividualsDataPage> {
  /// 称谓
  String _appellationText = '';

  /// 类别
  String _categoryText = '';

  /// 证件类型
  String _documentTypeText = '';

  /// 国籍（国家地区）
  String _nationalityText = '';

  /// 下一步按钮是否能点击
  bool _nextBtnEnabled = true; //false;

  ///称谓请求类型
  List<IdType> _appellationTypes = [];

  ///类别请求类型
  List<IdType> _categoryTypes = [];

  ///证件类型请求类型
  List<IdType> _documentTypes = [];

  @override
  void initState() {
    _getPublicParameters();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
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
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: HsgButton.button(
                  title: S.of(context).next_step,
                  click: _nextBtnEnabled
                      ? () {
                          Navigator.pushNamed(
                              context, pageOpenAccountSelectDocumentType);
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
    if (_appellationText == null || _appellationText == '') {
      return false;
    }
    if (_categoryText == null || _categoryText == '') {
      return false;
    }
    if (_documentTypeText == null || _documentTypeText == '') {
      return false;
    }
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
            // _nextBtnEnabled = _judgeButtonIsEnabled();
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
            // _nextBtnEnabled = _judgeButtonIsEnabled();
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
            // _nextBtnEnabled = _judgeButtonIsEnabled();
            _selectDocumentType(context);
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          S.of(context).openAccout_nationality,
          _nationalityText,
          S.of(context).please_select,
          false,
          () {
            print('国籍（国家地区）');
            // _nextBtnEnabled = _judgeButtonIsEnabled();
            Navigator.pushNamed(context, countryOrRegionSelectPage)
                .then((value) {
              setState(() {
                _nationalityText = (value as CountryRegionModel).nameEN;
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
      'Mr', // 先生
      'Mrs', // 太太
      'Miss', // 小姐
      'Ms', // 女士
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
        title: S.of(context).openAccount_documentType_select,
        items: appellationList,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _documentTypeText = appellationList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 类别输入值
  void _selectCategory(BuildContext context) async {
    List<String> categoryList = [
      'Sole Proprietor', // 獨資經營者
      'Partner', // 合夥人
      'Director', // 董事
      'Legal Representative', //企業法人
      'Authorised Signatory', //授權簽署人
      'Ultimate Beneficial Owner', //最終實益擁有人
      'Key Controller', //主要管理人
      'Direct Appointee', //受任人
      'Contact Person', //聯絡人
      'Primary Users of Ebank', //網上理財主要使用者
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
        title: S.of(context).openAccount_documentType_select,
        items: categoryList,
      ),
    );

    if (result != null && result != false) {
      setState(() {
        _documentTypeText = categoryList[result];
        _nextBtnEnabled = _judgeButtonIsEnabled();
      });
    } else {
      return;
    }
  }

  /// 证件类型输入值
  void _selectDocumentType(BuildContext context) async {
    List<String> documentList = [
      'Identity Card', //身分證
      'Passport', //護照
      'Other', //其他:
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
}
