import 'package:ebank_mobile/config/hsg_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialog Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FlatButton(
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
              child: Text('Normal')),
          FlatButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      var child = Column(
                        children: <Widget>[
                          ListTile(title: Text("请选择")),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 7,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text("$index"),
                                onTap: () => Navigator.of(context).pop(index),
                              );
                            },
                          ),
                        ],
                      );
                      //使用AlertDialog会报错
                      //return AlertDialog(content: child);
                      return Dialog(child: child);
                    });
                print('dialog result:$result');
              },
              child: Text('List')),
          RaisedButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return HsgAlertDialog(
                        title: "删除还款卡号",
                        message: _shortText,
                        positiveButton: '确定',
                        negativeButton: '取消',
                      );
                    });
                print('dialog result:$result');
              },
              child: Text('Alert Dialog')),
        ],
      ),
    );
  }
}

var _longText =
    "删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？删除后，将无法使用该卡号快速还款，您确定要删除吗？";

var _shortText = '删除后，将无法使用该卡号快速还款，您确定要删除吗？';
