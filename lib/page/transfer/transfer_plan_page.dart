import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferPlanPage extends StatefulWidget {
  TransferPlanPage({Key key}) : super(key: key);

  @override
  _TransferPlanPage createState() => _TransferPlanPage();
}

class _TransferPlanPage extends State<TransferPlanPage> {
  bool btnOne = true;
  bool btnTwo = false;
  String groupValue = '0';

  List state = [
    {
      "title": '正在进行',
      "type": "0",
    },
    {
      "title": '已经结束',
      "type": "1",
    },
  ];

  //改变groupValue
  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }

  //文本样式
  Widget _textStyle(String text, Color textColor, double textSize) {
    return Text(
      text,
      style: TextStyle(color: textColor, fontSize: textSize),
    );
  }

  //按钮样式
  Widget _btnStyle(String btnTitle, String btnType, Color btnColor,
      Color textColor, BorderSide borderSide) {
    BorderRadius borderRadius;
    if (btnTitle == '正在进行') {
      borderRadius = BorderRadius.horizontal(left: Radius.circular(5));
    } else if (btnTitle == '已经结束') {
      borderRadius = BorderRadius.horizontal(right: Radius.circular(5));
    } else {
      borderRadius = BorderRadius.all(Radius.circular(50));
    }
    return FlatButton(
      color: btnColor,
      shape:
          RoundedRectangleBorder(side: borderSide, borderRadius: borderRadius),
      onPressed: () {
        updateGroupValue(btnType);
        print(btnTitle);
      },
      child: _textStyle(btnTitle, textColor, 14.0),
    );
  }

  //切换按钮
  Widget _toggleButton() {
    return SliverToBoxAdapter(
      child: Container(
        color: HsgColors.backgroundColor,
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: GridView.count(
          padding: EdgeInsets.only(left: 75, right: 75),
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1 / 0.25,
          children: state.map((value) {
            return groupValue == value['type']
                ? _btnStyle(value['title'], value['type'], HsgColors.primary,
                    HsgColors.aboutusText, BorderSide.none)
                : _btnStyle(value['title'], value['type'], Color(0xFFFFFFFF),
                    Color(0xFF8B8B8B), BorderSide(color: HsgColors.divider));
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.transfer_plan),
      ),
      body: CustomScrollView(slivers: <Widget>[
        _toggleButton(),
        SliverToBoxAdapter(
            child: _btnStyle(
                '取消', null, Colors.blue, Colors.white, BorderSide.none))
      ]),
    );
  }
}
