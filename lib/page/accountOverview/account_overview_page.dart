import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountOverviewPage extends StatefulWidget {
  @override
  _AccountOverviewPageState createState() => _AccountOverviewPageState();
}

class _AccountOverviewPageState extends State<AccountOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账户总览'),
        // centerTitle: true,
        // backgroundColor: Color(0xFF2F323E),
        // elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: ListView(
          children: [
            Container(
              height: 162,
              decoration: BoxDecoration(
                color: Color(0xFF2F323E),
              ),
              padding: EdgeInsets.fromLTRB(0, 19, 0, 30),
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
