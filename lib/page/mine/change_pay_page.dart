/**
  @desc   修改支付密码
  @author hlx
 */
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class ChangePayPage extends StatefulWidget {
  @override
  _ChangePayPageState createState() => _ChangePayPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ChangePayPageState extends State<ChangePayPage> {
  TextEditingController _oldPwd = TextEditingController();
  TextEditingController _newPwd = TextEditingController();
  TextEditingController _confimPwd = TextEditingController();
  TextEditingController _sms = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).setPayPwd),
          elevation: 15.0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(S.of(context).plaseSetPayPsd),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        InputList(S.of(context).oldPayPwd,
                            S.of(context).placeOldPwd, _oldPwd),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).newPayPwd,
                            S.of(context).placeNewPwd, _newPwd),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).confimPayPwd,
                            S.of(context).placeConfimPwd, _confimPwd),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text(S.of(context).sumit),
                      onPressed: () => print("提交"),
                      color: HsgColors.accent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5) //设置圆角
                          ),
                    ),
                  )
                ],
              )),
        ));
  }
}

//封装一行
class InputList extends StatelessWidget {
  InputList(this.labText, this.placeholderText, this.inputValue,
      {this.isShow = false});
  final String labText;
  final String placeholderText;
  TextEditingController inputValue = TextEditingController();
  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.labText),
          Expanded(
            child: TextField(
              controller: this.inputValue,
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: true, //是否自动对焦
              obscureText: true, //是否是密码
              textAlign: TextAlign.right, //文本对齐方式
              onChanged: (text) {
                //内容改变的回调
                print('change $text');
              },
              onSubmitted: (text) {
                //内容提交(按回车)的回调
                print('submit $text');
              },
              enabled: true, //是否禁用
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.placeholderText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
          if (this.isShow)
            SizedBox(
              width: 90,
              height: 32,
              child: FlatButton(
                onPressed: () {},
                //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
                padding: EdgeInsets.symmetric(horizontal: 8),
                //文字颜色
                textColor: Colors.black12,
                //按钮颜色
                color: HsgColors.blueBGColor,
                //画圆角
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                //如果使用FlatButton，必须初始化onPressed这个方法
                // onPressed: () {
                //   widget.onPressed(_controller.text);
                // },
                child: Text(
                  '获取验证码',
                  style: TextStyle(fontSize: 14,color: HsgColors.blueTextColor),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}
