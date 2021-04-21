
import 'package:ebank_mobile/data/source/model/get_branch_list.dart';
import 'package:ebank_mobile/http/retrofit/api_client_account.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 分支行
/// Author: zhangqirong
/// Date: 2020-12-25

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class SelectBranchBankPage extends StatefulWidget {
  @override
  _SelectBranchBankPageState createState() => _SelectBranchBankPageState();
}

class _SelectBranchBankPageState extends State<SelectBranchBankPage> {
  var _searchController = TextEditingController();
  var _branchList = <Branches>[];
  var _tempList = <Branches>[];
  var _bankType = '';
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
    // BankDataRepository()
    ApiClientAccount().getBrnachList(GetBranchListReq(_page, 10)).then((data) {
      if (data != null) {
        setState(() {
          _totalPage = data.totalPage;
          _branchList.addAll(data.branches);
          _tempList.clear();
          if (_bankType != '') {
            for (int i = 0; i < _branchList.length; i++) {
              //如果银行名不为空，只显示对应银行的的分支行，否则显示全部
              if (_branchList[i].localFullName.contains(_bankType)) {
                _tempList.add(_branchList[i]);
              }
            }
            //要显示的条数不足10条，继续加载下一页，直到达到最大页数
            if (_tempList.length < 10 && _page < _totalPage) {
              _page += 1;
              _loadData();
            }
          } else {
            _tempList.addAll(_branchList);
          }
          _branchList.clear();
          _branchList.addAll(_tempList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    _arguments == null ? _bankType = '' : _bankType = _arguments;
    setState(() {
      if (_tempList.isEmpty) {
        _tempList.addAll(_branchList);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.select_branch_office),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        padding: EdgeInsets.only(top: 10, bottom: 10),
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
                  _tempList.addAll(_branchList);
                } else {
                  _tempList.clear();
                  _branchList.forEach((e) {
                    if (e.remark.contains(text)) {
                      _tempList.add(e);
                    }
                  });
                  if (_tempList.isEmpty) {
                    _searchController.text = '';
                    Fluttertoast.showToast(
                      msg: '没有找到相关分支行!',
                      gravity: ToastGravity.CENTER,
                    );
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

  Widget _hintIcon() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 18),
      child: Text(
        S.current.pick_branch_office_tips,
        style: TextStyle(color: HsgColors.hintText, fontSize: 13),
      ),
    );
  }

  Widget _listIcon(String text, String number) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, text);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 15, 20, 0),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 3),
              child: Text(
                number,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
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
    _list.add(_getListViewBuilder(_hintIcon()));
    for (int i = 0; i < _tempList.length; i++) {
      _list.add(_getListViewBuilder(
          _listIcon(_tempList[i].localFullName, _tempList[i].phone)));
    }
    _list.add(_loadMore());
    return new ListView(
      children: _list,
    );
  }
}
