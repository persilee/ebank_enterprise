import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/electronic_statement_repository.dart';
import 'package:ebank_mobile/data/source/model/get_electronic_statement.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ElectronicStatementPage extends StatefulWidget {
  @override
  _ElectronicStatementPageState createState() =>
      _ElectronicStatementPageState();
}

class _ElectronicStatementPageState extends State<ElectronicStatementPage> {
  var dataList = [
    {'date': '2020-06'},
    {'date': '2020-07'},
    {'date': '2020-08'},
    {'date': '2020-09'},
    {'date': '2020-10'},
    {'date': '2020-11'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('电子结单'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              return getRow(context, index);
            }),
      ),
    );
  }

  Widget getRow(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
          color: Colors.white,
          child: RaisedButton(
            color: Colors.white,
            elevation: 0,
            onPressed: () => _getFilePath(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: Text(
                        dataList[index]['date'],
                        style: TextStyle(
                          color: HsgColors.firstDegreeText,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: Image(
                        color: HsgColors.firstDegreeText,
                        image: AssetImage(
                            'images/home/listIcon/home_list_more_arrow.png'),
                        width: 7,
                        height: 10,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: HsgColors.divider,
                  height: 0.5,
                ),
              ],
            ),
          )),
    );
  }

  _getFilePath() async {
    RlectronicStatementRepository()
        .getFilePath(GetFilePathReq(), 'GetFilePathReq')
        .then((data) {
      Navigator.pushNamed(context, data.filePath);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
