import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).mine,
        ),
      ),
      body: Center(
        child: Text(S.of(context).mine),
      ),
    );
  }
}
