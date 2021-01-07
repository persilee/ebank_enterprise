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
  var _page = 1;
  var _totalPage = 0;
  var _transferType = '';
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
    TransferDataRepository()
        .getTransferPartnerList(
      GetTransferPartnerListReq(_page, 10),
      'getTransferPartnerList',
    )
        .then((data) {
      setState(() {
        if (data.rows != null) {
          _totalPage = data.totalPage;
          _partnerListData.addAll(data.rows);
          _tempList.clear();
          if (_transferType != '') {
            for (int i = 0; i < _partnerListData.length; i++) {
              //如果是国际转账或者行内转账跳过来的，只显示对应类型的的伙伴，否则显示全部
              if (_partnerListData[i].transferType == _transferType) {
                _tempList.add(_partnerListData[i]);
              }
            }
            //要显示的条数不足10条，继续加载下一页，直到达到最大页数
            if (_tempList.length < 10 && _page < _totalPage) {
              _page += 1;
              _loadData();
            }
          }else{
            _tempList.addAll(_partnerListData);
          }
        }
        _showmore = false;
      });
    }).catchError((e) {
      HSProgressHUD.showError(status: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    _arguments == null? _transferType = '':_transferType = _arguments;
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
                    _page = 1;
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
            _tempList.length >= 10 ? _loadMore() : Container(),
          ],
        ));
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
              style: TextStyle(color: HsgColors.blueTextColor),
            ),
          ),
        ),
        border: InputBorder.none,
        hintText: '银行名/账户/户名/手机号',
        hintStyle: TextStyle(
          fontSize: 15,
          color: HsgColors.hintText,
        ),
      ),
      onChanged: (text) {},
    );
  }

  //删除请求
  _deletePartner(String custId, String payeeCardNo) {
    TransferDataRepository()
        .deletePartner(DeletePartnerReq(custId, payeeCardNo), 'deletePartner')
        .then((data) {
      setState(() {
        if (data.count >= 1) {
          _page = 1;
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

  Widget _getDeleteBuilder(Widget function, Rows partner) {
    return CupertinoLeftScroll(
      key: Key(partner.payeeCardNo),
      child: function,
      closeTag: LeftScrollCloseTag('row.payeeCardNo'),
      buttons: [
        LeftScrollItem(
          text: S.current.delete,
          color: Colors.red,
          onTap: () {
            LeftScrollGlobalListener.instance
                .targetStatus(LeftScrollCloseTag('row.payeeCardNo'),
                    Key(partner.payeeCardNo))
                .value = false;
            _deletePartner(partner.custId, partner.payeeCardNo);
            HSProgressHUD.showSuccess(status: '删除成功!');
          },
        ),
      ],
    );
  }

  //单条伙伴
  Widget _allContentRow(Rows partner) {
    var _cardLength = partner.payeeCardNo.length;
    var _cardNo = '';
    var _bankName = '';
    partner.bankSwift == null
        ? _bankName = '无银行名'
        : _bankName = partner.bankSwift;
    //取卡号最后四位
    if (_cardLength > 4) {
      _cardNo = partner.payeeCardNo.substring(_cardLength - 5, _cardLength - 1);
    } else {
      partner.payeeCardNo == null
          ? _cardNo = ''
          : _cardNo = partner.payeeCardNo;
    }
    //备注
    var _remarkCont = partner.remark == '' || partner.remark == null
        ? Container()
        : Container(
            padding: EdgeInsets.fromLTRB(9, 2.5, 9, 2.5),
            decoration: new BoxDecoration(
              //背景
              color: Color(0xFFF1F1F1),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            alignment: Alignment.center,
            child: Text(
              partner.remark,
              style: TextStyle(fontSize: 11, color: Color(0xFFA9A9A9)),
            ),
          );
    //文字部分
    var _contWord = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              partner.payeeName == null ? '无名' : partner.payeeName,
              style: TextStyle(fontSize: 14, color: Color(0xFF232323)),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5),
            ),
            _remarkCont,
          ],
        ),
        Text(
          '$_bankName($_cardNo)  ' + (partner.transferType == '0' ? '本行' : '国际'),
          style: TextStyle(fontSize: 13, color: HsgColors.hintText),
        )
      ],
    );

    //银行图标
    var _bankImage = partner.payeeBankImageUrl != null
        ? Image.network(
            partner.payeeBankImageUrl,
            width: 30,
            height: 30,
          )
        : Image(
            image: AssetImage('images/transferIcon/transfer_bank.png'),
            width: 30,
            height: 30,
          );
    return InkWell(
      onTap: () {
        if (_transferType != null) {
          Navigator.pop(context, partner);
        } else {
          Navigator.pushNamed(context, pageInternational, arguments: partner);
        }
      },
      child: Container(
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
                  //银行图标
                  _bankImage,
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                  ),
                  //文字部分
                  _contWord,
                ],
              ),
            ),
            Divider(
              height: 1,
              color: HsgColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}
