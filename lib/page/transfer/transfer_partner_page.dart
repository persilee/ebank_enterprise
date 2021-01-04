/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 转账伙伴页面
/// Author: zhangqirong
/// Date: 2020-12-24

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/delete_partner.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/leftScroll.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';

class TransferPartner extends StatefulWidget {
  @override
  _TransferPartnerState createState() => _TransferPartnerState();
}

class _TransferPartnerState extends State<TransferPartner> {
  var _searchController = TextEditingController();
  var _partnerListData = <Rows>[];
  var _tempList = <Rows>[];
  ScrollController _scrollController = ScrollController();
  var _showmore = false;
  var page = 1;
  var totalPage = 0;
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (page < totalPage) {
            _showmore = true;
          }
        }
      });
    });
    _loadData();
  }

  Future<void> _loadData() async {
    TransferDataRepository()
        .getTransferPartnerList(
      GetTransferPartnerListReq(page, 10),
      'getTransferPartnerList',
    )
        .then((data) {
      setState(() {
        if (data.rows != null) {
          totalPage = data.totalPage;
          setState(() {
            _partnerListData.addAll(data.rows);
            _tempList.clear();
            _tempList.addAll(_partnerListData);
          });
        }
        _showmore = false;
      });
    }).catchError((e) {
      HSProgressHUD.showError(status: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (_tempList.isEmpty) {
        _tempList.addAll(_partnerListData);
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.transfer_partner),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, pageAddPartner).then((value) {
                  setState(() {
                    _partnerListData.clear();
                    page = 1;
                  });
                  //跳回顶部
                  _scrollController
                      .jumpTo(_scrollController.position.minScrollExtent);
                  _loadData();
                });
              },
              padding: EdgeInsets.only(right: 15),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: HsgColors.backgroundColor,
            child: _myColumn()));
  }

  Widget _myColumn() {
    return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //搜索框
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 25),
              margin: EdgeInsets.only(bottom: 16, top: 16),
              child: _searchIcon(),
            ),
            //卡号列表
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 0, right: 0),
              child: _getAllRowsList(),
            ),
            //说明
            Container(
              padding: EdgeInsets.fromLTRB(16, 15, 0, 15),
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.tran_out_declare,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFA9A8A8),
                ),
              ),
            ),
            //加载更多
            _tempList.length > 8 ? _loadMore() : Container(),
          ],
        ));
  }

  //底部加载更多
  Widget _loadMore() {
    return _showmore
        ? InkWell(
            onTap: () {
              page += 1;
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
    return TextField(
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
                _tempList.addAll(_partnerListData);
              } else {
                _tempList.clear();
                _partnerListData.forEach((e) {
                  if (e.payeeName.contains(text)) {
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
    );
  }

  //删除请求
  Future<void> _deletePartner(String custId, String payeeCardNo) async {
    TransferDataRepository()
        .deletePartner(DeletePartnerReq(custId, payeeCardNo), 'deletePartner')
        .then((data) {
      setState(() {
        if (data.count >= 1) {
          page = 1;
          _partnerListData.clear();
          _loadData();
        }
      });
    }).catchError((e) {
      HSProgressHUD.showError(status: e.toString());
    });
  }

  //伙伴列表
  Widget _getAllRowsList() {
    List<Widget> _list = new List();
    for (int i = 0; i < _tempList.length; i++) {
      _list.add(_getDeleteBuilder(_allContentRow(_tempList[i]), _tempList[i]));
    }
    return new ListView(
      children: _list,
      shrinkWrap: true, //解决无限高度问题
      physics: NeverScrollableScrollPhysics(), //禁用滑动事件
    );
  }

  Widget _getDeleteBuilder(Widget function, Rows row) {
    return CupertinoLeftScroll(
      key: Key(row.payeeCardNo),
      child: function,
      closeTag: LeftScrollCloseTag('row.payeeCardNo'),
      buttons: [
        LeftScrollItem(
          text: S.current.delete,
          color: Colors.red,
          onTap: () {
            LeftScrollGlobalListener.instance
                .targetStatus(
                    LeftScrollCloseTag('row.payeeCardNo'), Key(row.payeeCardNo))
                .value = false;
            _deletePartner(row.custId, row.payeeCardNo);
            HSProgressHUD.showSuccess(status: '删除成功!');
          },
        ),
      ],
    );
  }

  //单条伙伴
  Widget _allContentRow(Rows row) {
    var length = row.payeeCardNo.length;
    var number = '';
    var bank = '';
    row.bankSwift == null ? bank = '无银行名' : bank = row.bankSwift;
    if (length > 4) {
      number = row.payeeCardNo.substring(length - 5, length - 1);
    } else {
      row.payeeCardNo == null ? number = '' : number = row.payeeCardNo;
    }
    //文字部分
    var contWord = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              row.payeeName == null ? '无名' : row.payeeName,
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5),
            ),
            row.remark == '' || row.remark == null
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: new BoxDecoration(
                      //背景
                      color: Color(0x77A9A9A9),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      row.remark,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
          ],
        ),
        Text(
          '$bank($number)',
          style: TextStyle(fontSize: 13, color: HsgColors.hintText),
        )
      ],
    );
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('images/transferIcon/transfer_bank.png'),
                  width: 30,
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                ),
                contWord,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: Divider(
              height: 1,
              color: HsgColors.textHintColor,
            ),
          ),
        ],
      ),
    );
  }
}
