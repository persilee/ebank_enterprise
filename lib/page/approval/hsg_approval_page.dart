/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///待办页面
/// Author: wangluyao
/// Date: 2020-12-03

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/feature_demo/my_tab_indicator.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/authorization_history_page.dart';
import 'package:flutter/material.dart';
import 'my_appplication_page.dart';
import 'my_approval_page.dart';

class ApprovalPage extends StatefulWidget {
  ApprovalPage();
  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage>
    with SingleTickerProviderStateMixin {
  _ApprovalPageState();
  final List tabs = [
    S.current.my_to_do_list,
    S.current.authorization_history,
    S.current.my_application
  ];
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

//顶部切换
  Widget _tabBar(BuildContext context) {
    return TabBar(
      isScrollable: true,
      labelStyle: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      controller: tabController,
      indicatorWeight: 4,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: MyUnderlineTabIndicator(
          borderSide: BorderSide(width: 3.0, color: HsgColors.accent)),
      tabs: tabs.map((e) => Tab(text: e)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: _tabBar(context),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          S.of(context).approval,
        ),
        elevation: 0,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          MyApprovalPage(),
          AuthorizationHistoryPage(),
          MyApplicationPage()
        ],
      ),
    );
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
