import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_otp_button.dart';
import 'package:flutter/material.dart';

class HsgTipsDialog extends StatelessWidget {
  final Widget title;
  final Widget child;
  final VoidCallback confirmCallback;

  HsgTipsDialog({this.title, this.child, this.confirmCallback});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 0),
      title: Center(
        child: this.title ??
            Text(
              S.current.prompt,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
          child: Center(
            child: this.child ?? Text('this is content'),
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

class HsgTextFieldDialog extends StatelessWidget {
  final String areaCode;
  final String phoneNum;
  final TextEditingController editingController;
  final ValueChanged<String> onChanged;
  final VoidCallback confirmCallback;
  final VoidCallback sendCallback;

  const HsgTextFieldDialog(
      {Key key,
      this.areaCode,
      this.phoneNum,
      @required this.editingController,
      this.onChanged,
      this.confirmCallback,
      this.sendCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var field_dialog_confirm;
    String showPhone = this.phoneNum != null ? this.phoneNum : '';
    String showAreaCode = this.areaCode != null ? this.areaCode : '';
    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 0),
      title: Center(
        child: Text(
          S.current.field_dialog_title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: HsgColors.firstDegreeText,
          ),
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
                    showAreaCode + showPhone,
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
                    // HSGOTPButton(
                    //   'sendSms',
                    //   otpCallback: () {},
                    // )
                    TextButton(
                        onPressed: this.sendCallback,
                        child: Text(
                          S.current.field_dialog_send,
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                          ),
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
