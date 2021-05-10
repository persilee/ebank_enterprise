/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-12-07

import 'package:ebank_mobile/feature_demo/dialog_demo.dart';
import 'package:ebank_mobile/page/accountOverview/account_overview_new_page.dart';
import 'package:ebank_mobile/page/approval/approval_history_detail_page.dart';
import 'package:ebank_mobile/page/approval/hsg_approval_page.dart';
import 'package:ebank_mobile/page/approval/my_to_do_task_detail_page.dart';
import 'package:ebank_mobile/page/forexTrading/forex_trading_preview_page.dart';

import 'package:ebank_mobile/page/home/hsg_feature_list_page.dart';
import 'package:ebank_mobile/page/loan/loan_collection_preview.dart';
import 'package:ebank_mobile/page/loan/loan_reference.dart';
import 'package:ebank_mobile/page/mine/avatar_view_page.dart';
import 'package:ebank_mobile/page/mine/image_editor_page.dart';

import 'package:ebank_mobile/page/mine/password_management_page.dart';
import 'package:ebank_mobile/page/openAccount/city_for_country_select_page.dart';
import 'package:ebank_mobile/page/openAccount/country_region_select_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_contact_information_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_identify_results_failure_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_identify_results_successful_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_related_individuals_data_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_results_page.dart';
import 'package:ebank_mobile/page/openAccount/open_acount_select_document_type_page.dart';
import 'package:ebank_mobile/page/register/find_user_name_success.dart';
import 'package:ebank_mobile/page/register/forget_password_page.dart';
import 'package:ebank_mobile/page/register/forget_user_name_page.dart';
import 'package:ebank_mobile/page/mine/pwd_operation_success_page.dart';
import 'package:ebank_mobile/page/mine/reset_payPwd_otp_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_basic_data_page.dart';
import 'package:ebank_mobile/page/mine/user_information_page.dart';
import 'package:ebank_mobile/page/register/register_confirm_page.dart';
import 'package:ebank_mobile/page/register/register_page.dart';
import 'package:ebank_mobile/page/register/register_success_page.dart';
import 'package:ebank_mobile/page/register/reset_password_account_open.dart';
import 'package:ebank_mobile/page/register/reset_password_no_account.dart';
import 'package:ebank_mobile/page/register/reset_password_success.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_close_info.dart';
// import 'package:ebank_mobile/page/mine/qliyan_demo_page.dart';

import 'package:ebank_mobile/page/timeDeposit/time_deposit_contract_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_contract_preview_page.dart';
import 'package:ebank_mobile/page/timeDeposit/time_depost_product_page.dart';
import 'package:ebank_mobile/page/approval/my_application_detail_page.dart';
import 'package:ebank_mobile/page/approval/my_approved_history_page.dart';
import 'package:ebank_mobile/page/approval/my_approved_history_detail_page.dart';
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
import 'package:ebank_mobile/page/transfer/hsg_open_transfer_preview_page.dart';

import 'package:ebank_mobile/page/transfer/hsg_transfer_internal_preview_page.dart';
import 'package:ebank_mobile/page/transfer/hsg_transfer_international_preview_page.dart';
import 'package:ebank_mobile/page/transfer/hsg_transfer_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_detail_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_inline.dart';
import 'package:ebank_mobile/page/transfer/transfer_inter.dart';
import 'package:ebank_mobile/page/transfer/transfer_order.dart';
import 'package:ebank_mobile/page/transfer/transfer_plan_details.dart';
import 'package:ebank_mobile/page/transfer/transfer_plan_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_record_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_partner_page.dart';
import 'package:ebank_mobile/page/transfer/add_partner_page.dart';
import 'package:ebank_mobile/page/transfer/select_bank_page.dart';
import 'package:ebank_mobile/page/transfer/select_branch_bank_page.dart';
import 'package:ebank_mobile/page/transfer/transfer_success.dart';
import 'package:ebank_mobile/page/userAgreement/user_agreement_page.dart';
import 'package:ebank_mobile/widget/camera_page.dart';
import 'package:ebank_mobile/widget/hsg_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page/mine/mine_page.dart';
import 'package:ebank_mobile/page/mine/about_us_page.dart';
import 'package:ebank_mobile/page/mine/feedback_page.dart';
import 'package:ebank_mobile/page/mine/change_logPswd_page.dart';
import 'package:ebank_mobile/page/mine/change_pay_page.dart';
import 'package:ebank_mobile/page/mine/set_pay_page.dart';
import 'package:ebank_mobile/page/openAccount/open_account_get_face_sign.dart';
import 'package:ebank_mobile/page/loan/loan_new_application_page.dart';
import 'package:ebank_mobile/page/loan/loan_product_list_page.dart';
import 'package:ebank_mobile/page/loan/loan_application_confirm_page.dart';
import 'package:ebank_mobile/page/loan/loan_myApplication_list_page.dart';
import 'package:path/path.dart';

var pageHome = '/';
var pageLogin = pageHome;
var pageUserInformation = '/user_information_page.dart';
var pageResetPayPwdOtp = '/reset_payPwd_otp_page.dart';
var pagePwdOperationSuccess = '/pwd_operation_success_page.dart';
// var pageCardList = pageHome;

var pageSelectBranchBank = "/select_branch_bank_page.dart";
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
var avatarViewPage = '/avatar_view_page';
var imageEditorPage = '/image_editor_page';
var aboutUs = '/about_us_page';
var feedback = '/feedback_page';
var changeLgPs = '/change_loginpassword_page.dart';
var changePayPS = '/change_pay_page.dart';
var setPayPage = '/set_pay_page.dart';
var iDcardVerification = '/id_cardVerification_page.dart';
var pageAccountOverview = '/account_overview_page.dart';
var pageAccountOverviewNew = 'account_overview_new_page.dart';
var pageDetailInfo = '/detail_info_page';
var pageDetailList = '/detail_list_page';
var pageDepositRecordSucceed = '/time_deposit_contract_succeed_page';
var pageTimeDepositRecord = '/time_deposit_record_page';
var pageMyDepositRate = '/time_deposit_rate_page';
var pageDepositInfo = '/time_deposit_info_page';
var pageIndex = new MaterialPageRoute(builder: (context) => new IndexPage());
var pageIndexName = '/hsg_index_page';
var pageFeatureList = '/hsg_feature_list_page';
var pageTransfer = '/hsg_transfer_page';
var pageAuthorizationHistory = '/authorization_history_page';
var pageTransferInternal = '/hsg_transfer_internal_page';
var pageTransferOrderPreview = 'hsg_open_transfer_preview_page.dart';
var pageTransferInternalPreview = '/hsg_transfer_internal_preview_page';
var pageTransferInternationalPreview =
    '/hsg_transfer_international_preview_page';
var pageTrasferInternational = '/hsg_transfer_international_page';
var pageElectronicStatement = '/electronic_statement_page';
var pageElectronicStatementDetail = '/electronic_statement_detail_page';
var hsgPdfViewer = '/hsg_pdf_viewer';
var pageTimeDepostProduct = '/time_depost_product_page';
var pageForexTrading = '/forex_trading_page';
var pageForexTradingPreview = '/forex_trading_preview_page';
var pageExchangeRateInquiry = '/exchange_rate_inquiry_page';
var pageTimeDepositContract = '/time_deposit_contract_page';
var pageTimeDepositContractPreview = '/time_deposit_contract_preview_page.dart';
var pageOpenTransfer = '/hsg_open_transfer_page';
var pageTaskApproval = '/task_approval_page';
var pageUserAgreement = '/user_agreement_page';
var pageApplication = '/my_appplication_page';
var pageApplicationTaskApproval = '/application_task_approval_page';
var pageAuthorizationTaskApproval = '/authorization_task_approval_page';
var pageAuthorizationTaskApprovalHistoryDetail =
    '/authorization_task_approval_history_detail';
var pageContactCustomer = '/contact_customer_page';
var pageTransferPlan = '/transfer_plan_page';
var pageTransferPlanDetails = '/transfer_plan_details';
var pageForgetPassword = '/forget_password_page';
var pageQianliyanDemo = '/qliyan_demo_page.dart';
var pageApprovalPage = 'hsg_approval_page';
var pageStaticApproval = '/static_my_approval_page';
var pagePasswordManagement = '/password_management_page.dart';
var pageOpenAccountBasicData = '/open_account_basic_data_page.dart';
var countryOrRegionSelectPage = '/country_region_select_page.dart';
var pageRegister = '/register_page.dart';
var pageRegisterConfirm = '/register_confirm_page.dart';
var pageRegisterSuccess = 'register_success_page.dart';
var pageForgetUserName = 'forget_user_name_page.dart';
var pageFindUserNameSuccess = 'find_user_name_success.dart';
var pageResetPasswordNoAccount = 'reset_password_no_account.dart';
var pageResetPasswordSuccess = 'reset_password_success.dart';
var pageResetPasswordOpenAccount = 'reset_password_account_open.dart';
var pageCountryRegionSelect = '/country_region_select_page.dart';
var pageOpenAccountContactInformation =
    '/open_account_contact_information_page.dart';
var pageOpenAccountSelectDocumentType =
    '/open_acount_select_document_type_page.dart';
var pageOpenAccountResults = '/open_account_results_page.dart';
var pageOpenAccountRelatedIndividualsData =
    '/open_account_related_individuals_data_page.dart';
var pageOpenAccountIdentifyResultsFailure =
    '/open_account_identify_results_failure_page.dart';
var pageOpenAccountIdentifySuccessful =
    '/open_account_identify_results_successful_page.dart';
var pageOpenAccountGetFaceSign = '/open_account_get_face_sign.dart';
var pageLoanNewApplictionNav = '/loan_new_application_page.dart';
var pageLoanProductlistNav = '/loan_product_list_page.dart';
var pageLoanConfirmNav = '/loan_application_confirm_page.dart';
var pageLoanMyApplicationList = '/loan_myApplication_list_page.dart';
var pageLoanReference = 'loan_reference.dart';
var pageLoanCollectionPreview = '/loan_collection_preview.dart';
var pageTransferInline = '/transfer_inline.dart';
var pageTransferInter = '/transfer_inter.dart';
var pageTransferOrder = '/transfer_order.dart';
var pageTransferSuccess = '/transfer_success.dart';
var pageCityForCountrySelect = '/city_for_country_select_page.dart';
var pageTimeDepositCloseDetail = '/time_deposit_close_info.dart';
var pageCamera = '/camera_page.dart';

var appRoutes = {
  pageLogin: (context) => LoginPage(),
  pageUserInformation: (context) => UserInformationPage(),
  pageResetPayPwdOtp: (context) => ResetPayPwdPage(),
  pagePwdOperationSuccess: (context) => PwdOperationSuccessPage(),
  pageIndexName: (context) => IndexPage(),
  pageLogin: (context) => LoginPage(),
  pageLoanApplication: (context) => LoanApplicationPage(),
  pageOperationResult: (context) => OperationResultPage(),
  pageLoanInterestRate: (context) => LoanInterestRatePage(),
  pageTransferRecord: (context) => TrsnsferRecordPage(),
  pageTransferDetail: (context) => TransferDetailPage(),
  pageCardList: (context) => CardListPage(),
  pageDialogDemo: (context) => DialogDemoPage(),
  pageSelectBank: (context) => SelectBankPage(),
  pageSelectBranchBank: (context) => SelectBranchBankPage(),
  pageAddPartner: (context) => AddPartnerPage(),
  pageTranferPartner: (context) => TransferPartner(),
  pageRepaySuccess: (context) => RepaySuccessPage(),
  pageRepayConfirm: (context) => RepayConfirmPage(),
  pageRepayInput: (context) => RepayInputPage(),
  pageWaitRepayPlan: (context) => WaitRepayPlanPage(),
  // pageRepayPlan: (context) => RepayPlanPage(),
  pageLimitDetails: (context) => LimitDetailsPage(),
  // pageRepayRecords: (context) => RepayRecordsPage(),
  // pageCardDetail: (context) => CardDetailPage(),
  pageCardLimit: (context) => CardLimitManagerPage(),
  minePage: (context) => MinePage(),
  // avatarViewPage: (context) => AvatarViewPage(),
  aboutUs: (context) => AboutUsPage(),
  feedback: (context) => FeedbackPage(),
  changeLgPs: (context) => ChangeLoPS(),
  setPayPage: (context) => SetPayPage(),
  changePayPS: (context) => ChangePayPage(),
  iDcardVerification: (context) => IdIardVerificationPage(),
  pageAccountOverviewNew: (context) => AccountOverviewNewPage(),
  pageDetailList: (context) => DetailListPage(),
  pageDetailInfo: (context) => DetailInfoPage(),
  pageTimeDepositRecord: (context) => TimeDepositRecordPage(),
  pageMyDepositRate: (context) => MyDepositRatePage(),
  pageDepositRecordSucceed: (context) => DepositContractSucceed(),
  //pageDepositInfo: (context) => PageDepositInfo(),
  pageFeatureList: (context) => FeatureListPage(),
  pageTransfer: (context) => TransferPage(),
  pageAuthorizationHistory: (context) => MyApprovedHistoryPage(),
  pageTransferOrderPreview: (context) => TransferOrderPreviewPage(),
  pageTransferInternalPreview: (context) => TransferInternalPreviewPage(),
  pageTransferInternationalPreview: (context) =>
      TransferinternationalPreviewPage(),
  pageElectronicStatement: (context) => ElectronicStatementPage(),
  pageElectronicStatementDetail: (context) => ElectronicStatementDetailPage(),
  hsgPdfViewer: (context) => HsgPdfViewer(),
  pageTimeDepostProduct: (context) => TimeDepostProduct(),
  // pageTimeDepositContract: (context) => TimeDepositContract(),
  pageTimeDepositContractPreview: (context) => TimeDepositContractPreviewPage(),
  pageForexTrading: (context) => ForexTradingPage(),
  pageForexTradingPreview: (context) => ForexTradingPreviewPage(),
  // pageTaskApproval: (context) => TaskApprovalPage(),
  pageApplication: (context) => MyApplicationPage(),
  // pageApplicationTaskApproval: (context) => ApplicationTaskApprovalPage(),
  // pageAuthorizationTaskApproval: (context) => AuthorizationTaskApprovalPage(),
  pageExchangeRateInquiry: (context) => ExchangeRateInquiryPage(),
  pageOpenTransfer: (context) => OpenTransferPage(),
  pageContactCustomer: (context) => ContactCustomerPage(),
  pageTransferPlan: (context) => TransferPlanPage(),
  // pageTransferPlanDetails: (context) => TransferPlanDetailsPage(),
  pageForgetPassword: (context) => ForgetPasswordPage(),
  pageApprovalPage: (context) => ApprovalPage(),
  pageFeatureList: (context) => FeatureListPage(),
  // pageQianliyanDemo: (context) => QianliyanDemoPage(),

  pagePasswordManagement: (context) => PasswordManagementPage(),
  pageOpenAccountBasicData: (context) => OpenAccountBasicDataPage(),
  countryOrRegionSelectPage: (context) => CountryOrRegionSelectPage(),
  pageRegister: (context) => RegisterPage(),
  pageRegisterConfirm: (context) => RegisterConfirmPage(),
  pageRegisterSuccess: (context) => RegisterSuccessPage(),
  pageForgetUserName: (context) => ForgetUserName(),
  pageFindUserNameSuccess: (context) => FindUserNameSuccess(),
  pageResetPasswordNoAccount: (context) => ResetPasswordNoAccount(),
  pageResetPasswordSuccess: (context) => ResetPasswordPage(),
  pageResetPasswordOpenAccount: (context) => ResetPasswordAccountOpen(),
  pageCountryRegionSelect: (context) => CountryOrRegionSelectPage(),
  // pageOpenAccountContactInformation: (context) =>
  //     OpenAccountContactInformationPage(),
  pageOpenAccountSelectDocumentType: (context) =>
      OpenAccountSelectDocumentTypePage(),
  pageOpenAccountResults: (context) => OpenAccountResultsPage(),
  // pageOpenAccountRelatedIndividualsData: (context) =>
  //     RelatedIndividualsDataPage(),
  pageOpenAccountIdentifyResultsFailure: (context) =>
      OpenAccountIdentifyResultsFailurePage(),
  pageOpenAccountIdentifySuccessful: (context) =>
      OpenAccountIdentifyResultsSuccessfulPage(),
  pageOpenAccountGetFaceSign: (context) => OpenAccountGetFaceSignPage(),
  pageLoanNewApplictionNav: (context) => LoanNewApplicationPage(), //
  pageLoanProductlistNav: (context) => LoanProductListPage(),
  pageLoanConfirmNav: (context) => LoanConfirmApplicationList(),
  pageLoanMyApplicationList: (context) => LoanMyApplicationListPage(), //贷款 我的申请
  pageLoanReference: (context) => LoanReference(),
  pageLoanCollectionPreview: (context) => PageLoanCollectionPreview(), //贷款领用预览
  pageTransferInline: (context) => TransferInlinePage(),
  pageTransferInter: (context) => TransferInterPage(),
  pageTransferOrder: (context) => TransferOrderPage(),
  pageTransferSuccess: (context) => TransferSuccessPage(),
  // pageCityForCountrySelect: (context) => CityForCountrySelectPage(),
  pageTimeDepositCloseDetail: (context) => DepositCloseInfoPage(),
  pageCamera: (context) => CameraPage(),
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
        // productList: data['tdepProduct'],
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
      Map<String, dynamic> arguments = settings.arguments;
      return MyApprovedHistoryDetailPage(
        data: arguments['data'],
        title: arguments['title'],
      );
    });
  }
  if (settings.name == pageAuthorizationTaskApprovalHistoryDetail) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return ApprovalHistoryDetailPage();
    });
  }
  if (settings.name == pageTransferPlanDetails) {
    return MaterialPageRoute(builder: (context) {
      return TransferPlanDetailsPage(transferPlan: settings.arguments);
    });
  }
  if (settings.name == pageApplicationTaskApproval) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return MyApplicationDetailPage(
        history: arguments['data'],
        title: arguments['title'],
      );
    });
  }
  if (settings.name == pageTaskApproval) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return MyToDoTaskDetailPage(
        data: arguments['data'],
        title: arguments['title'],
      );
    });
  }
  if (settings.name == pageOpenAccountRelatedIndividualsData) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return RelatedIndividualsDataPage(
        dataReq: arguments['data'],
      );
    });
  }

  if (settings.name == pageOpenAccountContactInformation) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return OpenAccountContactInformationPage(
        dataReq: arguments['data'],
      );
    });
  }

  if (settings.name == pageloanDetails) {
    //跳转贷款详情
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return LoanDetailsPage(
        loanAccountDetail: arguments['data'],
      );
    });
  }

  if (settings.name == pageRepayRecords) {
    //跳转贷款还款记录
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return RepayRecordsPage(
        loanDetail: arguments['data'],
      );
    });
  }
  if (settings.name == pageRepayPlan) {
    //跳转贷款还款计划
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return RepayPlanPage(
        loanDetail: arguments['data'],
      );
    });
  }
  if (settings.name == avatarViewPage) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return AvatarViewPage(
        imgUrl: arguments['imgUrl'],
      );
    });
  }
  if (settings.name == imageEditorPage) {
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return ImageEditorPage(
        imageData: arguments['imageData'],
      );
    });
  }

  if (settings.name == pageCityForCountrySelect) {
    //跳转选择城市
    return MaterialPageRoute(builder: (context) {
      Map<String, dynamic> arguments = settings.arguments;
      return CityForCountrySelectPage(
        countryData: arguments['data'],
      );
    });
  }

  return null;
}
