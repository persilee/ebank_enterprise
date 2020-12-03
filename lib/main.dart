import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'widget/progressHUD.dart';

// void main() => runApp(
//       HSGBankApp(),
//     );
void main(List<String> args) {
  runApp(
    HSGBankApp(),
  );
  //白色
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
  Locale _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
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
      locale: _locale,
    );
  }
}
