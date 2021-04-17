import 'dart:io';
import 'dart:math';

import 'package:ebank_mobile/data/source/model/statement/statement_query_list_model.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class HsgPdfViewer extends StatefulWidget {

  final String title;
  final StatementDTOS data;

  const HsgPdfViewer({Key key, this.title, this.data}) : super(key: key);

  @override
  _HsgPdfViewerState createState() => _HsgPdfViewerState();
}

class _HsgPdfViewerState extends State<HsgPdfViewer> {

  PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  File _file;
  bool _isLoading = false;

  _loadData() async {
    // print(widget.data.filePath);
    print('StatementDTOS: ${widget.data.toJson()}');
    _isLoading = true;

    final bytes = await ApiClient().statementDownLoad(widget.data.internalId);
    final file = await PDFApi._storeFile('',bytes, '${widget.data.reportName}_${widget.data.reportDate}.pdf');
    setState(() {
      _file = file;
      _isLoading = false;
    });

    // final file = await PDFApi.loadNetwork(widget.data.filePath);
    // final file = await PDFApi.loadNetwork('http://161.189.48.75:5090/general/statement/downLoad?internalId=20200917-C-P-8100000567-01-D-20210401-161946_pdf');
    // setState(() {
    //   _file = file;
    //   _isLoading = false;
    // });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: pages >= 2
            ? [
          Center(child: Text(text)),
          IconButton(
            icon: Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              final page = indexPage == 0 ? pages : indexPage - 1;
              controller.setPage(page);
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 32),
            onPressed: () {
              final page = indexPage == pages - 1 ? 0 : indexPage + 1;
              controller.setPage(page);
            },
          ),
        ]
            : null,
      ),
      body: _isLoading ? HsgLoading() : PDFView(
        filePath: _file.path,
        // autoSpacing: false,
        // swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage),
      ),
    );
  }
}

class PDFApi {
  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes, [String filename]) async {
    var filename;
    if(url.isNotEmpty ) {
      filename = basename(url);
      filename = filename.substring(0,filename.indexOf('.pdf') + 4);
    } else {
      filename = filename ?? randomStr(16) + '.pdf';
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static String randomStr(int length) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strLength = length; /// 生成的字符串固定长度
    String str = '';
    for (var i = 0; i < strLength; i++) {
      str = str + alphabet[Random().nextInt(alphabet.length)];
    }
    return str;
  }
}
