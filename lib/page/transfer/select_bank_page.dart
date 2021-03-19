/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 选择银行
/// Author: zhangqirong
/// Date: 2020-12-25

import 'package:ebank_mobile/data/source/bank_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class SelectBankPage extends StatefulWidget {
  @override
  _SelectBankPageState createState() => _SelectBankPageState();
}

class _SelectBankPageState extends State<SelectBankPage> {
  var _searchController = TextEditingController();
  var _bankList = <Banks>[];
  var _tempList = <Banks>[];
  var _transferType = '';
  ScrollController _scrollController = ScrollController();
  var _showmore = false;
  var _page = 1;
  var _totalPage = 0;

  @override
  void initState() {
    super.initState();
    //滚动监听
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_page < _totalPage) {
            _showmore = true;
          }
        }
      });
    });
    _loadData();
  }

  _loadData() {
    BankDataRepository()
        .getBankList(GetBankListReq(1, 10), 'getBankList')
        .then((data) {
      if (data != null) {
        setState(() {
          _totalPage = data.totalPage;
          _bankList.addAll(data.banks);
          // _tempList.clear();
          // if (_transferType != '') {
          //   for (int i = 0; i < _bankList.length; i++) {
          //     //如果是国际转账或者行内转账的，只显示对应类型的的银行，否则显示全部
          //     if (_bankList[i].bankType == _transferType) {
          //       _tempList.add(_bankList[i]);
          //     }
          //   }
          //   //要显示的条数不足10条，继续加载下一页，直到达到最大页数
          //   if (_tempList.length < 10 && _page < _totalPage) {
          //     _page += 1;
          //     _loadData();
          //   }
          // } else {
          //   _tempList.addAll(_bankList);
          // }
          // _bankList.clear();
          // _bankList.addAll(_tempList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    _arguments == null ? _transferType = '' : _transferType = _arguments;
    setState(() {
      if (_tempList.isEmpty) {
        _tempList.addAll(_bankList);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.select_bank),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: HsgColors.backgroundColor,
        child: _getlistViewList(context),
      ),
    );
  }

  //底部加载更多
  Widget _loadMore() {
    return _showmore
        ? InkWell(
            onTap: () {
              _page += 1;
              _loadData();
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                S.current.click_to_load_more,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFA9A8A8),
                ),
              ),
            ))
        : Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              S.current.all_loaded,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFA9A8A8),
              ),
            ),
          );
  }

  //搜索框(通过关键字搜索，为空则检索全部)
  Widget _searchIcon() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 25),
      margin: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 16),
          icon: Icon(
            Icons.search,
            color: HsgColors.hintText,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              String text = _searchController.text;
              setState(() {
                if (text.isEmpty) {
                  _tempList.clear();
                  _tempList.addAll(_bankList);
                } else {
                  _tempList.clear();
                  _bankList.forEach((e) {
                    if (e.localName.contains(text)) {
                      _tempList.add(e);
                    }
                  });
                  if (_tempList.isEmpty) {
                    _searchController.text = '';
                    Fluttertoast.showToast(msg: '没有找到相关银行!');
                  }
                }
              });
            },
            child: Container(
              width: 50,
              height: 20,
              alignment: Alignment.centerRight,
              child: Text(
                S.current.search,
                style: TextStyle(color: Color(0xFF4871FF)),
              ),
            ),
          ),
          border: InputBorder.none,
          hintText: '银行名/账户/户名/手机号',
          hintStyle: TextStyle(
            fontSize: 15,
            color: HsgColors.textHintColor,
          ),
        ),
        onChanged: (text) {},
      ),
    );
  }

  Widget _bankListIcon(Banks bank) {
    var bankImage = bank.bankIcon != null
        ? Image.network(
            bank.bankIcon,
            width: 30,
            height: 30,
          )
        : Image(
            image: AssetImage(
                'images/transferIcon/transfer_sample_placeholder.png'),
            width: 30,
            height: 30,
          );

    return Container(
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          Navigator.pop(context, bank);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  bankImage,
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                  ),
                  Text(
                    bank.localName,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Divider(
                  height: 0,
                  color: HsgColors.textHintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //封装ListView.Builder
  Widget _getListViewBuilder(Widget function) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  //生成ListView
  Widget _getlistViewList(BuildContext context) {
    List<Widget> _list = new List();
    _list.add(_getListViewBuilder(_searchIcon()));
    for (int i = 0; i < _tempList.length; i++) {
      _list.add(_getListViewBuilder(_bankListIcon(_tempList[i])));
    }
    _list.add(_loadMore());
    return new ListView(
      controller: _scrollController,
      children: _list,
    );
  }
}
