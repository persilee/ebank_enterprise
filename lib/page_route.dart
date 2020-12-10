import 'package:ebank_mobile/page/accountOverview/account_overview_page.dart';
import 'package:ebank_mobile/page/bankcard/card_detail_page.dart';
import 'package:ebank_mobile/page/bankcard/card_limit_manager_page.dart';
import 'package:ebank_mobile/page/bankcard/card_list_page.dart';
import 'package:ebank_mobile/page/home/hsg_feature_list_page.dart';
import 'package:ebank_mobile/feature_demo/dialog_demo.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page/loan/loan_interest_rate.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page/payCollectDetail/detail_info_page.dart';
import 'package:ebank_mobile/page/payCollectDetail/detail_list_page.dart';
import 'package:ebank_mobile/page/transfer/hsg_transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page/mine/mine_page.dart';
import 'package:ebank_mobile/page/mine/about_us_page.dart';
import 'package:ebank_mobile/page/mine/feedback_page.dart';
import 'package:ebank_mobile/page/mine/hsg_mine_page.dart';
import 'package:ebank_mobile/page/mine/change_logPswd_page.dart';

var pageHome = '/';
var pageLogin = pageHome;
// var pageCardList = pageHome;
//var pageloanDemo = pageHome;
//var pageloanDemo = '/loan_demo';
//var pageLoanInterestRate = pageHome;
var pageLoanInterestRate = '/loan_interest_rate';
var pageCardList = '/card_list';
var pageDialogDemo = '/dialog_demo';
var pageCardDetail = '/card_detail';
var pageCardLimit = '/card_limit_manager';
var minePage = '/mine_page';
var hsgMinePage = '/hsg_mine_page';
var aboutUs = '/about_us_page';
var feedback = '/feedback_page';
var changeLgPs = '/change_loginpassword_page';
var pageAccountOverview = '/account_overview';
var pageDetailInfo = '/detail_info_page';
var pageDetailList = '/detail_list_page';
var pageIndex = new MaterialPageRoute(builder: (context) => new IndexPage());
var pageFeatureList = '/hsg_feature_list_page';
var pageTransfer = '/hsg_transfer_page';

var appRoutes = {
  pageLogin: (context) => LoginPage(),
  //pageloanDemo: (context) => LoanDemoPage(),
  pageLoanInterestRate: (context) => LoanInterestRatePage(),
  pageCardList: (context) => CardListPage(),
  pageDialogDemo: (context) => DialogDemoPage(),
  // pageCardDetail: (context) => CardDetailPage(),
  pageCardLimit: (context) => CardLimitManagerPage(),
  minePage: (context) => MineqPage(),
  hsgMinePage: (context) => MinePage(),
  aboutUs: (context) => AboutUsPage(),
  feedback: (context) => FeedbackPage(),
  changeLgPs: (context) => ChangeLoPS(),
  pageAccountOverview: (context) => AccountOverviewPage(),
  pageDetailList: (context) => DetailListPage(),
  pageDetailInfo: (context) => DetailInfoPage(),
  pageFeatureList: (context) => FeatureListPage(),
  pageTransfer: (context) => TransferPage(),
};

onGenerateRoute(RouteSettings settings) {
  if (settings.name == pageCardDetail) {
    return MaterialPageRoute(builder: (context) {
      return CardDetailPage(card: settings.arguments);
    });
  }
  return null;
}
