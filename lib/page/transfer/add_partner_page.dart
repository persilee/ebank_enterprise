/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-24

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/add_partner.dart';
import 'package:ebank_mobile/data/source/model/approval/get_card_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/get_info_by_swift_code.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_transfer.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_single_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:intl/intl.dart';

class AddPartnerPage extends StatefulWidget {
  @override
  _AddPartnerPageState createState() => _AddPartnerPageState();
}

class _AddPartnerPageState extends State<AddPartnerPage> {
  var _isInputed = false; //按钮可点击标志
  var _bankName = '';
  var _branch = '';
  var _transferType = '';
  var _swiftAdress = '';
  var _bankCode = '';
  final String _transferType_0 = S.current.transfer_type_0;
  final String _transferType_1 = S.current.transfer_type_1;
  var _nameController = TextEditingController();
  var _acountController = TextEditingController();
  var _smsController = TextEditingController();
  var _aliasController = TextEditingController();
  var _centerSwiftController = TextEditingController();
  var _payeeAdressController = TextEditingController();
  var _bankSwiftController = TextEditingController();
  var _bankNameController = TextEditingController();
  // var _bankSwiftController = TextEditingController();
  bool _showInternational = false; //国际转账
  var _alias = '';
  var words = 20;
  String _countryText = '';
  String _countryCode = '';
  List<String> countryList = [];
  String _language = Intl.getCurrentLocale();
  //转账费用
  String _transferFee = '';
  List<String> transferFeeList = [];
  List<String> transferFeeCodeList = [];
  String _transferFeeCode = '';
  int _transferFeeIndex = 0;
  //汇款用途
  String _feeUse = '';
  List<String> feeUse = [];
  int _feeUseIndex = 0;
  //币种
  String _ccy = '';
  List<String> _ccyList = [];
  int _ccyIndex = 0;

  var _swiftFocusNode = FocusNode();
  var _accountFocusNode = FocusNode();
  bool _isAccount = false; //行内转账时，账号是否存在

  bool _isSelect = true;
  @override
  void initState() {
    super.initState();
    _getTransferFeeList();
    _loadLocalCcy();
    //初始化
    _bankName = S.current.please_select;
    _branch = S.current.optional;
    _transferType = S.current.transfer_type_0;
    _swiftAdress = S.current.bank_swift;
    _swiftFocusNode.addListener(() {
      if (_bankSwiftController.text.length == 11 && !_swiftFocusNode.hasFocus) {
        _getBankNameBySwift(_bankSwiftController.text);
      }
    });
    _accountFocusNode.addListener(() {
      if (_acountController.text.length > 0 &&
          _transferType == S.current.transfer_type_0 &&
          !_accountFocusNode.hasFocus) {
        _getCardByCardNo(_acountController.text);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _acountController.dispose();
    _smsController.dispose();
    _aliasController.dispose();
    _centerSwiftController.dispose();
    _payeeAdressController.dispose();
    _swiftFocusNode.dispose();
    _accountFocusNode.dispose();
  }

//获取转账费用列表
  Future _getTransferFeeList() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("PAY_METHOD")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        transferFeeList.clear();
        transferFeeCodeList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          if (_language == 'zh_CN' || _language == 'zh_HK') {
            transferFeeList.add(e.cname);
            transferFeeCodeList.add(e.code);
          } else {
            transferFeeList.add(e.name);
            transferFeeCodeList.add(e.code);
          }
        });
      }
    });
  }

  //加载数据
  _loadData() {
    String myTransferType;
    String _centerSwiftReq;
    String _payeeAdressReq;
    String _swiftAdressReq;
    String _branchReq;
    _branch == S.current.optional ? _branchReq = '' : _branchReq = _branch;
    if (_transferType == _transferType_0) {
      myTransferType = '0';
    } else if (_transferType == _transferType_1) {
      myTransferType = '2';
    }
    if (_showInternational) {
      _centerSwiftReq = _centerSwiftController.text;
      _payeeAdressReq = _payeeAdressController.text;
      _swiftAdressReq = _swiftAdress;
    } else {
      _centerSwiftReq = '';
      _payeeAdressReq = '';
      _swiftAdressReq = '';
    }
    String payeeBankEnName = '';
    String payeeBankLocalName = '';
    if (_language == 'zh_CN' || _language == 'zh_HK') {
      setState(() {
        if (_transferType == _transferType_0) {
          payeeBankLocalName = "智朗银行";
        } else {
          payeeBankLocalName = _bankNameController.text;
        }
      });
    } else {
      setState(() {
        if (_transferType == _transferType_0) {
          payeeBankEnName = "Brillink bank";
        } else {
          payeeBankEnName = _bankNameController.text;
        }
      });
    }
    Transfer()
        .addPartner(AddPartnerReq(
      _bankCode,
      _bankSwiftController.text, //_swiftAdressReq,
      _ccy,
      "",
      _countryCode, //_countryText,
      _centerSwiftReq,
      _payeeAdressReq,
      _acountController.text,
      _nameController.text,
      "",
      "",
      "",
      _smsController.text,
      payeeBankEnName,
      payeeBankLocalName,
      _aliasController.text,
      myTransferType,
      // _transferFeeIndex.toString(),
      _transferFeeCode,
      _feeUseIndex.toString(),
    ))
        .then((data) {
      if (data != null) {
        Fluttertoast.showToast(
          msg: S.current.add_successful,
          gravity: ToastGravity.CENTER,
        );
        Navigator.of(context).pop();
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.add_payee),
        centerTitle: true,
        elevation: 1,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: HsgColors.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //输入数据容器
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: formColumn(),
                ),
                //按钮容器
                Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: HsgButton.button(
                    title: S.current.confirm,
                    click: _confirm(),
                    isColor: _isInputed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column formColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //伙伴信息
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            S.current.partner_information,
            style: TextStyle(color: HsgColors.secondDegreeText, fontSize: 13),
          ),
        ),
        //转账类型
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _transferTypeDialog();
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: _inputFrame(
              S.current.transfer_type,
              _inputSelector(_transferType, S.of(context).please_select),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        TextFieldContainer(
          title: S.current.receipt_side_account,
          hintText: S.current.please_input,
          keyboardType: TextInputType.number,
          controller: _acountController,
          focusNode: _accountFocusNode,
          callback: _check,
          length: 20,
          isRegEXp: true,
          regExp: '[0-9]',
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //户名
        TextFieldContainer(
          title: S.current.receipt_side_name,
          hintText: S.current.please_input,
          keyboardType: TextInputType.text,
          controller: _nameController,
          callback: _check,
          length: 35,
          isRegEXp: true,
          regExp: _transferType == S.current.transfer_type_0
              ? '[\u4e00-\u9fa5a-zA-Z0-9 \-\/\?\:\(\)\.\,\'\+]'
              : '[a-zA-z0-9 \-\/\?\:\(\)\.\,\'\+]',
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //收款方币种
        SelectInkWell(
          title: S.current.transfer_from_ccy,
          item: _ccy,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _payCcyDialog();
          },
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //国际转账部分
        _showInternational ? _getInternationalPart() : Container(),
        //转账附言
        TextFieldContainer(
          title: S.current.transfer_postscript,
          hintText: S.current.not_required,
          keyboardType: TextInputType.text,
          controller: _aliasController,
          callback: _check,
          length: 140,
        ),
      ],
    );
  }

  _bankTap(BuildContext context) {
    if (_transferType != S.current.please_select) {
      String _type;
      if (_transferType == _transferType_0) {
        _type = '0';
      } else if (_transferType == _transferType_1) {
        _type = '2';
      }
      Navigator.pushNamed(context, pageSelectBank, arguments: _type)
          .then((data) {
        if (data != null) {
          Banks _bank;
          setState(() {
            _bank = data;
            _bankName = _bank.localName;
            _swiftAdress = _bank.bankSwift;
            _bankSwiftController.text = _bank.bankSwift;
            _bankCode = _bank.bankCode;
            _check();
          });
        } else {
          _isSelect = false;
        }
      });
    } else {
      _showTypeTips();
    }
  }

  //提示弹窗(提示语句，确认事件)
  _showTypeTips() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.current.prompt,
            message: S.current.select_transfer_type_first,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      if (value == true) {
        _transferTypeDialog();
      }
    });
  }

  //提示弹窗(提示语句，确认事件)
  _showBankTips(BuildContext homeContext) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.current.prompt,
            message: S.current.select_bank_first,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      if (value == true) {
        _bankTap(homeContext);
      }
    });
  }

  //国际转账需要输入的部分
  _getInternationalPart() {
    return Container(
      child: Column(
        children: [
          //国家地区
          SelectInkWell(
            title: S.current.state_area,
            item: _countryText,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pushNamed(context, countryOrRegionSelectPage)
                  .then((value) {
                setState(() {
                  switch (_language) {
                    case 'zh_CN':
                      _countryText = (value as CountryRegionNewModel).cntyCnm;
                      break;
                    case 'zh_HK':
                      _countryText = (value as CountryRegionNewModel).cntyTcnm;
                      break;
                    default:
                      _countryText = (value as CountryRegionNewModel).cntyNm;
                  }
                  _countryCode = (value as CountryRegionNewModel).cntyCd;
                });
              });
            },
          ),
          Divider(height: 0.5, color: HsgColors.divider),
          //银行SWIFT
          TextFieldContainer(
            title: S.current.bank_swift,
            hintText: S.current.please_input,
            keyboardType: TextInputType.text,
            controller: _bankSwiftController,
            focusNode: _swiftFocusNode,
            callback: _check,
            length: 11,
            isUpperCase: true,
            isRegEXp: true,
            regExp: '[a-zA-Z0-9]',
          ),
          Divider(height: 0.5, color: HsgColors.divider),
          //银行名称
          TextFieldContainer(
            title: S.current.receipt_bank,
            hintText: S.current.please_input,
            keyboardType: TextInputType.text,
            controller: _bankNameController,
            callback: _check,
            length: 30,
          ),
          Divider(height: 0.5, color: HsgColors.divider),
          //收款地址
          _payeeAdress(_payeeAdressController),
          Divider(height: 0.5, color: HsgColors.divider),
          //转账费用
          SelectInkWell(
            title: S.current.Transfer_fee,
            item: _transferFee,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectTransferFee();
            },
          ),
          Divider(height: 0.5, color: HsgColors.divider),
          //汇款用途
          // SelectInkWell(
          //   title: S.current.remittance_usage,
          //   item: _feeUse,
          //   onTap: () {
          //     FocusScope.of(context).requestFocus(FocusNode());
          //     _selectFeeUse();
          //   },
          // ),
          // Divider(height: 0.5, color: HsgColors.divider),
        ],
      ),
    );
  }

  //转账费用
  _selectTransferFee() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: S.current.Transfer_fee,
            items: transferFeeList,
          );
        });
    if (result != null && result != false) {
      _transferFee = transferFeeList[result];
      _transferFeeCode = transferFeeCodeList[result];
    }
    setState(() {
      _transferFeeIndex = result;
      _check();
    });
  }

  //汇款用途
  _selectFeeUse() async {
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return BottomMenu(
          title: S.current.remittance_usage,
          items: feeUse,
        );
      },
    );
    if (result != null && result != false) {
      _feeUse = feeUse[result];
    }
    setState(() {
      _feeUseIndex = result;
      _check();
    });
  }

  //转账类型弹窗
  _transferTypeDialog() {
    SinglePicker.showStringPicker(
      context,
      data: [S.current.transfer_type_0, S.current.transfer_type_1],
      title: S.current.transfer_type,
      clickCallBack: (int index, var str) {
        setState(() {
          _transferType = str;
          if (_transferType == S.current.transfer_type_1) {
            _showInternational = true;
            _isAccount = true;
            //初始化行内转账的内容
            _acountController.text = '';
            _nameController.text = '';
            _ccy = '';
            _aliasController.text = '';
            _ccyIndex = 0;
          } else if (_transferType == S.current.transfer_type_0) {
            _showInternational = false;
            _isAccount = false;
            //初始化国际转账的内容
            _centerSwiftController.text = '';
            _payeeAdressController.text = '';
            _acountController.text = '';
            _nameController.text = '';
            _ccy = '';
            _aliasController.text = '';
            _countryText = '';
            _bankSwiftController.text = '';
            _bankNameController.text = '';
            _transferFee = '';
            _ccyIndex = 0;
          }
          _check();
        });
      },
    );
  }

  //收款人地址
  Widget _payeeAdress(TextEditingController _inputController) {
    var inputRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Container(
            width: 170,
            height: 21,
            child: TextField(
              controller: _inputController,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(105), //限制长度
                FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-z0-9 \-\/\?\:\(\)\.\,\'\+]')),
              ],
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: S.current.payee_address,
                hintStyle: TextStyle(color: HsgColors.hintText, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                _check();
              },
            ),
          ),
        ),
      ],
    );
    return Container(
        padding: EdgeInsets.only(top: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    S.current.payee_address,
                    style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                  ),
                ),
              ],
            ),
            //收款人地址输入框
            inputRow,
          ],
        ));
  }

  //通用框(传入左边内容和右边组件)
  Widget _inputFrame(String left, Widget right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150,
          child: Text(
            left,
            style: TextStyle(color: HsgColors.firstDegreeText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        right,
      ],
    );
  }

  //通用选择器
  Widget _inputSelector(String _income, String _hint) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: 170,
          padding: EdgeInsets.only(right: 12),
          child: _income == _hint
              ? Text(
                  _income,
                  style: TextStyle(
                    fontSize: 14,
                    color: HsgColors.textHintColor,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  _income,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        Image(
          color: HsgColors.nextPageIcon,
          image: AssetImage('images/home/listIcon/home_list_more_arrow.png'),
          width: 10,
          height: 10,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  //按钮可点击检查
  _check() {
    setState(() {
      if (_nameController.text.length > 0 &&
              _acountController.text.length > 0 &&
              _transferType != S.current.please_select &&
              _ccy != ''
          // &&_isAccount
          ) {
        if (_showInternational) {
          if (_bankNameController.text != '' &&
              _payeeAdressController.text.length > 0 &&
              _countryText != '' &&
              _transferFee != '' &&
              // _feeUse != '' &&
              _bankSwiftController.text != '') {
            _isInputed = true;
          } else {
            _isInputed = false;
          }
        } else {
          _isInputed = true;
        }
      } else {
        _isInputed = false;
      }
    });
  }

  //确认按钮点击事件
  _confirm() {
    if (_isInputed) {
      return () {
        if (_isAccount) {
          _loadData();
        } else {
          Fluttertoast.showToast(
            msg: S.current.account_no_exist,
            gravity: ToastGravity.CENTER,
          );
        }
      };
    } else {
      return null;
    }
  }

  //币种弹窗
  Future _payCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _ccyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _ccyIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _ccyIndex = result;
        _ccy = _ccyList[result];
      });
      _check();
    }
  }

  // 获取币种列表
  Future _loadLocalCcy() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("CCY")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _ccyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _ccyList.add(e.code);
        });
      }
    });
  }

  //根据银行Swift查询银行名称
  Future _getBankNameBySwift(String swift) async {
    Transfer().getInfoBySwiftCode(GetInfoBySwiftCodeReq(swift)).then((data) {
      if (this.mounted) {
        setState(() {
          _bankNameController.text =
              data.swiftName1 + data.swiftName2 + data.swiftName3;
        });
      }
    }).catchError(() {
      // Fluttertoast.showToast(
      //   msg: "银行SWIFT不存在",
      //   gravity: ToastGravity.CENTER,
      // );
    });
  }

  //根据账号查询名称
  Future _getCardByCardNo(String cardNo) async {
    Transfer().getCardByCardNo(GetCardByCardNoReq(cardNo)).then((data) {
      if (this.mounted) {
        setState(() {
          _nameController.text = data.ciName;
          _isAccount = true;
          if (_ccy != '') {
            _isInputed = true;
          } else {
            _isInputed = false;
          }
        });
      }
    }).catchError((e) {
      if (this.mounted) {
        setState(() {
          _isAccount = false;
        });
      }
      if (e.toString().contains("SC6121")) {
        Fluttertoast.showToast(
          msg: S.of(context).request_client_timeout,
          gravity: ToastGravity.CENTER,
        );
      } else if (e.toString().contains("CI0114")) {
        Fluttertoast.showToast(
          msg: S.current.no_account,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }
}
