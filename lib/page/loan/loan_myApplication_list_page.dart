import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/loan_applyfor_list.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanMyApplicationListPage extends StatefulWidget {
  LoanMyApplicationListPage({Key key}) : super(key: key);

  @override
  _loanMyApplicationListSate createState() => _loanMyApplicationListSate();
}

// ignore: camel_case_types
class _loanMyApplicationListSate extends State<LoanMyApplicationListPage> {
  List<bool> _isShowList = []; //没行是否进行展开的数组
  List<Widget> _productApplyList = []; //产品模型数据列表
  List<IdType> _goalLists = []; //贷款目的列表
  List<IdType> _reimburseTypeLists = []; //还款方式

  List<Widget> _productDetailList = []; //底部详情的列表

  bool _isShow = false; //是否展开
  bool _isLoading = true; //显示加载中

  @override
  void initState() {
    super.initState();
    _getLoanPurposeList();
  }

//获取贷款目的
  Future _getLoanPurposeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("LOAN_PUR"), 'GetIdTypeReq')
        .then((data) {
      print('贷款目的');
      if (data.publicCodeGetRedisRspDtoList != null) {
        _goalLists.clear();
        _goalLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
      _getLoanRepayTypeList();
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

//还款方式
  Future _getLoanRepayTypeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("REPAY_TYPE"), 'GetIdTypeReq')
        .then((data) {
      print('还款方式');
      if (data.publicCodeGetRedisRspDtoList != null) {
        _reimburseTypeLists.clear();
        _reimburseTypeLists.addAll(data.publicCodeGetRedisRspDtoList);
      }
      _getLoanApplyforListData(); //获取列表数据
    }).catchError((e) {
      SVProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //获取列表数据
  Future _getLoanApplyforListData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    LoanDataRepository()
        .loanApplyforListData(LoanApplyFoyListReq(userID), 'applyforList')
        .then((data) {
      setState(() {
        _isLoading = false;
        if (data.loanRecordDOList != null) {
          //数组不为空
          for (int i = 0; i < data.loanRecordDOList.length; i++) {
            LoanRecordDOList listData = data.loanRecordDOList[i];
            _productApplyList
                .add(ExpandBox(i, listData, _goalLists, _reimburseTypeLists));
            _isShowList.add(false);
          }
        }
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_apply),
        centerTitle: true,
        elevation: 1,
      ),
      body: _isLoading
          ? HsgLoading()
          : Container(
              color: HsgColors.commonBackground,
              height: double.infinity,
              child: ListView.builder(
                itemCount: _productApplyList.length <= 0
                    ? 1
                    : _productApplyList.length, //数量
                itemBuilder: (BuildContext context, int index) {
                  return _productApplyList.length <= 0
                      ? Container(
                          margin: EdgeInsets.only(top: 200),
                          child:
                              notDataContainer(context, S.current.no_data_now))
                      : _productApplyList[index];
                },
              ),
            ),
      // ),
    );
  }
}

class ExpandBox extends StatefulWidget {
  final int index;
  final LoanRecordDOList listData;
  final List<IdType> listPupor; //目的
  final List<IdType> listRepayment; //还款方式

  ExpandBox(this.index, this.listData, this.listPupor, this.listRepayment);
  @override
  _ExpandBoxState createState() =>
      _ExpandBoxState(index, listData, listPupor, listRepayment);
}

class _ExpandBoxState extends State<ExpandBox> {
  bool _isShow = false;
  final int index;
  final LoanRecordDOList listData;
  final List<IdType> listPupor; //目的
  final List<IdType> listRepayment; //还款方式
  String _language = Intl.getCurrentLocale(); //版本语言

  _ExpandBoxState(
      this.index, this.listData, this.listPupor, this.listRepayment);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _creatListHeader(),
          _isShow ? _creatDetailDate() : Container(),
        ],
      ),
    );
  }

  Widget _creatListHeader() {
    String statusStr = '';
    if (listData.status == 0) {
      //待处理
      statusStr = S.current.loan_application_apply_pending;
    } else if (listData.status == 1) {
      //处理中
      statusStr = S.current.on_processing;
    } else {
      //已处理
      statusStr = S.current.loan_application_apply_processed;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          //刷新当前部分
          //在这里需要进行状态变更
          _isShow = !_isShow;
        });
        print('点击了');
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 13, left: 13, right: 13),
        height: 77,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 30, left: 15),
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //纵轴的间距
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //横轴的间距
                children: [
                  Text(
                      //产品名称
                      listData.lclName != null ? listData.lclName : "",
                      style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                  Text(listData.createTime,
                      style: TextStyle(
                        color: Color(0xFF7A7A7A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, //纵轴的间距
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //横轴的间距
                children: [
                  Image(
                    width: 13,
                    height: 7.5,
                    image: _isShow
                        ? AssetImage('images/loanProduct/loan_apply_up.png')
                        : AssetImage('images/loanProduct/loan_apply_down.png'),
                  ),
                  Text(
                      //审核状态
                      statusStr,
                      style: TextStyle(
                        color: Color(0xFF7A7A7A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 产品名称。( 贷款目的  还款方式 )括号里面的需要自己去拿

  Widget _creatDetailDate() {
    String _loanPurpse = ''; //目的
    String _repaymentMethod = ''; //还款方式

    for (int i = 0; i < listPupor.length; i++) {
      IdType typeData = listPupor[i];
      if (typeData.code == listData.loanPurpse) {
        if (_language == 'zh_CN') {
          _loanPurpse = typeData.cname;
        } else {
          _loanPurpse = typeData.name;
        }
      }
    }

    for (int i = 0; i < listRepayment.length; i++) {
      IdType typeData = listRepayment[i];
      if (typeData.code == listData.repaymentMethod) {
        if (_language == 'zh_CN') {
          _repaymentMethod = typeData.cname;
        } else {
          _repaymentMethod = typeData.name;
        }
      }
    }

    return Container(
      child: Column(
        children: [
          _textFieldCommonFunc(S.current.loan_New_product_column,
              listData.lclName != null ? listData.lclName : "", false), //贷款产品
          _textFieldCommonFunc(
              S.current.apply_amount, listData.intentAmt, false), //申请金额
          _textFieldCommonFunc(S.current.loan_duration,
              listData.termValue.toString(), false), //贷款期限
          _textFieldCommonFunc(
              S.current.debit_currency, listData.ccy, false), //币种
          _textFieldCommonFunc(S.current.loan_purpose, _loanPurpse, false), //目的
          _textFieldCommonFunc(S.current.loan_Disbursement_Account_column,
              listData.payAcno, false), //放帐号款
          _textFieldCommonFunc(S.current.loan_Repayment_account_column,
              listData.repaymentAcno, false), //还款帐号
          _textFieldCommonFunc(S.current.loan_Repayment_method_column,
              _repaymentMethod, false), //还款方式
          _textFieldCommonFunc(S.current.contact, listData.contact, true), //联系人
          _textFieldCommonFunc(
              S.current.contact_phone_num, listData.phone, false), //手机号码
          _textFieldCommonFunc(S.current.remark, listData.remark, false), //备注
        ],
      ),
    );
  }

  Widget _addLinne() {
    return Divider(
      color: Color(0xFFD8D8D8),
      height: 1,
      indent: 15,
      endIndent: 15,
      thickness: 1,
    );
  }

  Widget _textFieldCommonFunc(
      String columnName, String detailStr, bool hiddenLine) {
    return Padding(
      padding: EdgeInsets.only(left: 13, right: 13),
      child: Container(
        color: Colors.white,
        height: 45,
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                columnName,
                style: TextStyle(),
                textAlign: TextAlign.start,
              ),
              Text(
                detailStr,
                style: TextStyle(),
                textAlign: TextAlign.end,
              ),
              // hiddenLine ? Container() : _addLinne(), //没有就不添加线
            ],
          ),
        ),
      ),
    );
  }
}
