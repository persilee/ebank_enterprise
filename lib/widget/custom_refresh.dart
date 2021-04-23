import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'over_scroll_behavior.dart';

class CustomRefresh extends StatelessWidget {
  final RefreshController controller;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final Widget content;

  const CustomRefresh(
      {Key key,
      this.controller,
      this.onRefresh,
      this.onLoading,
      this.content,
      Column child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration.copyAncestor(
      context: context,
      child: RefreshConfiguration.copyAncestor(
        context: context,
        child: ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: SmartRefresher(
            controller: this.controller,
            enablePullDown: true,
            enablePullUp: true,
            header: CustomHeader(
              builder: (BuildContext context, RefreshStatus mode) {
                Widget body;
                if (mode == RefreshStatus.canRefresh) {
                  body = textIndicator(S.current.refresh_loosen_refresh);
                } else if (mode == RefreshStatus.refreshing) {
                  body = textIndicator(S.current.refresh_loading);
                } else if (mode == RefreshStatus.idle) {
                  body = textIndicator(S.current.refresh_drop_down_refresh);
                } else if (mode == RefreshStatus.completed) {
                  body = textIndicator(S.current.refresh_load_success);
                }
                return Container(
                  padding: EdgeInsets.only(top: 6, bottom: 12),
                  height: 86,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: body),
                    ],
                  ),
                );
              },
            ),
            footer: CustomFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Row(
                    children: [
                      Text(S.current.refresh_pull_loading,
                          style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    ],
                  );
                } else if (mode == LoadStatus.loading) {
                  body = Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                            strokeWidth: 1.6,
                          ),
                          width: 16,
                          height: 16,
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(S.current.refresh_loading,
                            style: TextStyle(fontSize: 12), textAlign: TextAlign.center,)
                      ],
                    ),
                  );
                } else if (mode == LoadStatus.failed) {
                  body = Text(S.current.refresh_failed_retry,
                      style: TextStyle(fontSize: 12), textAlign: TextAlign.center,);
                } else if (mode == LoadStatus.canLoading) {
                  body = Text(S.current.refresh_load_more,
                      style: TextStyle(fontSize: 12), textAlign: TextAlign.center,);
                } else {
                  body = Text(S.current.refresh_no_more_data,
                      style: TextStyle(fontSize: 12), textAlign: TextAlign.center,);
                }
                return Container(
                  height: 55.0,
                  width: ScreenUtil.instance.width,
                  child: Center(child: body),
                );
              },
            ),
            onRefresh: this.onRefresh,
            onLoading: this.onLoading,
            child: this.content,
          ),
        ),
        enableLoadingWhenFailed: true,
        maxUnderScrollExtent: 100.0,
        footerTriggerDistance: -45.0,
      ),
      enableLoadingWhenFailed: true,
      footerTriggerDistance: -60.0,
    );
  }

  Widget textIndicator(String statusStr) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/json/loading2.json',
              width: 96,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: Text(
              statusStr,
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
