/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task_detail.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class AuthorizationTaskApprovalPage extends StatefulWidget {
  final Rows history;
  AuthorizationTaskApprovalPage({Key key, this.history}) : super(key: key);

  @override
  _AuthorizationTaskApprovalPageState createState() =>
      _AuthorizationTaskApprovalPageState(history);
}

class _AuthorizationTaskApprovalPageState
    extends State<AuthorizationTaskApprovalPage> {
  Rows history;
  _AuthorizationTaskApprovalPageState(this.history);

  @override
  void initState() {
    super.initState();
    _loadHistoryData(history.processId);
  }

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
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                children: [
                  _getHintLine(),
                  _getRow('账号名称', 'mike'),
                  _getHintLine(),
                  _getRow('转入货币', 'EUR')
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
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
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      '审批历史',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SizedBox(
                child: Column(
                  children: [
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Column(
                          children: [
                            _getHintLine(),
                            //发起人
                            _getRow('审批人', '77664564548'),
                            //待办任务名称
                            _getRow('审批时间', '一对一转账审批'),
                            //创建时间
                            _getRow('审批意见', '2020-11-11 14:16:24'),
                            //审批结果
                            _getRow('审批结果', 'ok'),
                          ],
                        ))
                  ],
                ),
              );
            },
            childCount: 4,
          ))
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

  void _loadHistoryData(String processId) {
    Future.wait({
      NeedToBeDealtWithRepository().findUserFinishedDetail(
          GetFindUserFinishedDetailReq(processId), 'findUserFinishedDetail')
    }).then((data) {
      setState(() {});
    });
  }
}
