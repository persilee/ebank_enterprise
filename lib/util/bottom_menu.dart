import 'package:flutter/material.dart';

void showBottomMenu(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(bottom: 6),
          child: Wrap(
            children: [
              // ListTile(
              //     title: Center(
              //   heightFactor: 1,
              //   child: Text('Account Management',
              //       style: TextStyle(fontSize: 14, color: Colors.grey)),
              // )),
              // Divider(
              //   color: Colors.grey,
              // ),
              ListTile(
                  title: Center(
                heightFactor: 3,
                child: Text('Unbind'),
              )),
            ],
          ),
        );
      });
}
