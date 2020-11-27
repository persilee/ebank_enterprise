/**
  @desc   关于我们
  @author hlx
 */
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Loaderman'),
        elevation: 15.0,
      ),
      body: new ListView(
        children: [
          Stack(
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
                
                margin: EdgeInsets.only(top: 41.0),
                child: Text(
                  '全球银行业综合服务商',
                  style: TextStyle(fontSize: 24, color: Color(0xFFFEFEFE),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 76.0),
                child: Text(
                  '专业提供银行IT系统产品、解决方案及全面的开发实施服务',
                  style: TextStyle(fontSize: 14, color: Color.fromRGBO(254, 254, 254, 1),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
