import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';

import '../../../page_route.dart';

Widget _getRegisterButton(
    BuildContext context, Function _submit, TextEditingController _userName) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(bottom: 16),
    color: Colors.white,
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0xFFF5F7F9)),
          margin: EdgeInsets.only(top: 75),
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 15,
          child: RaisedButton(
            color: Colors.blue,
            child: Text(
              S.current.next_step,
              style: (TextStyle(
                color: Colors.white,
                fontSize: 15,
              )),
              //textDirection: Colors.white,
            ),
            onPressed: _submit()
                ? () {
                    RegExp userName = new RegExp("[a-zA-Z0-9]{4,16}");
                    //特殊字符
                    RegExp characters = new RegExp(
                        "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
                    if (userName.hasMatch(_userName.text) == false ||
                        characters.hasMatch(_userName.text) == true) {
                      HSProgressHUD.showToastTip(
                          '用户名只能为4-16位字符、数字或者字母，不能包含特殊字符，不能重复');
                    } else {
                      Navigator.pushNamed(context, pageRegisterConfirm);
                    }
                  }
                : null,
          ),
        )
      ],
    ),
  );
}
