import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/hsg_approval_page.dart';
import 'package:ebank_mobile/page/home/hsg_home_page.dart';
import 'package:ebank_mobile/page/mine/mine_page.dart';
import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/util/status_bar_util.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex;
  PageController _pageController;

  final pages = [HomePage(), ApprovalPage(), MinePage()];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        //iconSize: 24,//使用自定义图片无效，请在图片中设置宽高属性
        fixedColor: HsgColors.accent,
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('images/tabbar/tabbar_home_normal.png'),
              width: 24,
              height: 24,
            ),
            activeIcon: Image(
              image: AssetImage('images/tabbar/tabbar_home_select.png'),
              width: 24,
              height: 24,
            ),
            label: S.current.home,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('images/tabbar/tabbar_approval_normal.png'),
              width: 24,
              height: 24,
            ),
            activeIcon: Image(
              image: AssetImage('images/tabbar/tabbar_approval_select.png'),
              width: 24,
              height: 24,
            ),
            label: S.current.approval,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('images/tabbar/tabbar_mine_normal.png'),
              width: 24,
              height: 24,
            ),
            activeIcon: Image(
              image: AssetImage('images/tabbar/tabbar_mine_select.png'),
              width: 24,
              height: 24,
            ),
            label: S.current.mine,
            backgroundColor: Colors.yellow,
          )
        ],
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // _changePage(index);
          _toPage(index);
        },
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [HomePage(), ApprovalPage(), MinePage()],
        onPageChanged: (page) {
          if (page == 0)
            StatusBarUtil.setStatusBar(Brightness.light,
                color: Colors.transparent);
          else
            StatusBarUtil.setStatusBar(Brightness.dark,
                color: Colors.transparent);
        },
      ),
      // body: pages[currentIndex],
      // body: IndexedStack(
      //   index: currentIndex,
      //   children: pages,
      // ),
    );
  }

  void _toPage(int index) {
    setState(() {
      currentIndex = index;
      // _pageController.animateToPage(currentIndex,
      //     curve: Curves.easeIn, duration: Duration(milliseconds: 160));
      _pageController.jumpToPage(currentIndex);
    });
    // if (index == 0) {
    //   EventBusUtils.getInstance()
    //       .fire(GetUserEvent(msg: "通知重新获取用户信息getUser", state: 200));
    // }
  }

  /*切换页面*/
  void _changePage(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}
