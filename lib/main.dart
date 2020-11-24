import 'package:flutter/material.dart';
import 'package:ebank_mobile/page_route.dart';

void main() => runApp(HSGBankApp());

class HSGBankApp extends StatelessWidget {
  const HSGBankApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSGBank',
      theme: ThemeData(
          primarySwatch: Colors.blue, backgroundColor: Colors.white70),
      initialRoute: pageHome,
      routes: appRoutes,
      onGenerateRoute: (settings) => onGenerateRoute(settings),
    );
  }
}
