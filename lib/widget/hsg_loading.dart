import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HsgLoading extends StatelessWidget {

  final Widget child;

  const HsgLoading({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child ?? Center(
      child: Lottie.asset(
        'assets/json/loading2.json',
        width: 126,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}