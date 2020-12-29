/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-24

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/add_partner.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:contact_picker/contact_picker.dart';

class AddPartnerPage extends StatefulWidget {
  @override
  _AddPartnerPageState createState() => _AddPartnerPageState();
}

class _AddPartnerPageState extends State<AddPartnerPage> {
  var _isInputed = false; //按钮可点击标志
  var _bank = '';
  var _location = '';
  var _branch = '';
  var _nameController = TextEditingController();
  var _acountController = TextEditingController();
  var _smsController = TextEditingController();
  var _aliasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //备注监听器(限制5个字数)
    _nameController.addListener(() { 
      _check();
    });
    _acountController.addListener(() { 
      _check();
    });
    _smsController.addListener(() { 
      _check();
    });

    _aliasController.addListener(() {
      String text = _aliasController.text;
      int length = text.length;
      if (length > 5) {
        _aliasController.text = text.substring(0, 5);
        _aliasController.selection =
            TextSelection.collapsed(offset: _aliasController.text.length);
      }
    });
    //初始化
    _bank = S.current.please_select;
    _location = S.current.please_select;
    _branch = S.current.optional;
  }

  Future<void> _loadData() async {
    TransferDataRepository()
        .addPartner(
            AddPartnerReq(
                "",
                _bank,
                _location,
                _branch,
                "",
                "",
                _acountController.text,
                _nameController.text,
                "",
                "",
                "",
                _smsController.text,
                _aliasController.text,
                "0"),
            'addPartner')
        .then((data) {
      print(data.toString());
      if (data != null) {}
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.add_partner),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //输入数据容器
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: formColumn(),
              ),
              //按钮容器
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: _confirmButton(),
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
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            S.current.partner_information,
            style: TextStyle(color: HsgColors.hintText, fontSize: 13),
          ),
        ),
        //户名
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 16),
          child: _inputFrame(
            S.current.account_name,
            _inputField(_nameController, S.current.please_input),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //账号
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: _inputFrame(
            S.current.account_number,
            _inputFieldIcon(
              _acountController,
              InkWell(
                onTap: () {
                  Fluttertoast.showToast(msg: '点击扫描');
                },
                child: Image(
                  color: Colors.blueAccent,
                  image: AssetImage(
                      'images/transferIcon/transfer_features_icon/transfer_features_scan.png'),
                  width: 21,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //银行
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, pageSelectBank).then((data) {
              if (data != null) {
                setState(() {
                  _bank = data;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _inputFrame(
              S.current.bank,
              _inputSelector(_bank, S.of(context).please_select),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //开户地
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, pageSelectCity).then((data) {
              if (data != null) {
                setState(() {
                  _location = data;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _inputFrame(
              S.current.open_account_place,
              _inputSelector(_location, S.of(context).please_select),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //分支行
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, pageSelectBranchBank).then((data) {
              if (data != null) {
                setState(() {
                  _branch = data;
                });
              }
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _inputFrame(
              S.current.branch_office,
              _inputSelector(_branch, S.current.optional),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //短信通知
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: _inputFrame(
            S.current.sms_notification,
            _inputFieldIcon(
              _smsController,
              InkWell(
                onTap: () {
                  _contact();
                  // Fluttertoast.showToast(msg: '点击选择联系人');
                },
                child: Image(
                  color: Colors.blueAccent,
                  image: AssetImage(
                      'images/transferIcon/transfer_features_icon/transfer_features_acount.png'),
                  width: 21,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
        Divider(height: 0.5, color: HsgColors.divider),
        //别名 (备注)
        Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: _inputFrame(
            S.current.alias,
            _inputField(_aliasController, S.current.word_limit_5),
          ),
        ),
      ],
    );
  }

  //通用输入框(传入左边内容和右边内容)
  Widget _inputFrame(String left, Widget right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left),
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
            onChanged: (text) {},
          ),
        ),
        image,
      ],
    );
  }

  //通用文字输入框(传入监听器)
  Widget _inputField(TextEditingController _inputController, String hint) {
    return Expanded(
      child: TextField(
        textAlign: TextAlign.end,
        keyboardType: TextInputType.text,
        controller: _inputController,
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: HsgColors.textHintColor,
          ),
        ),
        onChanged: (text) {},
      ),
    );
  }

  //通用选择器
  Widget _inputSelector(String _income, String _hint) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: _income == _hint
              ? Text(
                  _income,
                  style: TextStyle(
                    color: HsgColors.textHintColor,
                  ),
                )
              : Text(_income),
        ),
        Image(
          color: HsgColors.firstDegreeText,
          image: AssetImage('images/home/listIcon/home_list_more_arrow.png'),
          width: 7,
          height: 10,
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

  //确认按钮
  Widget _confirmButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 48,
      child: FlatButton(
        onPressed: _confirm(),
        color: Color(0xFF4871FF),
        disabledColor: Color(0xFFD1D1D1),
        child: Text(
          S.current.confirm,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _check() {
    setState(() {
      if (_bank != S.current.please_select &&
          _location != S.current.please_select &&
          _nameController.text.length > 0 &&
          _acountController.text.length > 0 &&
          _smsController.text.length > 0) {
        _isInputed = true;
      } else {
        _isInputed = false;
      }
    });
  }

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
