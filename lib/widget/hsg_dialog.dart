import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class HsgAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButton;
  final String negativeButton;

  const HsgAlertDialog(
      {Key key,
      this.title,
      this.message,
      this.positiveButton,
      this.negativeButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    Widget contentWidget;
    Widget actionsWidget;
    if (title != null) {
      final EdgeInsets defaultTitlePadding =
          EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0);
      titleWidget = Padding(
        padding: defaultTitlePadding,
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          textAlign: TextAlign.center,
        )),
      );
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
      actionsWidget = Padding(
        padding: EdgeInsets.only(bottom: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (negativeButton != null)
              FlatButton(
                  minWidth: 140,
                  height: 48,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    negativeButton,
                    style: TextStyle(fontSize: 16),
                  )),
            if (positiveButton != null)
              FlatButton(
                  minWidth: 140,
                  height: 48,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    positiveButton,
                    style: TextStyle(fontSize: 16, color: HsgColors.accent),
                  )),
          ],
        ),
      );
    }

    List<Widget> columnChildren = <Widget>[
      if (title != null) titleWidget,
      if (message != null)
        Flexible(
            child: SingleChildScrollView(
          child: contentWidget,
        )),
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

    return Dialog(child: dialogChild);
  }
}
