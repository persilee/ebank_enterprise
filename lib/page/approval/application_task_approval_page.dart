import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class ApplicationTaskApprovalPage extends StatefulWidget {
  ApplicationTaskApprovalPage({Key key}) : super(key: key);

  @override
  _ApplicationTaskApprovalPageState createState() =>
      _ApplicationTaskApprovalPageState();
}

class _ApplicationTaskApprovalPageState
    extends State<ApplicationTaskApprovalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务审批'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              '转账信息',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              '付款信息',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                  _getHintLine(),
                  _getRow('付款账户', '84981891898'),
                ],
              ),
            ),
          ),
        ],
      ),

      // child: child,
    );
  }

  _getRow(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(leftText),
          ),
          Container(
            child: Text(rightText),
          )
        ],
      ),
    );
  }

  _getHintLine() {
    return Container(
        child: Divider(
      color: HsgColors.divider,
      height: 0.5,
    ));
  }
}
