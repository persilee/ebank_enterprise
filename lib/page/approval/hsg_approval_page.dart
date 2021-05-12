/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///待办页面
/// Author: wangluyao
/// Date: 2020-12-03
///
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/feature_demo/my_tab_indicator.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/my_approved_history_page.dart';
import 'package:ebank_mobile/util/screen_util.dart';
import 'package:ebank_mobile/util/status_bar_util.dart';
import 'package:ebank_mobile/widget/custom_tabs.dart' as CustomTabBar;
import 'package:flutter/material.dart';

import 'my_appplication_page.dart';
import 'my_to_do_task_page.dart';

class ApprovalPage extends StatefulWidget {
  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List tabs;
  ScrollController _controllerMyToDoTask;
  ScrollController _controllerMyApprovedHistory;
  ScrollController _controllerMyApplication;

  @override
  void initState() {
    super.initState();
    _controllerMyToDoTask = ScrollController();
    _controllerMyApprovedHistory = ScrollController();
    _controllerMyApplication = ScrollController();
  }

  @override
  void dispose() {
    _controllerMyToDoTask.dispose();
    _controllerMyApprovedHistory.dispose();
    _controllerMyApplication.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

//顶部切换
  Widget _tabBar(BuildContext context) {
    return Container(
      width: ScreenUtil.instance.width,
      color: Colors.white,
      alignment: Alignment.center,
      child: CustomTabBar.TabBar(
        isScrollable: true,
        labelStyle: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
        unselectedLabelStyle:
            TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 4,
        indicatorSize: CustomTabBar.TabBarIndicatorSize.label,
        indicator: MyUnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: HsgColors.accent),
          bottomPadding: 8.0,
          indicatorWidthPercentage: 0.46,
        ),
        tabs: tabs.map((e) => Tab(text: e)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    tabs = [
      S.current.my_to_do_list,
      S.current.authorization_history,
      S.current.my_application
    ];
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          print(tabController.index);
        });
        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: ScreenUtil.instance.statusBarHeight),
            color: Color(int.parse('0xffF8F8F8')),
            child: Column(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    switch(tabController.index) {
                      case 0: {
                        _controllerMyToDoTask.animateTo(
                          _controllerMyToDoTask.position.minScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      }
                      break;
                      case 1: {
                        _controllerMyApprovedHistory.animateTo(
                          _controllerMyToDoTask.position.minScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      }
                      break;
                      case 2: {
                        _controllerMyApplication.animateTo(
                          _controllerMyToDoTask.position.minScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      }
                      break;
                    }
                  },
                  child: Container(
                    width: ScreenUtil.instance.width,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      S.of(context).approval,
                      style: TextStyle(fontSize: 17.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(
                  thickness: 0,
                  height: 1,
                  color: Color(int.parse('0xffD9D9D9')),
                ),
                _tabBar(context),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: CustomTabBar.TabBarView(
                      controller: tabController,
                      children: [
                        MyToDoTaskPage(
                            title: S.current.my_to_do_list,
                            controller: _controllerMyToDoTask),
                        MyApprovedHistoryPage(
                            title: S.current.authorization_history,
                            controller: _controllerMyApprovedHistory
                        ),
                        MyApplicationPage(title: S.current.my_application,
                          controller: _controllerMyApplication,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
