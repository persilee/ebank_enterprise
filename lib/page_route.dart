import 'package:ebank_mobile/page/accountOverview/account_overview_page.dart';
import 'package:ebank_mobile/page/bankcard/card_detail_page.dart';
import 'package:ebank_mobile/page/bankcard/card_limit_manager_page.dart';
import 'package:ebank_mobile/page/bankcard/card_list_page.dart';
import 'package:ebank_mobile/page/dialog_demo.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page/loan/limit_details_demo_page.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page/payCollectDetail/detail_info_page.dart';
import 'package:ebank_mobile/page/payCollectDetail/detail_list_page.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page/mine/about_us_page.dart';
import 'package:ebank_mobile/page/mine/feedback_page.dart';
import 'package:ebank_mobile/page/mine/hsg_mine_page.dart';




var pageHome = '/';
var pageLogin = "151";
// var pageLogin = pageHome;
// var pageCardList = pageHome;
var pageLimitDetailsDemo = pageHome;
var pageCardList = '/card_list';
var pageDialogDemo = '/dialog_demo';
var pageCardDetail = '/card_detail';
var pageCardLimit = '/card_limit_manager';
var minePage = '/hsg_mine_page';
var aboutUs = '/about_us_page';
var feedback = '/feedback_page';
var pageAccountOverview = '/account_overview';
var hsgMinePage ='hsg_mine_page';
var pageDetailInfo = '/detail_info_page';
var pageDetailList = '/detail_list_page';
var pageIndex = new MaterialPageRoute(builder: (context) => new IndexPage());

var appRoutes = {
  pageLogin: (contexrt) => LoginPage(),
  pageCardList: (context) => CardListPage(),
  pageDialogDemo: (context) => DialogDemoPage(),
  pageLimitDetailsDemo: (context) => LimitDetailsDemoPage(),
  // pageCardDetail: (context) => CardDetailPage(),
  pageCardLimit: (context) => CardLimitManagerPage(),
  aboutUs: (context) => AboutUsPage(),
  feedback: (context) => FeedbackPage(),
  minePage: (context) => MinePage(),
  pageAccountOverview: (context) => AccountOverviewPage(),
  pageDetailList: (context) => DetailListPage(),
  pageDetailInfo: (context) => DetailInfoPage(),
};

onGenerateRoute(RouteSettings settings) {
  if (settings.name == pageCardDetail) {
    return MaterialPageRoute(builder: (context) {
      return CardDetailPage(card: settings.arguments);
    });
  }
  return null;
}
