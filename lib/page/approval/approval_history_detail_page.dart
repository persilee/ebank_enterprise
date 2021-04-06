import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ApprovalHistoryDetailPage extends StatefulWidget {
  final FinishTaskDetail history;
  final title;

  ApprovalHistoryDetailPage({Key key, this.history, this.title})
      : super(key: key);

  @override
  _ApprovalHistoryDetailPageState createState() =>
      _ApprovalHistoryDetailPageState();
}

class _ApprovalHistoryDetailPageState
    extends State<ApprovalHistoryDetailPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              Padding(padding: EdgeInsets.only(top: 15)),
              _buildTitle('审批历史'),
              _buildContentItem('审批人', '廖珠星'),
              _buildContentItem('审批时间', '2021-03-02 19:31:33'),
              _buildContentItem('审批意见', 'Yes'),
              _buildContentItem('审批结果', '成功'),
              Padding(padding: EdgeInsets.only(top: 15)),
              _buildContentItem('审批人', '康听白'),
              _buildContentItem('审批时间', '2021-03-03 12:12:43'),
              _buildContentItem('审批意见', '同意'),
              _buildContentItem('审批结果', '成功'),
              Padding(padding: EdgeInsets.only(top: 15)),
              _buildContentItem('审批人', '冯晓霞'),
              _buildContentItem('审批时间', '2021-03-04 09:22:36'),
              _buildContentItem('审批意见', '我觉得次交易可以通过统一'),
              _buildContentItem('审批结果', '成功'),
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
