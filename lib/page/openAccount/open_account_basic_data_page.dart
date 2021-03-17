import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

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

  /// 登记证件类型输入值
  String _documentTypeText = '';

  /// 登记证件号码输入值
  String _documentNumberText = '';

  /// 公司类别输入值
  String _companyTypeText = '';

  /// 公司类别（其他）输入值
  String _companyTypeOtherText = '';

  /// 注册国家地区输入值
  String _countryOrRegionText = '';

  /// 商业/行业性质输入值
  String _industrialNatureText = '';

  /// 下一步按钮是否能点击
  bool _isShowCompanyTypeOther = false;

  /// 下一步按钮是否能点击
  bool _nextBtnEnabled = true; //false;

  TextEditingController textEC = TextEditingController();
  int textFieldTag = 0;


  @override
  void initState() {
    textEC.addListener(() {
      if (textFieldTag == 1001) {
        _companyNameEngText = textEC.text;
      }
      if (textFieldTag == 1002) {
        _companyNameCNText = textEC.text;
      }
      if (textEC.text.length == 1) {
        setState(() {
          _nextBtnEnabled = _judgeButtonIsEnabled();
        });
      } else if (textEC.text.length == 0) {
        setState(() {
          _nextBtnEnabled = _judgeButtonIsEnabled();
        });
      }
    });
    super.initState();
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
                          print(_companyNameEngText);
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
    if (_companyTypeOtherText == null || _companyTypeOtherText == '') {
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
              _companyNameEngText,
              '请输入公司名称（英文）',
              false,
              1001,
            ),
          ),
          Container(
            child: _twoLayerInputWidget(
              context,
              '公司名称（中文）',
              _companyNameCNText,
              '请输入公司名称（中文）',
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
              _documentNumberText,
              '请输入登记证件号码',
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
                    _companyTypeOtherText,
                    '请输入公司类别（其他）',
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
    String textStr,
    String placeholderStr,
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
              controller: textEC,
              // obscureText: this.isCiphertext,
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
    String textStr,
    String placeholderStr,
    bool isHiddenLine,
    int textFieldTag,
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
                controller: textEC,
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
      });
    } else {
      return;
    }
  }
}
