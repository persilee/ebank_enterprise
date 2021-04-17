import 'dart:io';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/splash_page.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';
import 'widget/progressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebank_mobile/util/small_data_store.dart';

// void main() => runApp(
//       HSGBankApp(),
//     );
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      HSGBankApp(),
    );
  });
}

class HSGBankApp extends StatefulWidget {
  const HSGBankApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _HSGBankAppState state =
        context.findAncestorStateOfType<_HSGBankAppState>();
    state.changeLanguage(newLocale);
  }

  @override
  _HSGBankAppState createState() => _HSGBankAppState();
}

class _HSGBankAppState extends State<HSGBankApp> with WidgetsBindingObserver {
  // 获取app名称、版本号等信息
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  changeLanguage(Locale locale) {
    setState(() {
      S.load(locale);
    });
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    print('_initPackageInfo: $info');
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    // _initLanguage();
    _getPublicParameters();
    WidgetsBinding.instance.addObserver(this);
  }

  // 监听APP运行状态
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        if (Platform.isAndroid) {
          Fluttertoast.showToast(
            msg: '${_packageInfo.appName}进入后台运行',
            gravity: ToastGravity.CENTER,
          );
        }
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ///初始化progressHUD配置
    HSProgressHUD.progressHudConfig();

    ///这是设置状态栏的图标和字体的颜色
    ///Brightness.light  一般都是显示为白色
    ///Brightness.dark 一般都是显示为黑色
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
    ScreenUtil.init(width: 360, height: 920, allowFontScaling: true);
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      headerTriggerDistance: 90.0,
      maxOverScrollExtent: 100,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      hideFooterWhenNotFull: true,
      shouldFooterFollowWhenNotFull: (state) {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HSGBank',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 1,
            textTheme: TextTheme(
              headline6: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 18,
                color: Color(0xff262626),
              ),
            ),
          ),
          splashColor: HsgColors.itemClickColor,
          primaryColor: HsgColors.primaryLight,
          primaryColorDark: HsgColors.primaryDark,
          backgroundColor: HsgColors.commonBackground,
          dividerTheme:
              DividerThemeData(thickness: 0.7, color: HsgColors.divider),
        ),
        initialRoute: pageHome,
        routes: appRoutes,
        onGenerateRoute: (settings) => onGenerateRoute(settings),
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        // ignore: missing_return
        localeResolutionCallback: (locale, supportedLocales) {
          _initLang(locale);
        },
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              hideKeyboard(context);
            },
            child: child,
          ),
        ),
      ),
    );
  }

  // _initLanguage() async {
  //   String language = await Language.getSaveLangage();

  //   print('language $language');
  //   changeLanguage(Language().getLocaleByLanguage(language));
  // }

  _initLang(Locale deviceLocale) async {
    String lang = 'en';
    if (deviceLocale.languageCode == 'zh') {
      if (deviceLocale.scriptCode == 'Hans') {
        lang = 'zh_cn';
      } else {
        lang = 'zh_hk';
      }
    } else {
      lang = 'en';
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.DEVICELANGUAGE, lang);
    String language = await Language.getSaveLangage();
    changeLanguage(Language().getLocaleByLanguage(language));
  }

  //获取公共参数
  _getPublicParameters() async {
    final prefs = await SharedPreferences.getInstance();

    // //获取证件类型
    // PublicParametersRepository()
    //     .getIdType(GetIdTypeReq('TORPC'), 'GetIdTypeReq') //TORPC//CERT_TYPE
    //     .then((data) {
    //   if (data.publicCodeGetRedisRspDtoList != null) {}
    // }).catchError((e) {
    //   Fluttertoast.showToast(
    //     msg: e.toString(),
    //     gravity: ToastGravity.CENTER,
    //   );
    // });

    //获取本币
    PublicParametersRepository()
        .getLocalCurrency(GetLocalCurrencyReq(), 'GetLocalCurrencyReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        String code = data.publicCodeGetRedisRspDtoList[0].code;
        if (code != prefs.getString(ConfigKey.LOCAL_CCY)) {
          prefs.setString(ConfigKey.LOCAL_CCY, code);
        }
      } else {
        prefs.setString(ConfigKey.LOCAL_CCY, '');
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
