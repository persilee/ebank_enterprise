import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class LimitDetailsDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(S.of(context).limitDetails),
      )),
      body: ListView(
        children: [
          // 额度详情
            Container(
              margin: EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 46,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).contractAccount + " 0265898979",
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0, 
                    color: HsgColors.textHintColor,
                    indent: 20,
                    endIndent: 20,
                    ),
                  SizedBox(
                      height: 150,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).loanPrincipal,
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '88,888.88 HKD',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).loanBalance,
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '88,888.88 HKD',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).startTime,
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '2020-03-20',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).endTime,
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '2020-03-20',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).loanRate,
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '8.88%',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0x86FF0000)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
        ],
      ),
          
    );
  }


}
