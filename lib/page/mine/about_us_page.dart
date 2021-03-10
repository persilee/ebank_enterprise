/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 关于我们
/// Author: hlx
/// Date: 2020-11-25

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Loaderman'),
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
                    Container(
                      margin: EdgeInsets.only(top: 41.0, left: 24.0),
                      child: Text(
                        '全球银行业综合服务商',
                        style: TextStyle(
                          fontSize: 24,
                          color: HsgColors.aboutusText,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 86.0, left: 24.0, right: 59.0),
                      child: Text(
                        '专业提供银行IT系统产品、解决方案及全面的开发实施服务',
                        style: TextStyle(
                          fontSize: 14,
                          color: HsgColors.aboutusText,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      padding:
                          EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
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
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '企业介绍',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: HsgColors.aboutusTextCon,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '/ INTROTUCE',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: HsgColors.aboutusTextCon),
                                ),
                              ],
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
                              padding: EdgeInsets.only(top: 30, bottom: 42),
                              child: Text(
                                '高阳寰球是一家专注服务银行业的科技公司专业提供银行IT系统产品、解决方案及全面的开发实施服务。曾获金融行业最佳产品奖、案例遍布5大洲、获中国方案商百强荣誉称号。',
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
                            '我们的优势',
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
                            '企业优势',
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(
                            '有丰富的全球银行服务经验，熟悉全球法规、市场惯例和工作文化；100%项目实施成功率，在全球IT建设领域拥有丰富经验和良好口碑。',
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
                            '技术优势',
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(
                            '在金融及通讯领域拥有领先的技术实力，掌握领先的银行核心业务处理技术、成熟的电子银行处理技术、及完善的手机交易核心技术',
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
                            '团队优势',
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(
                            '我们拥有众多顶级的金融业务专家和技术专家，每位专家在细分的业务领域内都具有20年以上的经验积累',
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
                            '服务优势',
                            style: TextStyle(
                                fontSize: 17,
                                color: HsgColors.aboutusTextCon,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(
                            '为客户提供提供全面的银行系统产品和服务：顾问服务、系统规划、需求分析、产品设计与开发、项目实施、业务运营与维护',
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
                            '我们的价值',
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
                                Text(
                                  '即时响应式服务,全程为开发加速',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: HsgColors.aboutusTextCon,
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
                                Text(
                                  '强大团队 高效实施',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: HsgColors.aboutusTextCon,
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
                                Text(
                                  '灵活配置 可扩充可维护',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: HsgColors.aboutusTextCon,
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
                                Text(
                                  '7*24小时 技术支持',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: HsgColors.aboutusTextCon,
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
