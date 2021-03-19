import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

Widget getRegisterPhoneSms(BuildContext context, TextEditingController _sms) {
  return //获取验证码
      Container(
    height: MediaQuery.of(context).size.height / 15,
    margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xFFF5F7F9)),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          width: MediaQuery.of(context).size.width / 2,
          child: TextField(
            //是否自动更正
            controller: _sms,
            autocorrect: true,
            //是否自动获得焦点
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '输入验证码',
              hintStyle: TextStyle(
                fontSize: 15,
                color: HsgColors.textHintColor,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            //调用获取验证码接口
            // _getVerificationCode();
            print('获取验证码');
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            child: Text(
              '获取验证码',
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.right,
            ),
          ),
        )
      ],
    ),
  );
}
