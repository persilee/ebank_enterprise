import 'package:flutter/cupertino.dart';

class TransferWidget extends InheritedWidget {
  TransferWidget({@required this.data, Widget child}) : super(child: child);

  final Map data; //需要共享的数据

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static TransferWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TransferWidget>();
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(TransferWidget old) {
    //如果返回true，则子树中依赖(build函数中有调用)本widget
    //的子widget的`state.didChangeDependencies`会被调用
    return old.data != data;
  }
}
