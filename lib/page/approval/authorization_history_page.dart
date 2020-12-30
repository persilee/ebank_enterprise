import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../page_route.dart';

class AuthorizationHistoryPage extends StatefulWidget {
  AuthorizationHistoryPage({Key key}) : super(key: key);

  @override
  _AuthorizationHistoryPageState createState() =>
      _AuthorizationHistoryPageState();
}

class _AuthorizationHistoryPageState extends State<AuthorizationHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return SizedBox(
                child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, pageAuthorizationTaskApproval);
                print('选择账号');
              },
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: [
                          //发起人
                          _getRow(S.current.sponsor, '77664564548'),
                          //待办任务名称
                          _getRow(S.current.to_do_task_name, '一对一转账审批'),
                          //创建时间
                          _getRow(
                              S.current.creation_time, '2020-11-11 14:16:24')
                        ],
                      ))
                ],
              ),
            ));
          },
          childCount: 4,
        ))
      ],
    );
  }

  _getRow(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(leftText),
          ),
          Container(
            child: Text(
              rightText,
              style: TextStyle(
                color: HsgColors.secondDegreeText,
              ),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
