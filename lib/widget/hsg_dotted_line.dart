/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///虚线
/// Author: fangluyao
/// Date: 2021-01-06

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final Axis direction;

  const DottedLine({
    this.height = 1,
    this.color = HsgColors.divider,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWidth : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
        );
      },
    );
  }
}
