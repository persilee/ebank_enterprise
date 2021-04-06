/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 开户-面签结果成功页面
/// Author: 李家伟
/// Date: 2021-03-22

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/model/auth_identity_bean.dart';
import 'package:ebank_mobile/data/source/model/face_sign_upload_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_information_supplement_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_data.dart';
import 'package:ebank_mobile/data/source/open_account_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenAccountIdentifyResultsSuccessfulPage extends StatefulWidget {
  const OpenAccountIdentifyResultsSuccessfulPage({Key key}) : super(key: key);

  @override
  _OpenAccountIdentifyResultsSuccessfulPageState createState() =>
      _OpenAccountIdentifyResultsSuccessfulPageState();
}

class _OpenAccountIdentifyResultsSuccessfulPageState
    extends State<OpenAccountIdentifyResultsSuccessfulPage> {
  AuthIdentityResp _valueData;

  ///快速开户信息补录转态，如果成功则不再调用快速开户信息补录接口
  int _state;

  ///是否是快速
  bool _isQuick;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _valueData = data['valueData'];
    _isQuick = data['isQuick'];
    print('${_valueData.toJson()}');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(S.of(context).openAccout_identify_results),
      ),
      body: Container(
        width: size.width,
        color: HsgColors.commonBackground,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Image(
                image: AssetImage(
                    'images/openAccount/open_account_identify_results_successful.png'),
                width: 138,
                height: 118,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 60),
              child: Text(
                S.of(context).openAccout_identify_results_successful,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 15),
              child: Text(
                S.of(context).openAccout_identify_results_successful_tip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HsgColors.secondDegreeText,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: HsgButton.defaultButton(
                title: S.of(context).complete,
                click: () {
                  if (_isQuick) {
                    ///快速开户
                    if (_state == 1) {
                      _quickAccountOpening();
                    } else {
                      _openAccountQuickSubmitData();
                    }
                  } else {
                    ///完整开户面签
                    _saveSignVideoNetwork();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ///快速开户成功提示
  void _showTypeTips(BuildContext context) {
    EventBusUtils.getInstance()
        .fire(GetUserEvent(msg: "通知重新获取用户信息getUser", state: 200));

    HsgShowTip.openAccountSuccessfulTip(
      context,
      (value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return IndexPage();
          }),
          (Route route) {
            //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
            print(route.settings?.name);
            if (route.settings?.name == "/") {
              return true; //停止关闭
            }
            return false; //继续关闭
          },
        );
      },
    );
  }

  ///完整开户面签成功弹窗提示
  void _showTypeTipsForFaceSign(BuildContext context) {
    HsgShowTip.openAccountSuccessfulTip(
      context,
      (value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return IndexPage();
          }),
          (Route route) {
            //一直关闭，直到我的时停止，停止时，整个应用只有我的和当前页面
            print(route.settings?.name);
            if (route.settings?.name == minePage) {
              //'/'
              return true; //停止关闭
            }
            return false; //继续关闭
          },
        );
      },
    );
  }

  //面签数据补录
  void _openAccountQuickSubmitData() async {
    final prefs = await SharedPreferences.getInstance();
    String phoneStr = prefs.getString(ConfigKey.USER_PHONE);

    HSProgressHUD.show();
    OpenAccountInformationSupplementDataReq dataReq = _getDataReq(phoneStr);
    OpenAccountRepository()
        .supplementQuickPartnerInfo(dataReq, 'supplementQuickPartnerInfo')
        .then(
      (value) {
        print(value);
        HSProgressHUD.dismiss();
        _state = value.state;
        if (value.state == 1) {
          ///成功，前往调用通知开户接口
          _quickAccountOpening();
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

  //快速开户
  void _quickAccountOpening() async {
    String businessId = _valueData.businessId;
    if (businessId.contains('-')) {
      List dataList = businessId.split('-');
      if (dataList.length > 0) {
        businessId = dataList[0];
      }
    }

    OpenAccountQuickReq quickReq = OpenAccountQuickReq(businessId: businessId);

    HSProgressHUD.show();
    OpenAccountRepository()
        .quickAccountOpening(quickReq, 'quickAccountOpening')
        .then(
      (value) {
        HSProgressHUD.dismiss();
        _showTypeTips(context);
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

  //保存面签视频名称（完整开户面签数据）
  void _saveSignVideoNetwork() async {
    final prefs = await SharedPreferences.getInstance();
    String phoneStr = prefs.getString(ConfigKey.USER_PHONE);

    HSProgressHUD.show();
    String businessId = _valueData.businessId ?? '';
    String fileName = _valueData.fileName ?? '';
    String idNo = '';
    if (_valueData.certificateType == '1') {
      InfoStrForCN infoStr = _valueData.infoStr;
      idNo = infoStr.idNum ?? '';
    } else if (_valueData.certificateType == '2') {
      InfoStrForHK infoStr = _valueData.infoStr;
      idNo = infoStr.idNum ?? '';
    } else {
      InfoStrForPassport infoStr = _valueData.infoStr;
      idNo = infoStr.idNum ?? '';
    }
    String certificateType = _valueData.certificateType ?? '';
    List<SpeechFlowData> speechFlowData = _valueData.speechFlowData;

    List<SpeechFlowDataHS> speechFlowDataHSList = [];
    speechFlowData.forEach((element) {
      SpeechFlowDataHS speechFlowDataHS = SpeechFlowDataHS(
        element.problem,
        element.timer,
        element.answerArr.length > 0
            ? element.answerArr[element.answerArr.length - 1]
            : '',
      );
      speechFlowDataHSList.add(speechFlowDataHS);
    });

    FaceSignUploadDataReq dataReq = FaceSignUploadDataReq(businessId, fileName,
        phoneStr, certificateType, idNo, speechFlowDataHSList);
    OpenAccountRepository().saveSignVideo(dataReq, 'saveSignVideo').then(
      (value) {
        print(value);
        HSProgressHUD.dismiss();
        if (value.state == '1') {
          _showTypeTipsForFaceSign(context);
        }
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

  ///面签数据转换（面签返回的时间格式不正确，不能直接使用）
  OpenAccountInformationSupplementDataReq _getDataReq(String phoneStr) {
    // Map valueMap = _valueData.toJson();

    String businessId = _valueData.businessId;
    if (businessId.contains('-')) {
      List dataList = businessId.split('-');
      if (dataList.length > 0) {
        businessId = dataList[0];
      }
    }
    OpenAccountInformationSupplementDataReq dataReq =
        OpenAccountInformationSupplementDataReq();
    // dataReq = OpenAccountInformationSupplementDataReq.fromJson(valueMap);
    dataReq.headerPic = 'headerPic'; //_valueData.headerImg;
    dataReq.idPic = 'idPic'; //_valueData.positiveImage;
    dataReq.idPicBack = 'idPicBack'; //_valueData.backImage;
    dataReq.phone = phoneStr;
    dataReq.businessId = businessId;
    dataReq.certificateType = _valueData.certificateType;
    // dataReq.compareImageData = _valueData.compareImageData;
    dataReq.tenantId = _valueData.tenantId;
    dataReq.videoUrl = _valueData.videoUrl;

    dataReq.isSuccess = _valueData.isSuccess == true ? '1' : '0';

    // Map infoStrForMap = jsonDecode(_valueData.infoStr);

    InfoStrForCN infoStrForCN;
    InfoStrForHK infoStrForHK;
    InfoStrForPassport infoStrForPassport;
    switch (_valueData.certificateType) {
      case '1':
        infoStrForCN = InfoStrForCN.fromJson(_valueData.infoStr);
        dataReq.mainlandCertificateInfo = ChinaMainlandCertificateInfoDTO();
        dataReq.mainlandCertificateInfo.fullNameLoc = infoStrForCN.name;
        dataReq.mainlandCertificateInfo.idNo = infoStrForCN.idNum;
        dataReq.mainlandCertificateInfo.gender = infoStrForCN.sex;
        dataReq.mainlandCertificateInfo.nation = infoStrForCN.nation;
        dataReq.mainlandCertificateInfo.birthdate =
            infoStrForCN.birth.replaceAll('/', '-');
        dataReq.mainlandCertificateInfo.address = infoStrForCN.address;
        dataReq.mainlandCertificateInfo.issuingAuthority =
            infoStrForCN.authority;
        if (infoStrForCN.validDate.contains('-')) {
          List dataList = infoStrForCN.validDate.split('-');
          if (dataList.length > 1) {
            dataReq.mainlandCertificateInfo.idIssueDate =
                dataList[0].replaceAll('.', '-');
            dataReq.mainlandCertificateInfo.idDueDate =
                dataList[1].replaceAll('.', '-');
          } else {
            dataReq.mainlandCertificateInfo.idIssueDate =
                infoStrForCN.validDate.replaceAll('.', '-');
          }
        } else {
          dataReq.mainlandCertificateInfo.idIssueDate =
              infoStrForCN.validDate.replaceAll('.', '-');
        }

        break;

      case '2':
        infoStrForHK = InfoStrForHK.fromJson(_valueData.infoStr);
        dataReq.hkCertificateInfo = HKCertificateInfoDTO();
        dataReq.hkCertificateInfo.fullNameLoc = infoStrForHK.name;
        dataReq.hkCertificateInfo.idNo = infoStrForHK.idNum;
        dataReq.hkCertificateInfo.fullNameEng = infoStrForHK.enName;
        dataReq.hkCertificateInfo.telexCode = infoStrForHK.telexCode;
        dataReq.hkCertificateInfo.gender = infoStrForHK.sex;
        dataReq.hkCertificateInfo.symbol = infoStrForHK.symbol;
        dataReq.hkCertificateInfo.birthdate =
            infoStrForHK.birthday.replaceAll('/', '-');
        dataReq.hkCertificateInfo.firthIssueDate = infoStrForHK.firstIssueDate;
        dataReq.hkCertificateInfo.currentIssueDate =
            infoStrForHK.currentIssueDate;
        break;

      case '3':
        infoStrForPassport = InfoStrForPassport.fromJson(_valueData.infoStr);
        dataReq.passportInfo = PassportInfoDTO();
        dataReq.passportInfo.fullNameLoc = infoStrForPassport.name;
        dataReq.passportInfo.idNo = infoStrForPassport.idNum;
        dataReq.passportInfo.gender = infoStrForPassport.sex;
        dataReq.passportInfo.nationality = infoStrForPassport.nationality;
        dataReq.passportInfo.birthdate =
            infoStrForPassport.dateOfBirth.replaceAll('/', '-');
        dataReq.passportInfo.issuingCountry = infoStrForPassport.issuingCountry;
        if (infoStrForPassport.dateOfExpiration.contains('-')) {
          List dataList = infoStrForPassport.dateOfExpiration.split('-');
          if (dataList.length > 1) {
            dataReq.passportInfo.idIssueDate = dataList[0].replaceAll('.', '-');
            dataReq.passportInfo.idDueDate = dataList[1].replaceAll('.', '-');
          } else {
            dataReq.passportInfo.idIssueDate =
                infoStrForPassport.dateOfExpiration.replaceAll('.', '-');
          }
        } else {
          dataReq.passportInfo.idIssueDate =
              infoStrForPassport.dateOfExpiration.replaceAll('.', '-');
        }
        break;
      default:
    }

    return dataReq;
  }

  List<String> _changeTimeData(String dateStr, bool isSplit) {
    List<String> resultDataList = [];
    if (isSplit == true) {
      if (dateStr.contains('-')) {
        List dataList = dateStr.split('-');
        if (dataList.length > 1) {
          resultDataList.add(_changeTimeString(dataList[0]));
          resultDataList.add(_changeTimeString(dataList[1]));
        } else {
          resultDataList.add(_changeTimeString(dateStr));
        }
      } else {
        resultDataList.add(_changeTimeString(dateStr));
      }
    } else {
      resultDataList.add(_changeTimeString(dateStr));
    }
    return resultDataList;
  }

  String _changeTimeString(String dateStr) {
    String dateString = dateStr.replaceAll('.', '-');
    dateString = dateStr.replaceAll('/', '-');
    if (dateString.contains('-')) {
      List<String> dataList = dateString.split('-');
      if (dataList.length > 2) {
        String year = dataList[0];
        String month = dataList[1];
        String day = dataList[2];
        if (month.length == 1) {
          month = '0' + month;
        }
        if (day.length == 1) {
          day = '0' + day;
        }
        dateString = year + '-' + month + '-' + day;
      }
    }
    return dateString;
  }
}
