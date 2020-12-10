import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

class DialogDemoPage extends StatefulWidget {
  DialogDemoPage({Key key}) : super(key: key);

  @override
  _DialogDemoPageState createState() => _DialogDemoPageState();
}

class _DialogDemoPageState extends State<DialogDemoPage> {
  @override
  Widget build(BuildContext context) {
    int _lastSelectedPosition = -1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dialog Demo'),
      ),
      body: ListView(
        children: [
          RaisedButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("提示"),
                          content: Text("删除后，将无法使用该卡号快速还款，您确定要删除吗？"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("取消"),
                              onPressed: () =>
                                  Navigator.of(context).pop(), // 关闭对话框
                            ),
                            FlatButton(
                              child: Text("删除"),
                              onPressed: () {
                                //关闭对话框并返回true
                                Navigator.of(context).pop('删除');
                              },
                            ),
                          ]);
                    });
                print('dialog result:$result');
              },
              child: Text('系统提示框')),
          RaisedButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      var child = Column(
                        children: <Widget>[
                          ListTile(title: Text("请选择")),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text("$index"),
                                  onTap: () => Navigator.of(context).pop(index),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                      //使用AlertDialog会报错
                      //return AlertDialog(content: child);
                      return Dialog(child: child);
                    });
                print('dialog result:$result');
              },
              child: Text('系统列表')),
          RaisedButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return HsgAlertDialog(
                        title: "删除还款卡号",
                        message: _longText,
                        positiveButton: '确定',
                        negativeButton: '取消',
                      );
                    });
                // 提示信息对话框可能返回三种结果：null(点击对话框外部或者返回按钮)、
                // true（点击确定）和false（点击取消）
                print('dialog result:$result');
              },
              child: Text('Alert Dialog')),
          RaisedButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return HsgSingleChoiceDialog(
                        title: "币种选择",
                        items: _longItems,
                        positiveButton: '确定',
                        negativeButton: '取消',
                        lastSelectedPosition: _lastSelectedPosition,
                      );
                    });
                print('dialog result:$result');
                if (result != null && result != false) {
                  _lastSelectedPosition = result;
                }
              },
              // 单选对话框可能返回三种结果：null(点击对话框外部或者返回按钮)、
              // 选中项的index（点击确定）和false（点击取消）
              child: Text('Single Choice Dialog')),
          RaisedButton(
              onPressed: () async {
                final result = await showHsgBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomMenu(
                      title: '底部弹窗',
                      items: _longItems,
                    );
                  },
                );
                // 底部弹出菜单对话框可能返回三种结果：null(点击对话框外部或者返回按钮)、
                // 选中项的index（点击确定）和false（点击取消）
                print('dialog result:$result');
                if (result != null && result != false) {
                  _lastSelectedPosition = result;
                }
              },
              child: Text('Bottom sheet list')),
        ],
      ),
    );
  }
}

var _longText =
    "删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？";

var _shortText = '删除后，将无法使用该卡号快速还款，您确定要删除吗？';

var _shortItems = [
  '1',
  '2',
  '3',
];

var _longItems = [
  '123456789876543212345678987654321123456789876543212345678987654321',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
];
