/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 交易详情
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class DetailInfoPage extends StatefulWidget {
  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('交易详情'),
      ),
      body: Container(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16, 27, 17, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '交易金额',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 50),
                    child: Text(
                      '￥ 148.95',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000)),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '商户',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '惠众01年度4612',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '交易卡号',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '信用卡 4392********7976',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '国家或地区',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '中国',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '交易时间',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '2020-02-27 22:32:53',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '交易渠道',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '无',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '记账时间',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '2020-02-28',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '原交易币种',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '人民币(￥)',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '原交易金额',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '-148.95',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
              Divider(height: 20, color: HsgColors.textHintColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '银行交易类型',
                    style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                  ),
                  Text(
                    '消费',
                    style: TextStyle(fontSize: 16, color: Color(0xFF9C9C9C)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
