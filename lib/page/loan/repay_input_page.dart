/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-16
/// 
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class RepayInputPage extends StatefulWidget {
  @override
  _RepayInputPageState createState() => _RepayInputPageState();
}

class _RepayInputPageState extends State<RepayInputPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {}
  @override
  Widget build(BuildContext context) {
    // Loan loanDetail = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        // title: Text(S.of(context).repay_input),
        title: Text("还款-输入信息"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Text("输入信息"),
      ),
    );
  }
}
