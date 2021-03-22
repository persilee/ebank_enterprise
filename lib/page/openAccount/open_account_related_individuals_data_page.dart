import 'package:ebank_mobile/authentication/auth_identity.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/model/auth_identity_bean.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
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

  @override
  void initState() {
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
        title: Text('有关人士信息预填'),
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
                          _qianliyanSDK();
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
          '有关人士信息',
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
          '称谓',
          _appellationText,
          S.of(context).please_select,
          false,
          () {
            print('称谓');
            _nextBtnEnabled = _judgeButtonIsEnabled();
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          '类别',
          _categoryText,
          S.of(context).please_select,
          false,
          () {
            print('类别');
            _nextBtnEnabled = _judgeButtonIsEnabled();
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          '证件类型',
          _documentTypeText,
          S.of(context).please_select,
          false,
          () {
            print('证件类型');
            _nextBtnEnabled = _judgeButtonIsEnabled();
          },
        ),
      ),
      Container(
        child: _oneLayerSelectWidget(
          context,
          '国籍（国家地区）',
          _nationalityText,
          S.of(context).please_select,
          false,
          () {
            print('国籍（国家地区）');
            _nextBtnEnabled = _judgeButtonIsEnabled();
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

  void _qianliyanSDK() {
    String _language = Intl.getCurrentLocale();
    String lang = _language == 'en' ? 'en' : 'zh';
    String countryRegions = _language == 'zh_CN' ? 'CN' : 'TW';

    AuthIdentity()
        .startAuth(
      new AuthIdentityReq("DLEAED", "74283428974321", lang, countryRegions,
          "1"), //passport001zh  DLEAED
    )
        .then((value) {
      Fluttertoast.showToast(
        msg: value.result,
        gravity: ToastGravity.CENTER,
      );
      Navigator.pushNamed(context,
          pageOpenAccountIdentifySuccessfulFailure); //pageOpenAccountIdentifySuccessfulFailure//pageOpenAccountIdentifyResultsFailure
    }).catchError((e) {
      // HSProgressHUD.showError(status: '${e.toString()}');
      Fluttertoast.showToast(
        msg: '${e.toString()}',
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
