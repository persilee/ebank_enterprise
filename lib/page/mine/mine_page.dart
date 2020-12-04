import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

/**
  @desc   个人中心
  @author hlx
 */
class MineqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).mine,
        ),
      ),
      body: ListView(
        children:[
          Container(
            color: HsgColors.primary,
            child: Row(
              children: [
                Column(
                  children: [
                    Text("q"),
                    Text("2")
                  ],
                )
              ],
            )
          )
        ]
      
      ),
    );
  }
}
