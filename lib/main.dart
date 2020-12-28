import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widget/progressHUD.dart';

// void main() => runApp(
//       HSGBankApp(),
//     );
void main(List<String> args) {
  runApp(
    HSGBankApp(),
  );
  //状态栏字体设置白色（电池、时间、信号等信息）
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
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
  List<PublicParameters> publicParametersList = [];

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

  @override
  Widget build(BuildContext context) {
    ///初始化progressHUD配置
    HSProgressHUD.progressHudConfig();

    return MaterialApp(
      title: 'HSGBank',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(
            headline6: TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
          )),
          splashColor: HsgColors.itemClickColor,
          primaryColor: HsgColors.primary,
          primaryColorDark: HsgColors.primaryDark,
          backgroundColor: HsgColors.commonBackground,
          dividerTheme:
              DividerThemeData(thickness: 0.7, color: HsgColors.divider)),
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
    );
  }

  _initLanguage() async {
    String language = await Language.getSaveLangage();
    changeLanguage(Language().getLocaleByLanguage(language));
  }

  //获取公共参数
  _getPublicParameters() async {
    PublicParametersRepository()
        .getPublicCode(GetPublicParametersReq(), 'GetPublicParametersReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        setState(() {
          publicParametersList = data.publicCodeGetRedisRspDtoList;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
