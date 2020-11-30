/**
  @desc   关于我们
  @author hlx
 */
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Loaderman'),
          elevation: 15.0,
        ),
        body: new ListView(children: [
          SizedBox(
            height: 370,
            child: Stack(
              children: [
                Container(
                  color: Colors.cyan,
                  child: Image(
                    image: AssetImage('images/aboutus/aboutUs-bg.png'),
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
                  margin: EdgeInsets.only(top: 86.0, left: 24.0, right: 59.0),
                  child: Text(
                    '专业提供银行IT系统产品、解决方案及全面的开发实施服务',
                    style: TextStyle(
                      fontSize: 14,
                      color: HsgColors.aboutusText,
                    ),
                  ),
                ),
                Container(
                  height: 218.0,
                  margin: EdgeInsets.only(top: 146.0, left: 21.0, right: 21.0),
                  padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                  decoration: new BoxDecoration(
                      //背景颜色
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: SizedBox(
                      height: 125,
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
                                  image: AssetImage(
                                      'images/aboutus/aboutUs-bg1.png'),
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
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
            Container(
                  height: 218.0,
                  margin: EdgeInsets.only(top: 30.0, left: 21.0, right: 21.0),
                  padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                  decoration: new BoxDecoration(
                      //背景颜色
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: SizedBox(
                      height: 125,
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
                                  image: AssetImage(
                                      'images/aboutus/aboutUs-bg1.png'),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 42),
                              child: Text(
                                '有丰富的全球银行服务经验，熟悉全球法规、市场惯例和工作文化；100%项目实施成功率，在全球IT建设领域拥有丰富经验和良好口碑。',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: HsgColors.aboutusTextCon),
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                   Container(
                  height: 218.0,
                  margin: EdgeInsets.only(top: 30.0, left: 21.0, right: 21.0),
                  padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                  decoration: new BoxDecoration(
                      //背景颜色
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: SizedBox(
                      height: 125,
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
                                  image: AssetImage(
                                      'images/aboutus/aboutUs-bg1.png'),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 42),
                              child: Text(
                                '有丰富的全球银行服务经验，熟悉全球法规、市场惯例和工作文化；100%项目实施成功率，在全球IT建设领域拥有丰富经验和良好口碑。',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: HsgColors.aboutusTextCon),
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                   Container(
                  height: 218.0,
                  margin: EdgeInsets.only(top: 30.0, left: 21.0, right: 21.0),
                  padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                  decoration: new BoxDecoration(
                      //背景颜色
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: SizedBox(
                      height: 125,
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
                                  image: AssetImage(
                                      'images/aboutus/aboutUs-bg1.png'),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 42),
                              child: Text(
                                '有丰富的全球银行服务经验，熟悉全球法规、市场惯例和工作文化；100%项目实施成功率，在全球IT建设领域拥有丰富经验和良好口碑。',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: HsgColors.aboutusTextCon),
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                   Container(
                  height: 218.0,
                  margin: EdgeInsets.only(top: 30.0, left: 21.0, right: 21.0),
                  padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                  decoration: new BoxDecoration(
                      //背景颜色
                      color: Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: SizedBox(
                      height: 125,
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
                                  image: AssetImage(
                                      'images/aboutus/aboutUs-bg1.png'),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30, bottom: 42),
                              child: Text(
                                '有丰富的全球银行服务经验，熟悉全球法规、市场惯例和工作文化；100%项目实施成功率，在全球IT建设领域拥有丰富经验和良好口碑。',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: HsgColors.aboutusTextCon),
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
        
        ]));
  }
}
