/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-11-30

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

const ShapeBorder _dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

/// 提示对话框
class HsgAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButton;
  final String negativeButton;

  const HsgAlertDialog({
    Key key,
    this.title,
    this.message,
    this.positiveButton,
    this.negativeButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null) {
      titleWidget = _titleWidget(title);
    }

    if (message != null) {
      final EdgeInsets contentPadding = EdgeInsets.fromLTRB(20, 0, 20, 20);
      contentWidget = Padding(
        padding: contentPadding,
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      );
    }

    var hasActions = false;
    if (positiveButton != null || negativeButton != null) {
      hasActions = true;
      actionsWidget = _actionsWidget(
        positiveButton,
        negativeButton,
        context,
        () {
          Navigator.of(context).pop(true);
        },
      );
    }

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (message != null)
        Flexible(
          child: SingleChildScrollView(
            child: contentWidget,
          ),
        ),
      if (hasActions)
        Divider(
          height: 1,
        ),
      if (hasActions) actionsWidget,
    ];

    final dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );

    return Dialog(
      child: dialogChild,
      shape: _dialogShape,
    );
  }
}

Widget _titleWidget(
  String title, {
  EdgeInsets titlePadding = const EdgeInsets.all(20.0),
  TextStyle style = const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
}) {
  return Padding(
    padding: titlePadding,
    child: Center(
      child: Text(
        title,
        style: style,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _actionsWidget(String positiveButton, String negativeButton,
    BuildContext context, Function positiveClick) {
  final hasPositiveButton = positiveButton != null;
  final hasNegativeButton = negativeButton != null;
  final actionsButton = [
    if (hasNegativeButton)
      Expanded(
        child: FlatButton(
          height: 48,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            negativeButton,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    if (hasPositiveButton)
      Expanded(
        child: FlatButton(
          height: 48,
          onPressed: positiveClick,
          child: Text(
            positiveButton,
            style: TextStyle(fontSize: 16, color: HsgColors.accent),
          ),
        ),
      ),
  ];

  return Padding(
    padding: EdgeInsets.only(bottom: 1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actionsButton,
    ),
  );
}

var _selectedPosition = -1;

/// 单选对话框
class HsgSingleChoiceDialog extends StatelessWidget {
  final String title;
  final List<String> items;
  final String positiveButton;
  final String negativeButton;
  final lastSelectedPosition;

  HsgSingleChoiceDialog({
    Key key,
    this.title,
    this.items,
    this.positiveButton,
    this.negativeButton,
    this.lastSelectedPosition = -1,
  }) : super(key: key) {
    // 上次选中的位置由调用者保存
    _selectedPosition = -1;
    if (lastSelectedPosition != -1) {
      _selectedPosition = lastSelectedPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null) {
      titleWidget = _titleWidget(title);
    }

    if (items != null && items.length > 0) {
      final EdgeInsets contentPadding = EdgeInsets.fromLTRB(0, 0, 0, 20);
      contentWidget = Padding(
        padding: contentPadding,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int position) {
            return _getItemRow(position, context, _selectedPosition);
          },
        ),
      );
    }

    var hasActions = false;
    if (positiveButton != null || negativeButton != null) {
      hasActions = true;
      actionsWidget = _actionsWidget(
        positiveButton,
        negativeButton,
        context,
        () {
          if (items.length > 0) {
            Navigator.of(context).pop(_selectedPosition);
          } else {
            Navigator.pop(context);
          }
        },
      );
    }

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (items != null && items.length > 0)
        Flexible(
          child: contentWidget,
        ),
      if (hasActions)
        Divider(
          height: 1,
        ),
      if (hasActions) actionsWidget,
    ];

    final dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    return Dialog(
      child: dialogChild,
      shape: _dialogShape,
    );
  }

  Widget _getItemRow(int position, BuildContext context, int selectedPosition) {
    List<Widget> rowChildren = [
      Expanded(
        child: Text(
          items[position],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Image.asset(
          position == selectedPosition
              ? 'images/common/check_btn_common_checked.png'
              : 'images/common/check_btn_common_no_check.png',
          height: 18,
          width: 18,
        ),
      ),
    ];
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(45, 13, 48, 13),
        child: Row(
          children: rowChildren,
        ),
      ),
      onTap: () {
        _selectedPosition = position;
        (context as Element).markNeedsBuild();
      },
    );
  }
}

/// 底部单选弹窗
class BottomMenu extends StatelessWidget {
  final String title;
  final List<String> items;
  const BottomMenu({Key key, this.title, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null) {
      titleWidget = _titleWidget(
        title,
        titlePadding: EdgeInsets.all(15),
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: HsgColors.describeText,
          fontSize: 13,
        ),
      );
    }

    if (items != null && items.length > 0) {
      final EdgeInsets contentPadding = EdgeInsets.zero;
      contentWidget = Padding(
        padding: contentPadding,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int position) {
            return _getItemRow(position, context);
          },
          separatorBuilder: (context, index) => Divider(
            height: 1,
          ),
        ),
      );
    }

    final actionChildren = [
      Expanded(
        child: FlatButton(
          height: 55,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 13, top: 10),
            child: Text(
              S.current.cancel,
              style: TextStyle(
                fontSize: 16,
                color: HsgColors.secondDegreeText,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ];

    actionsWidget = Row(
      children: actionChildren,
    );

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (title != null && items != null)
        Divider(
          height: 1,
        ),
      if (items != null && items.length > 0)
        Flexible(
          child: contentWidget,
        ),
      Divider(
        color: HsgColors.commonBackground,
        thickness: 7,
        height: 7,
      ),
      actionsWidget,
    ];

    final menuBody = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    return Ink(
      child: menuBody,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  Widget _getItemRow(int position, BuildContext context) {
    return InkWell(
      splashColor: HsgColors.itemClickColor,
      child: Padding(
        padding: EdgeInsets.only(top: 18, bottom: 18, left: 16, right: 16),
        child: Center(
          child: Text(
            items[position],
            style: TextStyle(fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pop(position),
    );
  }
}

//账户单选底部圆角弹窗
class HsgBottomSingleChoice extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> icons;
  final lastSelectedPosition;

  HsgBottomSingleChoice({
    Key key,
    this.title,
    this.items,
    this.icons,
    this.lastSelectedPosition = -1,
  });

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null) {
      titleWidget = _titleWidget(
        title,
        titlePadding: EdgeInsets.all(15),
        style: TextStyle(
          fontWeight: FontWeight.normal,
          // color: HsgColors.describeText,
          // fontSize: 16,
        ),
      );
    }

    if (items != null && items.length > 0) {
      final EdgeInsets contentPadding = EdgeInsets.fromLTRB(0, 0, 0, 20);
      contentWidget = Padding(
        padding: contentPadding,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int position) {
            return _getItemRow(position, context, lastSelectedPosition);
          },
        ),
      );
    }
    //取消按钮
    final actionChildren = [
      Expanded(
        child: FlatButton(
          height: 55,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 13, top: 10),
            child: Text(
              S.current.cancel,
              style: TextStyle(
                // fontSize: 16,
                color: HsgColors.secondDegreeText,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ];

    actionsWidget = Row(
      children: actionChildren,
    );

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      // if (title != null && items != null)
      //   Divider(
      //     height: 1,
      //   ),
      if (items != null && items.length > 0)
        Flexible(
          child: contentWidget,
        ),
      Divider(
        color: HsgColors.commonBackground,
        thickness: 7,
        height: 7,
      ),
      actionsWidget,
    ];

    final dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    return Ink(
      child: dialogChild,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  //图片剪裁
  Widget _getItemRow(int position, BuildContext context, int selectedPosition) {
    List<Widget> rowChildren = [
      Container(
        padding: EdgeInsets.only(right: 20),
        child: ClipOval(
          child: icons != null && icons.length > 0
              ? Image.network(
                  icons[position],
                  height: 23,
                  width: 23,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'images/home/listIcon/home_list_card_bank.png',
                  height: 23,
                  width: 23,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      Expanded(
        child: Text(
          items[position],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Image.asset(
          position == selectedPosition
              ? 'images/common/check_btn_common_checked.png'
              : 'images/common/check_btn_common_no_check.png',
          height: 18,
          width: 18,
        ),
      ),
    ];
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 13, 35, 13),
        child: Row(
          children: rowChildren,
        ),
      ),
      onTap: () {
        _selectedPosition = position;
        (context as Element).markNeedsBuild();
        Navigator.of(context).pop(position);
      },
    );
  }
}

//底部银行卡弹窗
class HsgBottomCardChoice extends StatelessWidget {
  final String title;
  final List<String> items;
  final lastSelectedPosition;
  final List<String> imageUrl;

  HsgBottomCardChoice({
    Key key,
    this.title,
    this.items,
    this.lastSelectedPosition = -1,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null) {
      titleWidget = _titleWidget(
        title,
        titlePadding: EdgeInsets.all(15),
        style: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      );
    }

    if (items != null && items.length > 0) {
      final EdgeInsets contentPadding = EdgeInsets.fromLTRB(0, 0, 0, 20);
      contentWidget = Padding(
        padding: contentPadding,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int position) {
            return _getItemRow(
                position, context, lastSelectedPosition, imageUrl);
          },
        ),
      );
    }

    final actionChildren = [
      Expanded(
        child: FlatButton(
          height: 55,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 13, top: 10),
            child: Text(
              S.current.cancel,
              style: TextStyle(
                // fontSize: 16,
                color: HsgColors.secondDegreeText,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ];

    actionsWidget = Row(
      children: actionChildren,
    );

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (items != null && items.length > 0)
        Flexible(
          child: contentWidget,
        ),
      Divider(
        color: HsgColors.commonBackground,
        thickness: 7,
        height: 7,
      ),
      actionsWidget,
    ];

    final dialogChild = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );

    return Ink(
      child: dialogChild,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );
  }

  Widget _getItemRow(int position, BuildContext context, int selectedPosition,
      List<String> imageUrl) {
    List<Widget> rowChildren = [
      Container(
        padding: EdgeInsets.only(right: 20),
        child: ClipOval(
          child: position == 0
              ? Image.asset(
                  imageUrl[0],
                  height: 23,
                  width: 23,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  imageUrl[position],
                  height: 23,
                  width: 23,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      Expanded(
        child: Text(
          items[position],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Image.asset(
          position == selectedPosition
              ? 'images/common/check_btn_common_checked.png'
              : 'images/common/check_btn_common_no_check.png',
          height: 18,
          width: 18,
        ),
      ),
    ];
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 13, 35, 13),
        child: Row(
          children: rowChildren,
        ),
      ),
      onTap: () {
        _selectedPosition = position;
        (context as Element).markNeedsBuild();
        Navigator.of(context).pop(position);
      },
    );
  }
}

/// 显示设定圆角的底部对话框，需要和内部widget配合使用，内部也需要设置相同圆角，如：BottomMenu
Future<T> showHsgBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  Color backgroundColor,
  double elevation,
  ShapeBorder shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    ),
  ),
  Clip clipBehavior,
  Color barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings routeSettings,
}) =>
    showModalBottomSheet(
        context: context,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        barrierColor: barrierColor,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        routeSettings: routeSettings);
