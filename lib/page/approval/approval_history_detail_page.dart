import 'package:ebank_mobile/data/source/model/approval/one_to_one_transfer_detail_model.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ApprovalHistoryDetailPage extends StatefulWidget {
  final title;
  final List<dynamic> data;

  ApprovalHistoryDetailPage({Key key, this.title, this.data})
      : super(key: key);

  @override
  _ApprovalHistoryDetailPageState createState() =>
      _ApprovalHistoryDetailPageState();
}

class _ApprovalHistoryDetailPageState
    extends State<ApprovalHistoryDetailPage> {
  ScrollController _scrollController;
  List<Widget> _commentList = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _loadData() {
    widget.data.forEach((element) {
      _commentList.add(_buildContentItem(S.current.approver, element.userName));
      _commentList.add(_buildContentItem(S.current.approver_time, element.time));
      _commentList.add(_buildContentItem(S.current.approver_opinion, element.comment));
      _commentList.add(_buildContentItem(S.current.approver_result, element.result == true ? S.current.approve_history_successful : S.current.approve_history_failure));
      _commentList.add(Padding(padding: EdgeInsets.only(top: 15)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('审批历史详情'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(int.parse('0xffF7F7F7')),
          child: Column(
            children: [
              ..._commentList,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      color: Colors.white,
      height: 46,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(String name, String value) {
    return Container(
      height: 46,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 13.0),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 13.0, color: Color(int.parse('0xff7A7A7A'))),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
