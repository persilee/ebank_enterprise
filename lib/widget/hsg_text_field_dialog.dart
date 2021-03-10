import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

class HsgTextFieldDialog extends StatelessWidget {
  final String phoneNum;
  final TextEditingController editingController;
  final ValueChanged<String> onChanged;
  final VoidCallback confirmCallback;
  final VoidCallback sendCallback;

  const HsgTextFieldDialog(
      {Key key,
      this.phoneNum = '134****2356',
      @required this.editingController,
      this.onChanged,
      this.confirmCallback,
      this.sendCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var field_dialog_confirm;
    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 0),
      title: Center(
        child: Text(
          S.current.field_dialog_title,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Row(
                children: [
                  Text(
                    S.current.field_dialog_phone_number,
                    style: TextStyle(fontSize: 14.0, color: Colors.black38),
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    this.phoneNum,
                    style: TextStyle(fontSize: 14.0, color: Colors.black38),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.6), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: this.editingController,
                        onChanged: this.onChanged,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300,
                        ),
                        //输入文本的样式
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          border: InputBorder.none,
                          hintText: S.current.field_dialog_hint_text,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 14),
                    ),
                    TextButton(
                        onPressed: this.sendCallback,
                        child: Text(
                          S.current.field_dialog_send,
                          style: TextStyle(color: Colors.blueAccent),
                        ))
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 26)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey.withOpacity(0.3), width: 1.0)),
          ),
          child: Row(
            children: [
              Expanded(
                  child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.current.field_dialog_cancel,
                  style: TextStyle(fontSize: 14.0, color: Colors.black38),
                ),
              )),
              Expanded(
                  child: TextButton(
                onPressed: this.confirmCallback,
                child: Text(
                  S.current.field_dialog_confirm,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blueAccent,
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
