/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///待办页面
/// Author: wangluyao
/// Date: 2020-12-03

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/feature_demo/my_tab_indicator.dart';
import 'package:ebank_mobile/feature_demo/time_depost_product_page.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'my_approval_page.dart';

class TabBarAndTopTab extends StatefulWidget {
  TabBarAndTopTab();
  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<TabBarAndTopTab>
    with SingleTickerProviderStateMixin {
  _ApprovalPageState();
  List tabs = ["我的待办", "授权记录", "我的申请"];
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _tabBar() {
    return TabBar(
        isScrollable: false,
        labelStyle: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        controller: tabController,
        indicatorWeight: 4.0,
        indicator: MyUnderlineTabIndicator(
            borderSide: BorderSide(width: 4.0, color: HsgColors.accent)),
        tabs: tabs.map((e) => Tab(text: e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(52),
              child: Material(
                  color: Colors.white,
                  child: Theme(
                      data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent),
                      child: _tabBar()))),
          centerTitle: true,
          title: Text(
            S.of(context).approval,
          ),
          elevation: 0,
        ),
        body: TabBarView(
          controller: tabController,
          children: [MyApprovalPage(), MyApprovalPage(), MyApprovalPage()],
          // children: tabs.map((e) {
          //   return Center(
          //     child: Text(e),
          //   );
          // }).toList(),
        ));
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
