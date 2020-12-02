import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

const ShapeBorder _dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

/// 这是一个提示对话框
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
        child: Text(message),
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

Widget _titleWidget(String title) {
  final EdgeInsets defaultTitlePadding =
      EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0);
  return Padding(
    padding: defaultTitlePadding,
    child: Center(
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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

/// 这是一个单选对话框
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
    // 上次选中的由调用者保存
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
          Navigator.of(context).pop(_selectedPosition);
        },
      );
    }

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (items != null)
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
