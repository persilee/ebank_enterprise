/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-12-07

import 'package:ebank_mobile/feature_demo/dialog_demo.dart';
import 'package:ebank_mobile/page/approval/task_approval_page.dart';
import 'package:ebank_mobile/page/home/hsg_feature_list_page.dart';
import 'package:ebank_mobile/page/login/forget_password_page.dart';
import 'package:ebank_mobile/page/mine/qliyan_demo_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_contract_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_depost_product_page.dart';
import 'package:ebank_mobile/page/accountOverview/account_overview_page.dart';
import 'package:ebank_mobile/page/approval/application_task_approval_page.dart';
import 'package:ebank_mobile/page/approval/authorization_history_page.dart';
import 'package:ebank_mobile/page/approval/authorization_task_approval_page.dart';
import 'package:ebank_mobile/page/approval/my_appplication_page.dart';
import 'package:ebank_mobile/page/bankcard/card_detail_page.dart';
import 'package:ebank_mobile/page/bankcard/card_limit_manager_page.dart';
import 'package:ebank_mobile/page/bankcard/card_list_page.dart';
import 'package:ebank_mobile/page/customerService/contact_customer_page.dart';
import 'package:ebank_mobile/page/electronicStatement/electronic_statement_detail_page.dart';
import 'package:ebank_mobile/page/electronicStatement/electronic_statement_page.dart';
import 'package:ebank_mobile/page/exchangeRateInquiry/exchange_rate_inquiry_page.dart';
import 'package:ebank_mobile/page/mine/id_cardVerification_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_contract_succeed_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_record_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_info_page.dart';
import 'package:ebank_mobile/page/forexTrading/forex_trading_page.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page/loan/loan_application_page.dart';
import 'package:ebank_mobile/page/loan/loan_details_page.dart';
import 'package:ebank_mobile/page/loan/loan_interest_rate_page.dart';
import 'package:ebank_mobile/page/loan/limit_details_page.dart';
import 'package:ebank_mobile/page/loan/operation_result_page.dart';
import 'package:ebank_mobile/page/loan/repay_confirm_page.dart';
import 'package:ebank_mobile/page/loan/repay_input_page.dart';
import 'package:ebank_mobile/page/loan/repay_plan_page.dart';
import 'package:ebank_mobile/page/loan/repay_records_page.dart';
import 'package:ebank_mobile/page/loan/repay_success_page.dart';
import 'package:ebank_mobile/page/loan/wait_repay_plan_page.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page/payCollectDetail/detail_info_page.dart';
import 'package:ebank_mobile/page/payCollectDetail/detail_list_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_rate_page.dart';
import 'package:ebank_mobile/page/transfer/hsg_open_transfer_page.dart';

import 'package:ebank_mobile/page/transfer/hsg_transfer_internal_page.dart';
import 'package:ebank_mobile/page/transfer/hsg_transfer_international_page.dart';
import 'package:ebank_mobile/page/transfer/hsg_transfer_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_detail_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_plan_details.dart';
import 'package:ebank_mobile/page/transfer/transfer_plan_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_record-page.dart';
import 'package:ebank_mobile/page/transfer/transfer_partner_page.dart';
import 'package:ebank_mobile/page/transfer/add_partner_page.dart';
import 'package:ebank_mobile/page/transfer/select_bank_page.dart';
import 'package:ebank_mobile/page/transfer/select_city_page.dart';
import 'package:ebank_mobile/page/transfer/select_branch_bank_page.dart';
import 'package:ebank_mobile/page/userAgreement/user_agreement_page.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page/mine/mine_page.dart';
import 'package:ebank_mobile/page/mine/about_us_page.dart';
import 'package:ebank_mobile/page/mine/feedback_page.dart';
import 'package:ebank_mobile/page/mine/change_logPswd_page.dart';
import 'package:ebank_mobile/page/mine/change_pay_page.dart';
import 'package:ebank_mobile/page/mine/set_pay_page.dart';

var pageHome = '/';
var pageLogin = pageHome;
// var pageCardList = pageHome;

var pageSelectBranchBank = "/select_branch_bank_page.dart";
var pageSelectCity = "/select_city_page.dart";
var pageSelectBank = "/select_bank_page.dart";
var pageAddPartner = "/add_partner_page.dart";
var pageTranferPartner = "/transfer_partner_page.dart";
var pageLoanApplication = "/loan_application_page";
var pageTransferRecord = "/transfer_record_page";
var pageTransferDetail = "/transfer_detail_page";
var pageOperationResult = "/operation_result_page";
var pageRepaySuccess = "/repay_success_page.dart";
var pageRepayConfirm = "/repay_confirm_page.dart";
var pageRepayInput = "/repay_input_page.dart";
var pageWaitRepayPlan = "/wait_repay_plan_page.dart";
var pageRepayPlan = "/repay_plan_page";
var pageLimitDetails = "/limit_details_page";
var pageloanDetails = '/loan_details_page';
var pageLoanInterestRate = '/loan_interest_rate_page';
var pageRepayRecords = "/repay_records_page";
var pageCardList = '/card_list';
var pageDialogDemo = '/dialog_demo';
var pageCardDetail = '/card_detail';
var pageCardLimit = '/card_limit_manager';
var minePage = '/mine_page';
var aboutUs = '/about_us_page';
var feedback = '/feedback_page';
var changeLgPs = '/change_loginpassword_page.dart';
var changePayPS = '/change_pay_page.dart';
var setPayPage = '/set_pay_page.dart';
var iDcardVerification = '/id_cardVerification_page.dart';
var pageAccountOverview = '/account_overview';
var pageDetailInfo = '/detail_info_page';
var pageDetailList = '/detail_list_page';
var pageDepositRecordSucceed = '/time_deposit_contract_succeed_page';
var pageTimeDepositRecord = '/time_deposit_record_page';
var pageMyDepositRate = '/time_deposit_rate_page';
var pageDepositInfo = '/time_deposit_info_page';
var pageIndex = new MaterialPageRoute(builder: (context) => new IndexPage());
var pageFeatureList = '/hsg_feature_list_page';
var pageTransfer = '/hsg_transfer_page';
var pageAuthorizationHistory = '/authorization_history_page';
var pageTransferInternal = '/hsg_transfer_internal_page';
var pageInternational = '/hsg_transfer_international_page';
var pageElectronicStatement = '/electronic_statement_page';
var pageElectronicStatementDetail = '/electronic_statement_detail_page';
var pageTimeDepostProduct = '/time_depost_product_page';
var pageForexTrading = '/forex_trading_page';
var pageExchangeRateInquiry = '/exchange_rate_inquiry_page';
var pageTimeDepositContract = '/time_deposit_contract_page';
var pageOpenTransfer = '/hsg_open_transfer_page';
var pageTaskApproval = '/task_approval_page';
var pageUserAgreement = '/user_agreement_page';
var pageApplication = '/my_appplication_page';
var pageApplicationTaskApproval = '/application_task_approval_page';
var pageAuthorizationTaskApproval = '/authorization_task_approval_page';
var pageContactCustomer = '/contact_customer_page';
var pageTransferPlan = '/transfer_plan_page';
var pageTransferPlanDetails = '/transfer_plan_details';
var pageForgetPassword = '/forget_password_page';
var pageQianliyanDemo = '/qliyan_demo_page.dart';

var appRoutes = {
  pageLogin: (context) => LoginPage(),
  pageloanDetails: (context) => LoanDetailsPage(),
  pageLogin: (context) => LoginPage(),
  pageLoanApplication: (context) => LoanApplicationPage(),
  pageOperationResult: (context) => OperationResultPage(),
  pageLoanInterestRate: (context) => LoanInterestRatePage(),
  pageTransferRecord: (context) => TrsnsferRecordPage(),
  pageTransferDetail: (context) => TransferDetailPage(),
  pageCardList: (context) => CardListPage(),
  pageDialogDemo: (context) => DialogDemoPage(),
  pageSelectBank: (context) => SelectBankPage(),
  pageSelectCity: (context) => SelectCityPage(),
  pageSelectBranchBank: (context) => SelectBranchBankPage(),
  pageAddPartner: (context) => AddPartnerPage(),
  pageTranferPartner: (context) => TransferPartner(),
  pageRepaySuccess: (context) => RepaySuccessPage(),
  pageRepayConfirm: (context) => RepayConfirmPage(),
  pageRepayInput: (context) => RepayInputPage(),
  pageWaitRepayPlan: (context) => WaitRepayPlanPage(),
  pageRepayPlan: (context) => RepayPlanPage(),
  pageLimitDetails: (context) => LimitDetailsPage(),
  pageRepayRecords: (context) => RepayRecordsPage(),
  // pageCardDetail: (context) => CardDetailPage(),
  pageCardLimit: (context) => CardLimitManagerPage(),
  minePage: (context) => MinePage(),
  aboutUs: (context) => AboutUsPage(),
  feedback: (context) => FeedbackPage(),
  changeLgPs: (context) => ChangeLoPS(),
  setPayPage: (context) => SetPayPage(),
  changePayPS: (context) => ChangePayPage(),
  iDcardVerification: (context) => IdIardVerificationPage(),
  pageAccountOverview: (context) => AccountOverviewPage(),
  pageDetailList: (context) => DetailListPage(),
  pageDetailInfo: (context) => DetailInfoPage(),
  pageTimeDepositRecord: (context) => TimeDepositRecordPage(),
  pageMyDepositRate: (context) => MyDepositRatePage(),
  pageDepositRecordSucceed: (context) => DepositContractSucceed(),
  //pageDepositInfo: (context) => PageDepositInfo(),
  pageInternational: (context) => TransferInternationalPage(),
  pageFeatureList: (context) => FeatureListPage(),
  pageTransfer: (context) => TransferPage(),
  pageAuthorizationHistory: (context) => AuthorizationHistoryPage(),
  pageTransferInternal: (context) => TransferInternalPage(),
  pageElectronicStatement: (context) => ElectronicStatementPage(),
  pageElectronicStatementDetail: (context) => ElectronicStatementDetailPage(),
  pageTimeDepostProduct: (context) => TimeDepostProduct(),
  // pageTimeDepositContract: (context) => TimeDepositContract(),
  pageForexTrading: (context) => ForexTradingPage(),
  pageTaskApproval: (context) => TaskApprovalPage(),
  pageApplication: (context) => MyApplicationPage(),
  pageApplicationTaskApproval: (context) => ApplicationTaskApprovalPage(),
  // pageAuthorizationTaskApproval: (context) => AuthorizationTaskApprovalPage(),
  pageExchangeRateInquiry: (context) => ExchangeRateInquiryPage(),
  pageOpenTransfer: (context) => OpenTransferPage(),
  pageContactCustomer: (context) => ContactCustomerPage(),
  pageTransferPlan: (context) => TransferPlanPage(),
  // pageTransferPlanDetails: (context) => TransferPlanDetailsPage(),
  pageForgetPassword: (context) => ForgetPasswordPage(),
  pageFeatureList: (context) => FeatureListPage(),
  pageQianliyanDemo: (context) => QianliyanDemoPage(),
};
onGenerateRoute(RouteSettings settings) {
  if (settings.name == pageCardDetail) {
    return MaterialPageRoute(builder: (context) {
      return CardDetailPage(card: settings.arguments);
    });
  }

  if (settings.name == pageTimeDepositContract) {
    return MaterialPageRoute(builder: (context) {
      Map data = settings.arguments;
      return TimeDepositContract(
        productList: data['tdepProduct'],
        producDTOList: data['tdepProducDTOList'],
      );
    });
  }
  if (settings.name == pageDepositInfo) {
    return MaterialPageRoute(builder: (context) {
      return PageDepositInfo(deposit: settings.arguments);
    });
  }
  if (settings.name == pageUserAgreement) {
    return MaterialPageRoute(builder: (context) {
      return UserAgreementPage(pactId: settings.arguments);
    });
  }
  if (settings.name == pageAuthorizationTaskApproval) {
    return MaterialPageRoute(builder: (context) {
      return AuthorizationTaskApprovalPage(history: settings.arguments);
    });
  }
  if (settings.name == pageTransferPlanDetails) {
    return MaterialPageRoute(builder: (context) {
      return TransferPlanDetailsPage(transferPlan: settings.arguments);
    });
  }
  return null;
}
