

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:flutter/material.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 无数据显示页面
/// Author: 彭逸康
/// Date: 2021-01-15

notDataContainer(BuildContext context, String noDateText){

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('images/noDataIcon/no_data_record.png'),
            width: 160,
          ),
          Text(
          noDateText,
            style: FIRST_DEGREE_TEXT_STYLE,
          )
        ],
      ),
    );
  }

