import 'package:flutter/material.dart';

class LinearLoading extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoading;

  LinearLoading({Key key, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 3,
        child: LinearProgressIndicator(
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white38),
        ),
      );
    } else {
      return Container(
        height: 3,
      );
    }
  }

  @override
  final Size preferredSize = Size.fromHeight(2.0);
}
