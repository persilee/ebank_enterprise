// import 'package:ebank_mobile/config/hsg_colors.dart';
// import 'package:flutter/material.dart';

// class HsgButton {
//   static Widget button({
//     String title,

//     ///是否能启用，不能启用时显示灰色，点击事件无响应，能启用时，显示高亮，响应点击事件
//     bool isEnabled = true,
//     Function click,
//   }) {
//     click = isEnabled == true ? click : () {};
//     return Container(
//       padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//       child: ButtonTheme(
//         minWidth: double.infinity,
//         height: 45,
//         child: RaisedButton(
//           onPressed: click,
//           child: Text(
//             title,
//             style: TextStyle(fontSize: 16, color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//           color: HsgColors.blueTextColor,
//           disabledColor: HsgColors.btnDisabled,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         ),
//       ),
//     );
//   }
// }

// Widget HsgGlobalBtn() {

// }
