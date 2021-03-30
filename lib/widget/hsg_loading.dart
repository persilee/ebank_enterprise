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
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3394D4)),
          backgroundColor: Color(0xff3394D4).withOpacity(0.6),
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}