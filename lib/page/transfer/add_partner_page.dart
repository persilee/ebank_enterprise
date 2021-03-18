/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-24

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/add_partner.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_single_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';

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
  final String _transferType_2 = S.current.transfer_type_2;
  var _nameController = TextEditingController();
  var _acountController = TextEditingController();
  var _smsController = TextEditingController();
  var _aliasController = TextEditingController();
  var _centerSwiftController = TextEditingController();
  var _payeeAdressController = TextEditingController();
  bool _showInternational = false; //国际转账
  var _alias = '';
  var words = 20;
  String _countryText = '';
  List<String> countryList = ['中国', '荷兰', '美国', '俄罗斯'];
  @override
  void initState() {
    super.initState();
    //备注最多输入words个文字
    _aliasController.addListener(() {
      String text = _aliasController.text;
      int length = text.length;

      if (length > words) {
        _alias += text.substring(0, (length ~/ words) * words);

        _aliasController.text = text.substring(words);
        _aliasController.selection =
            TextSelection.collapsed(offset: _aliasController.text.length);
      } else if (length == 0) {
        if (_alias != '') {
          _aliasController.text =
              _alias.substring(_alias.length - words, _alias.length);

          _aliasController.selection =
              TextSelection.collapsed(offset: _aliasController.text.length);
          _alias = _alias.substring(0, _alias.length - words);
        }
      }
    });
    //初始化
    _bankName = S.current.please_select;
    _branch = S.current.optional;
    _transferType = S.current.please_select;
    _swiftAdress = S.current.bank_swift;
  }

  _loadData() {
    String myTransferType;
    String _centerSwiftReq;
    String _payeeAdressReq;
    String _swiftAdressReq;
    String _branchReq;
    _branch == S.current.optional ? _branchReq = '' : _branchReq = _branch;
    if (_transferType == _transferType_0) {
      myTransferType = '0';
    } else if (_transferType == _transferType_2) {
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
    TransferDataRepository()
        .addPartner(
            AddPartnerReq(
                _bankCode,
                _swiftAdressReq,
                "",
                _branchReq,
                _centerSwiftReq,
                _payeeAdressReq,
                _acountController.text,
                _nameController.text,
                "",
                "",
                "",
                _smsController.text,
                _aliasController.text,
                myTransferType),
            'addPartner')
        .then((data) {
      print(data.toString());
      if (data != null) {
        Fluttertoast.showToast(msg: '添加成功');
        Navigator.of(context).pop();
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.add_payee),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
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
                    title: S.current.confirm, click: _confirm()),
              ),
            ],
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
        //户名
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 16),
          child: _inputFrame(
            S.current.receipt_side_name,
            _inputField(
                _nameController, S.current.please_input, TextInputType.text),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //账号
        Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: _inputFrame(
            S.current.receipt_side_account,
            _inputField(_acountController, S.current.please_input,
                TextInputType.number),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //转账类型
        GestureDetector(
          onTap: () {
            _transferTypeDialog();
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _inputFrame(
              S.current.transfer_type,
              _inputSelector(_transferType, S.of(context).please_select),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //银行
        GestureDetector(
          onTap: () {
            _bankTap(context);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _inputFrame(
              S.current.bank_name,
              _inputSelector(_bankName, S.of(context).please_select),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //分支行
        // GestureDetector(
        //   onTap: () {
        //     if (_bankName != S.current.please_select) {
        //       Navigator.pushNamed(context, pageSelectBranchBank,
        //               arguments: '招商银行')
        //           .then((data) {
        //         if (data != null) {
        //           setState(() {
        //             _branch = data;
        //             _check();
        //           });
        //         }
        //       });
        //     } else {
        //       _showBankTips(context);
        //     }
        //   },
        //   child: Container(
        //     color: Colors.white,
        //     padding: EdgeInsets.only(top: 16, bottom: 16),
        //     child: _inputFrame(
        //       S.current.branch_office,
        //       _inputSelector(_branch, S.current.optional),
        //     ),
        //   ),
        // ),
        // Divider(height: 0.5, color: HsgColors.divider),
        //国际转账部分
        _showInternational ? _getInternationalPart() : Container(),
        // Divider(height: 0.5, color: HsgColors.divider),
        // //短信通知
        // Container(
        //   padding: EdgeInsets.only(top: 16, bottom: 16),
        //   child: _inputFrame(
        //     S.current.sms_notification,
        //     _inputFieldIcon(
        //       _smsController,
        //       InkWell(
        //         onTap: () {
        //           _contact();
        //         },
        //         child: Image(
        //           color: HsgColors.accent,
        //           image: AssetImage(
        //               'images/transferIcon/transfer_features_icon/transfer_features_acount.png'),
        //           width: 21,
        //           height: 21,
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Divider(height: 0.5, color: HsgColors.divider),
        //别名 (备注)
        Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: _inputFrame(
            S.current.transfer_postscript,
            _inputField(
                _aliasController, S.current.word_limit_5, TextInputType.text),
          ),
        ),
      ],
    );
  }

  _bankTap(BuildContext context) {
    if (_transferType != S.current.please_select) {
      String _type;
      if (_transferType == _transferType_0) {
        _type = '0';
      } else if (_transferType == _transferType_2) {
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
            _bankCode = _bank.bankCode;
            _check();
          });
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
          //银行SWIFT
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _inputFrame(
              S.current.bank_swift,
              _mutableText(_swiftAdress, S.current.bank_swift),
            ),
          ),
          Divider(height: 0.5, color: HsgColors.divider),
          //中间行SWFIT
          Container(
            height: 48,
            child: _inputFrame(
              S.current.middle_bank_swift,
              _onlyTextField(_centerSwiftController),
            ),
          ),
          Divider(height: 0.5, color: HsgColors.divider),
          //国家地区
          SelectInkWell(
            title: S.current.state_area,
            item: _countryText,
            onTap: () {
              Navigator.pushNamed(context, countryOrRegionSelectPage)
                  .then((value) {
                setState(() {
                  _countryText = (value as CountryRegionModel).nameEN;
                });
              });
            },
          ),
          _payeeAdress(_payeeAdressController),
          Divider(height: 0.5, color: HsgColors.divider),
        ],
      ),
    );
  }

  //选择国家地区
  _selectCountry() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: '国家/地区',
            items: countryList,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _countryText = countryList[result];
        _check();
      });
    }
  }

  //转账类型弹窗
  _transferTypeDialog() {
    SinglePicker.showStringPicker(
      context,
      data: [S.current.transfer_type_0, S.current.transfer_type_2],
      title: S.current.transfer_type,
      clickCallBack: (int index, var str) {
        setState(() {
          _transferType = str;
          if (_transferType == S.current.transfer_type_2) {
            _showInternational = true;
          } else if (_transferType == S.current.transfer_type_0) {
            _showInternational = false;
            //初始化国际转账的内容
            _centerSwiftController.text = '';
            _payeeAdressController.text = '';
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
              keyboardType: TextInputType.number,
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

  //纯文本(初始灰色，有内容黑色)
  _mutableText(String _income, String _hint) {
    return _income == _hint
        ? Text(
            _income,
            style: TextStyle(
              fontSize: 14,
              color: HsgColors.textHintColor,
            ),
          )
        : Text(
            _income,
            style: TextStyle(fontSize: 14),
          );
  }

  //纯输入框(可不填)
  _onlyTextField(TextEditingController _inputController) {
    return Container(
      padding: EdgeInsets.only(right: 9),
      width: 170,
      child: TextField(
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        controller: _inputController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration.collapsed(
          border: InputBorder.none,
          hintText: S.current.can_be_empty,
          hintStyle: TextStyle(
            fontSize: 14,
            color: HsgColors.textHintColor,
          ),
        ),
        onChanged: (text) {},
      ),
    );
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        right,
      ],
    );
  }

  //通用文字输入框+图标
  Widget _inputFieldIcon(TextEditingController _inputController, Widget image) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 9),
          width: 170,
          child: TextField(
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            controller: _inputController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: S.current.please_input,
              hintStyle: TextStyle(
                fontSize: 14,
                color: HsgColors.textHintColor,
              ),
            ),
            onChanged: (text) {
              _check();
            },
          ),
        ),
        image,
      ],
    );
  }

  //通用文字输入框(传入监听器)
  Widget _inputField(TextEditingController _inputController, String hint,
      TextInputType inputType) {
    return Expanded(
      child: TextField(
        textAlign: TextAlign.end,
        keyboardType: inputType,
        controller: _inputController,
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: HsgColors.textHintColor,
          ),
        ),
        onChanged: (text) {
          _check();
        },
      ),
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

  //获取联系人
  _contact() async {
    ContactPicker _contactPicker = new ContactPicker();
    Contact contact = await _contactPicker.selectContact();
    setState(() {
      String text = contact.phoneNumber.toString();
      if (text.startsWith('+')) {
        text = text.substring(text.indexOf(' '), text.indexOf(' ('));
      } else {
        text = text.substring(0, text.indexOf(' ('));
      }
      text = text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      _smsController.text = text;
    });
  }

  //按钮可点击检查
  _check() {
    setState(() {
      if (_bankName != S.current.please_select &&
          _nameController.text.length > 0 &&
          _acountController.text.length > 0 &&
          _transferType != S.current.please_select) {
        if (_showInternational) {
          if (_payeeAdressController.text.length > 0 && _countryText != '') {
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
        _loadData();
      };
    } else {
      return null;
    }
  }
}
