import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class ApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).approval,
        ),
      ),
      body: Center(
        child: Text(S.of(context).approval),
      ),
    );
  }
}
