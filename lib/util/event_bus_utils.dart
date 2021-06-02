import 'package:ebank_mobile/data/source/model/account/get_user_info.dart';
import 'package:event_bus/event_bus.dart';

///event bus
class EventBusUtils {
  static EventBus _eventBus;

  static EventBus getInstance() {
    if (_eventBus == null) {
      _eventBus = EventBus();
    }
    return _eventBus;
  }
}

///获取用户状态刷新
class GetUserEvent {
  String msg;
  int state;

  GetUserEvent({this.msg, this.state});
}

///通知修改头像 state == 100 首页头像刷新 state == 200 我的页面头像刷新 state == 300 全部头像刷新
class ChangeHeadPortraitEvent {
  String headPortrait;
  int state;

  ChangeHeadPortraitEvent({this.headPortrait, this.state});
}

///通知国际化刷新 state == 100 首页刷新 state == 200 我的页面刷新 state == 300 首页和我的刷新

class ChangeLanguage {
  String language;
  int state;

  ChangeLanguage({this.language, this.state});
}

class ChangeUserInfo {
  UserInfoResp userInfo;
  int state;

  ChangeUserInfo({this.userInfo, this.state});
}

///更新定期列表
class UpdateTDRecordEvent {
  String msg;

  UpdateTDRecordEvent({this.msg});
}
