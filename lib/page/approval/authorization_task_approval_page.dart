import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:flutter/material.dart';

class AuthorizationTaskApprovalPage extends StatefulWidget {
  final FinishTaskDetail history;
  final title;

  AuthorizationTaskApprovalPage({Key key, this.history, this.title})
      : super(key: key);

  @override
  _AuthorizationTaskApprovalPageState createState() =>
      _AuthorizationTaskApprovalPageState();
}

class _AuthorizationTaskApprovalPageState
    extends State<AuthorizationTaskApprovalPage> {
  ScrollController _scrollController;
  List<Widget> _contents = [];
  List<Widget> _contentItems = [];

  var historyRegular = {
    "data": [
      {
        "title": "基本信息",
        "content": [
          {
            "name": "产品",
            "value": "整取整存",
          },
          {
            "name": "存款期限",
            "value": "11-12月",
          },
          {
            "name": "金额",
            "value": "200",
          },
          {
            "name": "年利率",
            "value": "1.3%",
          },
          {
            "name": "存单货币",
            "value": "HKD-港元",
          },
          {
            "name": "到期指示",
            "value": "0-等待客户指示",
          },
          {
            "name": "结算账户",
            "value": "5000000066003",
          },
          {
            "name": "扣款账户",
            "value": "5000000066003",
          },
        ]
      },
      {
        "title": "审批历史",
        "content": [
          {
            "name": "审批人",
            "value": "50006147456464",
          },
          {
            "name": "审批时间",
            "value": "2021-03-02 19:31:33",
          },
          {
            "name": "审批意见",
            "value": "Yes",
          },
          {
            "name": "审批结果",
            "value": "成功",
          },
        ]
      }
    ],
  };

  @override
  void initState() {
    _scrollController = ScrollController();
    _getContent();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getContent() {
    _contents.add(_buildContent());
    historyRegular['data'].forEach((e) {
      _contentItems.add(_buildTitle(e['title']));
      (e['content'] as List).forEach((element) {
        _contentItems.add(_buildContentItem(element['name'], element['value']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(int.parse('0xffF7F7F7')),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: _contentItems,
    );
  }

  Widget _buildTitle(String title) {
    return Container(
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
