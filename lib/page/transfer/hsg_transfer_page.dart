import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  TransferPage({Key key}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('转账功能'),
      ),
      body: Container(
        // color: Colors.white,
        child: CustomScrollView(
          slivers: _sliversSection(_features),
        ),
      ),
    );
  }

  List<Widget> _sliversSection(List data) {
    List<Widget> section = [];
    section.add(SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            color: HsgColors.primary,
            height: 110,
            child: _graphicButton(
              data[index]['btnTitle'],
              data[index]['btnIcon'],
              35,
              () {
                print('${data[index]['btnTitle']}');
                String title = data[index]['btnTitle'];
                if ('行内转账' == title) {
                  //行内转账
                  Navigator.pushNamed(context, pageTransfer);
                } else if (S.of(context).transfer_appointment == title) {
                  //'预约转账'
                } else if (S.current.transfer_record == title) {
                  //转账记录
                }
              },
            ),
          );
        },
        childCount: data.length,
      ),
    ));

    section.add(SliverToBoxAdapter(
      child: Container(
        color: HsgColors.commonBackground,
        height: 20,
      ),
    ));

    return section;
  }

  ///上图下文字的按钮
  Widget _graphicButton(
      String title, String iconName, double iconWidth, VoidCallback onClick) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.only(left: 2, right: 2),
        onPressed: onClick,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Image(
                image: AssetImage(iconName),
                width: iconWidth,
                height: iconWidth,
              ),
            ),
            Container(
              height: 8.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HsgColors.describeText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, Object>> _features = [
    {
      'btnIcon': 'images/home/listIcon/home_list_transfer.png',
      'btnTitle': S.current.transfer
    },
    {
      'btnIcon': 'images/home/listIcon/home_list_transfer_appointment.png',
      'btnTitle': S.current.transfer_appointment
    },
    {
      'btnIcon': 'images/home/listIcon/home_list_transfer_plan.png',
      'btnTitle': S.current.transfer_plan
    },
  ];
}
