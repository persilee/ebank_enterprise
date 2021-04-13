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

///获取用户状态刷新
class ChangeLanguage {
  String language;

  ChangeLanguage({this.language});
}
