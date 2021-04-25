import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/util/screen_util.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'iconfont.dart';

class HsgErrorPage extends StatelessWidget {
  final Widget icon;
  final String title;
  final String desc;
  final String buttonText;
  final VoidCallback buttonAction;
  final VoidCallback helpAction;
  final bool isEmptyPage;
  final bool isNeedLogin;
  final AppException error;

  HsgErrorPage({
    this.icon,
    this.title,
    this.desc,
    this.buttonText,
    this.buttonAction,
    this.helpAction,
    this.isEmptyPage = false,
    this.isNeedLogin = false,
    @required this.error,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool _isNeedLogin;
    if (this.error is NeedLogin) {
      _isNeedLogin = true;
    } else {
      _isNeedLogin = false;
    }
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: this.icon != null
                  ? this.icon
                  : !this.isEmptyPage
                      ? Lottie.asset(
                          'assets/json/error2.json',
                          width: size.width / 1.3,
                          height: 160,
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        )
                      : Image(
                          image: AssetImage(
                              'images/noDataIcon/no_data_record.png'),
                          width: 160,
                          fit: BoxFit.cover,
                        ),
            ),
            !this.isEmptyPage
                ? Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 12,
                    ),
                    child: Text(
                      this.title ?? this.error.code ??  S.current.error_title,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  this.isEmptyPage
                      ? S.current.no_data_now
                      : this.desc ?? this.error.message ?? S.current.error_desc,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                ),
                this.isEmptyPage || _isNeedLogin
                    ? Container()
                    : GestureDetector(
                        onTap: () => this.helpAction != null ? this.helpAction() : (){},
                        child: Icon(
                          IconFont.icon_info,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 126.0,
                child: CustomButton(
                  height: 36.0,
                  clickCallback: () {
                    if (_isNeedLogin) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return LoginPage();
                      }), (Route route) {
                        print(route.settings?.name);
                        if (route.settings?.name == "/") {
                          return true;
                        }
                        return false;
                      });
                    } else {
                      this.buttonAction();
                    }
                  },
                  text: Text(
                    this.buttonText ?? _isNeedLogin
                        ? S.current.login
                        : S.current.error_refresh,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
