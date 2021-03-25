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
  runApp(
    HSGBankApp(),
  );
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

class _HSGBankAppState extends State<HSGBankApp> {
  changeLanguage(Locale locale) {
    setState(() {
      S.load(locale);
    });
  }

  @override
  void initState() {
    super.initState();
    _initLanguage();
    _getPublicParameters();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HSGBank',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
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
    );
  }

  _initLanguage() async {
    String language = await Language.getSaveLangage();

    print('language $language');
    changeLanguage(Language().getLocaleByLanguage(language));
  }

  //获取公共参数
  _getPublicParameters() async {
    final prefs = await SharedPreferences.getInstance();

    //获取证件类型
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('CERT_TYPE'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {}
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

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
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
