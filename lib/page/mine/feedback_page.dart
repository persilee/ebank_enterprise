// TODO Implement this library.
/**
  @desc   意见反馈 
  @author hlx
 */
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Text(
        '意见反馈',
        style: TextStyle(
            fontSize: 17,
            color: HsgColors.aboutusTextCon,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
