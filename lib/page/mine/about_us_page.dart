/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 关于我们
/// Author: hlx
/// Date: 2020-11-25

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.current.aboutUs),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            color: Colors.white,
            child: new ListView(children: [
              //企业介绍
              SizedBox(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.cyan,
                      child: Image(
                        image: AssetImage('images/mine/aboutUs-bg.png'),
                        width: MediaQuery.of(context).size.width,
                        //height: 196.0,
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 20.0, left: 24.0),
                          child: Text(
                            S.current.about_us_title,
                            style: TextStyle(
                              fontSize: 24,
                              color: HsgColors.aboutusText,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 15.0, left: 24.0, right: 59.0),
                          child: Text(
                            S.current.about_us_subhead,
                            style: TextStyle(
                              fontSize: 14,
                              color: HsgColors.aboutusText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 150.0, left: 15.0, right: 15.0),
                      padding:
                          EdgeInsets.only(top: 15.0, left: 9.0, right: 9.0),
                      decoration: new BoxDecoration(
                          //背景颜色
                          color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                                blurRadius: 15.0, //阴影模糊程度
                                spreadRadius: 1.0 //阴影扩散程度
                                )
                          ]),
                      child: SizedBox(
                          child: Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    S.current.company_introduction,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: HsgColors.aboutusTextCon,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '/ INTROTUCE',
                                      overflow: TextOverflow.values[1],
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: HsgColors.aboutusTextCon),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Image(
                                  height: 10.0,
                                  width: 53.0,
                                  image:
                                      AssetImage('images/mine/aboutUs-bg1.png'),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 32),
                              child: Text(
                                S.current.company_introduction_content,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: HsgColors.aboutusTextCon),
                              ),
                            )
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              //我们的优势
              Container(
                margin: EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
                padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                decoration: new BoxDecoration(
                    //背景颜色
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            S.current.our_advantage,
                            style: TextStyle(
                                fontSize: 20,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '/ ADVANTAGE',
                            style: TextStyle(
                                fontSize: 12, color: HsgColors.aboutusTextCon),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image(
                            height: 10.0,
                            width: 53.0,
                            image: AssetImage('images/mine/aboutUs-bg1.png'),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
              ),
              //企业优势
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                decoration: new BoxDecoration(
                    //背景颜色
                    color: HsgColors.aboutusConTxtBg,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 4.0,
                              backgroundColor: HsgColors.aboutusCircle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text(
                            S.current.inputprise_strength,
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(S.current.inputprise_strength_content,
                            style: TextStyle(
                                fontSize: 14, color: HsgColors.aboutusTextCon)),
                      )
                    ],
                  ),
                )),
              ),
              //技术优势
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 4.0,
                              backgroundColor: HsgColors.aboutusCircle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text(
                            S.current.technical_strength,
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(S.current.technical_strength_content,
                            style: TextStyle(
                                fontSize: 14, color: HsgColors.aboutusTextCon)),
                      )
                    ],
                  ),
                )),
              ),
              //团队优势
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                decoration: new BoxDecoration(
                    //背景颜色
                    color: HsgColors.aboutusConTxtBg,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 4.0,
                              backgroundColor: HsgColors.aboutusCircle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text(
                            S.current.team_strength,
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(S.current.team_strength_content,
                            style: TextStyle(
                                fontSize: 14, color: HsgColors.aboutusTextCon)),
                      )
                    ],
                  ),
                )),
              ),
              //服务优势
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 4.0,
                              backgroundColor: HsgColors.aboutusCircle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text(
                            S.current.service_strength,
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(S.current.service_strength_content,
                            style: TextStyle(
                                fontSize: 14, color: HsgColors.aboutusTextCon)),
                      )
                    ],
                  ),
                )),
              ),
              //我们的价值
              Container(
                margin: EdgeInsets.only(
                    top: 20.0, left: 15.0, right: 15.0, bottom: 20.0),
                padding: EdgeInsets.only(top: 25.0, left: 10.0, right: 10.0),
                decoration: new BoxDecoration(
                    //背景颜色
                    color: Colors.white,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: SizedBox(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 40.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            S.current.our_value,
                            style: TextStyle(
                                fontSize: 20,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '/ value',
                            style: TextStyle(
                                fontSize: 12, color: HsgColors.aboutusTextCon),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image(
                            height: 10.0,
                            width: 53.0,
                            image: AssetImage('images/mine/aboutUs-bg1.png'),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'images/mine/aboutUs-icon1.png'),
                                    width: 22.0),
                                Container(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Text(
                                    S.current.our_value_content1,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HsgColors.aboutusTextCon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 50, color: HsgColors.textHintColor),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'images/mine/aboutUs-icon2.png'),
                                    width: 22.0),
                                Container(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Text(
                                    S.current.our_value_content2,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HsgColors.aboutusTextCon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 50, color: HsgColors.textHintColor),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'images/mine/aboutUs-icon3.png'),
                                    width: 22.0),
                                Container(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Text(
                                    S.current.our_value_content3,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HsgColors.aboutusTextCon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 50, color: HsgColors.textHintColor),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'images/mine/aboutUs-icon4.png'),
                                    width: 22.0),
                                Container(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Text(
                                    S.current.our_value_content4,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HsgColors.aboutusTextCon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 50, color: HsgColors.textHintColor)
                        ],
                      )
                    ],
                  ),
                )),
              ),
            ])));
  }
}
