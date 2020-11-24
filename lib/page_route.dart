import 'package:ebank_mobile/page/bankcard/card_detail_page.dart';
import 'package:ebank_mobile/page/bankcard/card_limit_manager_page.dart';
import 'package:ebank_mobile/page/bankcard/card_list_page.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:flutter/material.dart';

var pageHome = '/';
var pageLogin = pageHome;
// var pageCardList = pageHome;
var pageCardList = '/card_list';
var pageCardDetail = '/card_detail';
var pageCardLimit = '/card_limit_manager';

var appRoutes = {
  pageLogin: (context) => LoginPage(),
  pageCardList: (context) => CardListPage(),
  // pageCardDetail: (context) => CardDetailPage(),
  pageCardLimit: (context) => CardLimitManagerPage(),
};

onGenerateRoute(RouteSettings settings) {
  if (settings.name == pageCardDetail) {
    return MaterialPageRoute(builder: (context) {
      return CardDetailPage(card: settings.arguments);
    });
  }
  return null;
}
