//import 'dart:html';

import 'package:flutter/material.dart';

class TimeDepostProduct extends StatefulWidget {
  TimeDepostProduct({Key key}) : super(key: key);

  @override
  _TimeDepostProductState createState() => _TimeDepostProductState();
}

class _TimeDepostProductState extends State<TimeDepostProduct> {
  @override
  Widget build(BuildContext context) {
    Widget titleSectionOne = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  '整存整取(HKD)',
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    '2.8%~3.4%',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[500],
                    ),
                  ),
                ),
                new Text(
                  '年利率',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    'Surprise deposit interest rate',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  '100.00起存',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget titleSectionTwo = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  '整存整取(USD)',
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    '2.8%~3.5%',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[500],
                    ),
                  ),
                ),
                new Text(
                  '年利率啊',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    'Surprise deposit interest rate',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  '100.00起存',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget titleSectionThree = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  ' 大额存单',
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    '4.4%~4.5%',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[500],
                    ),
                  ),
                ),
                new Text(
                  '年利率',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    'Can be withdrawn in advance',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  '10000.00起存',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return MaterialApp(
      home: ListView(
        children: [
          new Image.asset(
            'images/time_depost/time_depost_product.png',
            width: 600.0,
            height: 240.0,
            fit: BoxFit.cover,
          ),
          titleSectionOne,
          titleSectionTwo,
          titleSectionThree,
        ],
      ),
    );
  }
}
