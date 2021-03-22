import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCustomerPage extends StatefulWidget {
  @override
  _ContactCustomerPageState createState() => _ContactCustomerPageState();
}

class _ContactCustomerPageState extends State<ContactCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login/login_bg_biological.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(S.current.customer_service),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10, top: 55),
                child: _getTitleColumn(),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 90),
                    padding: EdgeInsets.only(left: 30, right: 30),
                    width: double.infinity,
                    height: 223,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: _getPhoneColumn(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 55),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Image.asset(
                        'images/login/login_header_logo.png',
                        height: 40,
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _getPhoneColumn() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 65, bottom: 30),
          child: PhoneButton(
            icon: 'images/home/navIcon/home_nav_service.png',
            phone: '+86-755-8325-8862',
          ),
        ),
        Container(
          child: PhoneButton(
            icon: 'images/home/navIcon/home_nav_phone.png',
            phone: '+86-159-8985-1575',
          ),
        ),
      ],
    );
  }

  Column _getTitleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.hello,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
          strutStyle:
              StrutStyle(forceStrutHeight: true, height: 1.6, leading: 1.6),
        ),
        Text(
          S.current.serve_you,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
          strutStyle:
              StrutStyle(forceStrutHeight: true, height: 1.6, leading: 1.6),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class PhoneButton extends StatelessWidget {
  final String icon;
  final String phone;
  String phoneNum;

  PhoneButton({Key key, this.icon, this.phone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE8EDFF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: FlatButton(
        onPressed: () {
          _clickPhoneBotton(context);
        },
        color: Color(0xFFE8EDFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        splashColor: Color(0xFFD9E1FC),
        highlightColor: Color(0xFFD9E1FC),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Image(
                height: 25.0,
                width: 25.0,
                color: Color(0xFF4871FF),
                image: AssetImage(icon),
              ),
            ),
            Text(
              phone,
              style: TextStyle(
                color: Color(0xFF4871FF),
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _clickPhoneBotton(BuildContext context) async {
    if (phone == '+86-755-8325-8862') {
      phoneNum = '+86 (755) 8325 8862';
    } else {
      phoneNum = '+86 159 8985 1575';
    }
    showHsgBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PhoneBottomSheet(
          phone: phoneNum,
        );
      },
    );
  }
}

class PhoneBottomSheet extends StatelessWidget {
  final String phone;

  const PhoneBottomSheet({Key key, this.phone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: _callFlatButton(),
          ),
          Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: _cancelFlatButton(context),
          ),
        ],
      ),
    );
  }

  FlatButton _callFlatButton() {
    return FlatButton(
      onPressed: () => launch('tel://' + phone),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.call,
            color: Colors.black54,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              S.current.call + ' ' + phone,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF4871FF),
              ),
            ),
          )
        ],
      ),
    );
  }

  FlatButton _cancelFlatButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      minWidth: double.infinity,
      height: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        S.current.cancel,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4871FF)),
      ),
    );
  }
}
