import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoanMyApplicationListPage extends StatefulWidget {
  LoanMyApplicationListPage({Key key}) : super(key: key);

  @override
  _loanMyApplicationListSate createState() => _loanMyApplicationListSate();
}

// ignore: camel_case_types
class _loanMyApplicationListSate extends State<LoanMyApplicationListPage> {
  List<bool> _isShowList = []; //没行是否进行展开的数组
  List<Widget> _productApplyList = []; //产品申请列表
  List<Widget> _productDetailList = []; //底部详情的列表

  bool _isShow = false;

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 5; i++) {
      _productApplyList.add(ExpandBox());
      _isShowList.add(false);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_apply),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        height: double.infinity,
        // child: ListView(
        //   children: [
        //     // ExpandBox(),
        //     // ExpandBox(),
        //   ],
        child: ListView.builder(
          itemCount: _productApplyList.length, //数量
          itemBuilder: (BuildContext context, int index) {
            return _productApplyList[index];
          },
        ),
      ),
      // ),
    );
  }
}

class ExpandBox extends StatefulWidget {
  @override
  _ExpandBoxState createState() => _ExpandBoxState();
}

class _ExpandBoxState extends State<ExpandBox> {
  bool _isShow = false;

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
              width: MediaQuery.of(context).size.width - 108,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //纵轴的间距
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //横轴的间距
                children: [
                  Text('我是大标题',
                      style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis),
                  Text('2021-10-09 22:03:04',
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
              child: Row(
                children: [
                  Image(
                    width: 13,
                    height: 7.5,
                    image: _isShow
                        ? AssetImage('images/loanProduct/loan_apply_up.png')
                        : AssetImage('images/loanProduct/loan_apply_down.png'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _creatDetailDate() {
    return Container(
      child: Column(
        children: [
          _textFieldCommonFunc(
              S.current.loan_New_product_column, '我是右边文字', false),
          _textFieldCommonFunc(S.current.apply_amount, '我是右边文字', false),
          _textFieldCommonFunc(S.current.loan_duration, '我是右边文字', false),
          _textFieldCommonFunc(S.current.debit_currency, '我是右边文字', false),
          _textFieldCommonFunc(S.current.loan_purpose, '我是右边文字', false),
          _textFieldCommonFunc(
              S.current.loan_Disbursement_Account_column, '我是右边文字', false),
          _textFieldCommonFunc(
              S.current.loan_Repayment_account_column, '我是右边文字', false),
          _textFieldCommonFunc(
              S.current.loan_Repayment_method_column, '我是右边文字', false),
          _textFieldCommonFunc(S.current.contact, '我是右边文字', true),
          _textFieldCommonFunc(S.current.contact_phone_num, '我是右边文字', false),
          _textFieldCommonFunc(S.current.remark, '我是右边文字', false),
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
