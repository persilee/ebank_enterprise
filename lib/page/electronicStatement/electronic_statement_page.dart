import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/electronic_statement_repository.dart';
import 'package:ebank_mobile/data/source/model/get_electronic_statement.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/hsg_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ElectronicStatementPage extends StatefulWidget {
  @override
  _ElectronicStatementPageState createState() =>
      _ElectronicStatementPageState();
}

class _ElectronicStatementPageState extends State<ElectronicStatementPage> {
  var dataList = [
    {'date': '2020-12'},
    {'date': '2020-11'},
    {'date': '2020-10'},
    {'date': '2020-09'},
    {'date': '2020-08'},
    {'date': '2020-07'},
  ];
  GetFilePathResp _fileData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.electronic_statement),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        child: _isLoading
            ? HsgLoading()
            : ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getList(context, index);
                }),
      ),
    );
  }

  Widget _getList(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dataList[index]['date'],
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                    ),
                  ),
                  Image(
                    color: HsgColors.firstDegreeText,
                    image: AssetImage(
                        'images/home/listIcon/home_list_more_arrow.png'),
                    width: 7,
                    height: 10,
                  ),
                ],
              ),
            ),
            Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ],
        ),
      ),
      onTap: () {
        print('aaa');
        openPDF(context, dataList[index]['date']);
      },
    );
  }

  void _loadData() async {
    _isLoading = true;
    try {
      GetFilePathResp filePathResp = await RlectronicStatementRepository()
          .getFilePath(GetFilePathReq(), 'GetFilePathReq');
      setState(() {
        _fileData = filePathResp;
      });
      _isLoading = false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void openPDF(BuildContext context, String title) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HsgPdfViewer(title: title, data: _fileData)));
  }
}
