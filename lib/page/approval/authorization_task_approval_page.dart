import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../page_route.dart';

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
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(int.parse('0xffF7F7F7')),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 15)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, pageAuthorizationTaskApprovalHistoryDetail);
                },
                child: _buildTitle('审批历史', true),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              _buildTitle('基本信息', false),
              _buildContentItem('存款期限', '11-12月'),
              _buildContentItem('金额', '200'),
              _buildContentItem('年利率', '1.3%'),
              _buildContentItem('存单货币', 'HKD-港元'),
              _buildContentItem('到期指示', '0-等待客户指示'),
              _buildContentItem('结算账户', '5000000066003'),
              _buildContentItem('扣款账户', '5000000066003'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, bool isShowAvatar) {
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
                  Spacer(),
                  isShowAvatar
                      ? Row(
                          children: [
                            _buildAvatar(
                                'https://api.lishaoy.net/files/22/serve?size=medium',
                                '廖珠星'),
                            _buildAvatar(
                                'https://api.lishaoy.net/files/169/serve?size=thumbnail',
                                '康听白'),
                            _buildAvatar(
                                'https://api.lishaoy.net/files/258/serve?size=thumbnail',
                                '冯晓霞'),
                            Icon(
                              Icons.chevron_right,
                              size: 20.0,
                            ),
                          ],
                        )
                      : Container(),
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

  Container _buildAvatar(String imageUrl, String name) {
    return Container(
      padding: EdgeInsets.only(right: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: imageUrl,
                  fit: BoxFit.cover,
                  width: 22.0,
                  height: 22.0,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
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
