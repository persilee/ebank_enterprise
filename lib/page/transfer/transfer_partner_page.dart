/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 转账伙伴页面
/// Author: zhangqirong
/// Date: 2020-12-24

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/delete_partner.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/leftScroll.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  var _totalPage = 1;
  var _transferType = '';
  bool _load = false; //是否加载更多
  bool _isData = false;
  var _bankName = '';
  String _language = Intl.getCurrentLocale();
  RefreshController _refreshController;
  bool _isLoading = false; //加载状态
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    //滚动监听
    // _scrollController.addListener(() {
    //   setState(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       if (_page < _totalPage) {
    //         _showmore = true;
    //         _load = true;
    //       }
    //       _page++;
    //       _loadData();
    //     }
    //   });
    // });
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  _loadData() {
    _isLoading = true;
    TransferDataRepository()
        .getTransferPartnerList(
      GetTransferPartnerListReq(_page, 10),
      'getTransferPartnerList',
    )
        .then((data) {
      if (this.mounted) {
        setState(() {
          if (data.rows != null) {
            _isData = true;
            _totalPage = data.totalPage;
            _partnerListData.clear();
            _partnerListData.addAll(data.rows);
            _tempList.clear();
            if (_transferType != '') {
              for (int i = 0; i < _partnerListData.length; i++) {
                //如果是国际转账或者行内转账跳过来的，只显示对应类型的的伙伴，否则显示全部
                if (_partnerListData[i].transferType == _transferType) {
                  _tempList.add(_partnerListData[i]);
                }
              }
              // //要显示的条数不足10条，继续加载下一页，直到达到最大页数
              // if (_tempList.length < 10 && _page < _totalPage) {
              //   _page += 1;
              //   _loadData();
              // }
            } else {
              _tempList.addAll(_partnerListData);
            }
          }
          _partnerListData.clear();
          _partnerListData.addAll(_tempList);
          _showmore = false;
          _isLoading = false;
          _load = false;
          _refreshController.loadComplete();
        });
      }
    }).catchError((e) {
      // HSProgressHUD.showError(status: e.toString());

      if (this.mounted) {
        setState(() {
          _isLoading = false;
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
        _tempList.addAll(_partnerListData);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_model),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, pageAddPartner).then((value) {
                setState(() {
                  _partnerListData.clear();
                  _page = 1;
                });
                //跳回顶部
                // _scrollController
                //     .jumpTo(_scrollController.position.minScrollExtent);
                _loadData();
              });
            },
            padding: EdgeInsets.only(right: 15),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      // body: Container(
      //     height: MediaQuery.of(context).size.height,
      //     color: HsgColors.backgroundColor,
      //     child: _myColumn()));
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: _isData ? _myColumn() : _noDataWidget(),
      //     ),
      //   ],
      // ),
      body: _isLoading
          ? HsgLoading()
          : _partnerListData.length > 0
              ? CustomRefresh(
                  controller: _refreshController,
                  onLoading: () {
                    if (_page < _totalPage) {
                      _load = true;
                      _page++;
                    }
                    //加载更多完成
                    if (_load) {
                      _loadData();
                    } else {
                      //显示没有更多数据
                      _refreshController.loadNoData();
                    }
                  },
                  onRefresh: () {
                    //刷新完成
                    _page = 1;
                    _loadData();
                    _refreshController.refreshCompleted();
                    _refreshController.footerMode.value = LoadStatus.canLoading;
                  },
                  content: _getAllRowsList(),
                )
              : _noDataWidget(),
    );
  }

  Widget _myColumn() {
    return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //卡号列表
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 0, right: 0),
              child: _getAllRowsList(),
            ),
            //加载更多
            _tempList.length >= 10 ? _loadMore() : _toLoad(),
          ],
        ));
  }

//加载完毕
  Widget _toLoad() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        S.current.load_more_finished,
        style: FIRST_DESCRIBE_TEXT_STYLE,
        textAlign: TextAlign.center,
      ),
    );
  }

  //没数据显示页面
  Widget _noDataWidget() {
    // HSProgressHUD.show();
    // Future.delayed(Duration(seconds: 1), () {
    //   HSProgressHUD.dismiss();
    // });
    return Container(
      width: (MediaQuery.of(context).size.width),
      // height: 270,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            child: Image(
              image: AssetImage('images/noDataIcon/no_data_person.png'),
              width: 159,
              height: 128,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              S.of(context).no_recent_transfer_account,
              style: TextStyle(color: HsgColors.describeText, fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  //底部加载更多
  Widget _loadMore() {
    return _showmore
        ?
        // InkWell(
        //     onTap: () {
        //       _page += 1;
        //       _loadData();
        //     },
        //     child: Container(
        //       height: 50,
        //       alignment: Alignment.center,
        //       child: Text(
        //         S.current.click_to_load_more,
        //         style: TextStyle(
        //           fontSize: 13,
        //           color: Color(0xFFA9A8A8),
        //         ),
        //       ),
        //     ))
        Center(
            child: Container(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(),
            ),
          )
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
    // return RefreshIndicator(
    //   onRefresh: () => _loadData(),
    //   child: ListView(
    //     children: _list,
    //     shrinkWrap: true, //解决无限高度问题
    //     physics: NeverScrollableScrollPhysics(), //禁用滑动事件
    //   ),
    return ListView(
      children: _list,
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
              showDialog(
                  context: context,
                  builder: (context) {
                    return HsgAlertDialog(
                      title: S.current.prompt,
                      message: "您是否确定要删除该伙伴",
                      negativeButton: S.current.cancel,
                      positiveButton: S.current.confirm,
                    );
                  }).then((value) {
                if (value == true) {
                  _deleteParthner(partner);
                }
              });
            }),
      ],
    );
  }

  //删除
  _deleteParthner(Rows partner) {
    LeftScrollGlobalListener.instance
        .targetStatus(
            LeftScrollCloseTag('row.payeeCardNo'), Key(partner.payeeCardNo))
        .value = false;
    _deletePartner(partner.custId, partner.payeeCardNo);
    HSProgressHUD.showSuccess(status: '删除成功!');
  }

  //单条伙伴
  Widget _allContentRow(Rows partner) {
    var _cardNo = '';
    //卡号格式化
    partner.payeeCardNo == null
        ? _cardNo = '卡号为空'
        : _cardNo = FormatUtil.formatSpace4(partner.payeeCardNo);
    //文字部分
    var _contWord = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            partner.payeeName == null ? '无名' : partner.payeeName,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF232323),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            _language == 'zh_CN'
                ? partner.payeeBankLocalName == null
                    ? '朗华银行'
                    : partner.payeeBankLocalName
                : partner.payeeBankEngName == null
                    ? 'Brillink bank'
                    : partner.payeeBankEngName,
            // _bankName = _language == 'zh_CN'
            //     ? partner.payeeBankLocalName
            //     : partner.payeeBankEngName,
            style: TextStyle(fontSize: 13, color: HsgColors.hintText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Text(
              '$_cardNo',
              style: TextStyle(fontSize: 13, color: HsgColors.hintText),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: 1,
                height: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: HsgColors.hintText),
                ),
              ),
            ),
            Text(
              partner.transferType == '0'
                  ? S.current.transfer_type_0_short
                  : S.current.transfer_type_1_short,
              style: TextStyle(fontSize: 13, color: HsgColors.hintText),
            ),
          ],
        ),
      ],
    );

    //银行图标
    Widget _bankImage = Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(46.0 / 2),
      ),
      child: ClipOval(
        child: (partner.payeeBankImageUrl == null ||
                partner.payeeBankImageUrl == '')
            ? Image(
                image: AssetImage(
                  'images/transferIcon/transfer_head.png',
                ),
              )
            : FadeInImage.assetNetwork(
                fit: BoxFit.fitWidth,
                image: partner.payeeBankImageUrl,
                placeholder:
                    'images/transferIcon/transfer_sample_placeholder.png',
              ),
      ),
    );
    // partner.payeeBankImageUrl != null
    //     ? Image.network(
    //         partner.payeeBankImageUrl,
    //         width: 30,
    //         height: 30,
    //       )
    //     : Image(
    //         image: AssetImage('images/transferIcon/transfer_head.png'),
    //         width: 30,
    //         height: 30,
    //       );
    return FlatButton(
      onPressed: () {
        if (_transferType != '') {
          Navigator.pop(context, partner);
        } else {
          if (partner.transferType == '0') {
            Navigator.pushNamed(context, pageTransferInternal,
                arguments: partner);
          } else if (partner.transferType == '2') {
            Navigator.pushNamed(context, pageTrasferInternational,
                arguments: partner);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
