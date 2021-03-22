import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.fill,
      ),
    );
  }
}
