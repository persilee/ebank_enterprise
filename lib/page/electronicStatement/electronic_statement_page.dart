import 'package:date_format/date_format.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/statement/get_electronic_statement.dart';
import 'package:ebank_mobile/data/source/model/statement/statement_query_list_body.dart';
import 'package:ebank_mobile/data/source/model/statement/statement_query_list_model.dart';
import 'package:ebank_mobile/generated/l10n.dart' as Intl;
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/widget/custom_pop_window_button.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/hsg_pdf_viewer.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class ElectronicStatementPage extends StatefulWidget {
  @override
  _ElectronicStatementPageState createState() =>
      _ElectronicStatementPageState();
}

class _ElectronicStatementPageState extends State<ElectronicStatementPage> {
  String _startDate = DateFormat('yyyy-MM-01').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); //结束时间
  String _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
  String _start = formatDate(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      [yyyy, mm, dd]); //显示开始时间
  String _time; //拼接时间

  GetFilePathResp _fileData;
  StatementDTOS _statementDTOS;
  List<StatementDTOS> dataList = [];
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
          title: Text(Intl.S.current.electronic_statement),
          centerTitle: true,
          elevation: 1,
        ),
        body: Column(
          children: [
            Container(
                //顶部的筛选条件
                height: 40,
                color: Colors.white,
                padding: EdgeInsets.only(left: 10),
                child: _creatScreenAlert()),
            Container(
              //底部的列表数据
              color: HsgColors.commonBackground,
              child: _isLoading
                  ? HsgLoading()
                  : dataList.length <= 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Container(
                            child: notDataContainer(
                                context, Intl.S.current.no_data_now),
                          ),
                        )
                      : ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _getList(context, index);
                          }),
            ),
          ],
        ));
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
                    dataList[index].reportDate,
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
        _statementDTOS = dataList[index];
        openPDF(context, dataList[index].reportName);
      },
    );
  }

  void _loadData() async {
    _isLoading = true;
    try {
      StatementQueryListModel statementQueryListModel =
          await ApiClient().statementQueryList(StatementQueryListBody(
        startDate: _startDate,
        endDate: '2022-12-31', //_endDate,
      ));
      if (mounted) {
        setState(() {
          dataList.addAll(statementQueryListModel.statementDTOS);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      HSProgressHUD.showToast(e);
    }
  }

  void openPDF(BuildContext context, String title) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            HsgPdfViewer(title: title, data: _statementDTOS)));
  }

  //顶部弹窗
  Widget _creatScreenAlert() {
    return CustomPopupWindowButton(
      offset: Offset(MediaQuery.of(context).size.width / 2.3, 200),
      buttonBuilder: (BuildContext context) {
        return GestureDetector(
          child: _screenTitle(),
        );
      },
      windowBuilder: (BuildContext popcontext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: _selectionTimeData(popcontext),
          ),
        );
      },
    );
  }

  //筛选条件title
  Widget _screenTitle() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: _lineBorderSide(),
          ),
        ),
        padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
        child: Row(
          children: [
            _condition(), //左侧文本
            _checked(), //占位文本
            _rightArrow(HsgColors.nextPageIcon) //图标文件
          ],
        ));
  }

  //筛选条件文本
  Widget _condition() {
    return Container(
      width: (MediaQuery.of(context).size.width - 30) / 5 * 2,
      child: Text(
        Intl.S.current.transaction_time,
        style: TextStyle(
          fontSize: 13,
          color: HsgColors.firstDegreeText,
        ),
      ),
    );
  }

  //选择时间后的展示文本
  Widget _checked() {
    return Container(
      width: (MediaQuery.of(context).size.width - 90) / 5 * 3,
      child: Text(
        _start + '-' + _end,
        style: TextStyle(
            color: HsgColors.firstDegreeText,
            fontSize: 13,
            fontWeight: FontWeight.normal),
        textAlign: TextAlign.right,
      ),
    );
  }

  // 设置单侧边框的样式
  BorderSide _lineBorderSide() {
    return BorderSide(
      color: HsgColors.divider,
      width: 0.5,
      style: BorderStyle.solid,
    );
  }

  //右箭头图标
  Widget _rightArrow(Color color) {
    return Container(
      width: 20,
      height: 20,
      child: Icon(
        Icons.arrow_drop_down,
        color: color,
      ),
    );
  }

  //弹窗
  _selectionTimeData(BuildContext popcontext) {
    return InkWell(
      //防止点击标题附近头部标题隐藏
      onTap: () {
        (popcontext as Element).markNeedsBuild();
      },
      child: Container(
        color: Colors.white,
        height: 150,
        padding: EdgeInsets.all(10),
        child: Material(
            child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timeText(Intl.S.current.user_defined), //自定义时间文本
                  _userDefind(popcontext), //时间选择文本
                  //按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _resetButton(popcontext),
                      _confimrButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

//自定义时间按钮
  Widget _timeButton(String name, int i, BuildContext popcontext) {
    print(name);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
      width: MediaQuery.of(popcontext).size.width / 2.7,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xffECECEC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 13, color: Color(0xff212121)),
            ),
            Container(
              width: 8,
              height: 7,
              margin: EdgeInsets.only(bottom: 20, left: 10),
              child: Icon(
                Icons.arrow_drop_down,
                color: Color(0xffAAAAAA),
              ),
            ),
          ],
        ),
        onPressed: () {
          _timePicker(i, popcontext);
        },
      ),
    );
  }

  //时间文本
  Widget _timeText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 12, 0, 12),
      child: Text(
        text,
        style: TRANSFER_RECORD_POP_TEXT_STYLE,
      ),
    );
  }

  //自定义时间
  Widget _userDefind(BuildContext popcontext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //开始时间按钮
        _timeButton(_start, 0, popcontext),
        //至
        Text(
          Intl.S.current.zhi,
          style: TextStyle(
            fontSize: 12,
            color: HsgColors.aboutusTextCon,
            decoration: TextDecoration.none,
          ),
        ),
        //结束时间按钮
        _timeButton(_end, 1, popcontext),
      ],
    );
  }

  //时间选择器弹窗
  _timePicker(int i, BuildContext popcontext) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          Intl.S.current.confirm,
          style: TRANSFER_RECORD_TIME_PICKER_TEXT_STYLE,
        ),
        cancel: Text(
          Intl.S.current.cancel,
          style: TRANSFER_RECORD_TIME_PICKER_TEXT_STYLE,
        ),
      ),
      minDateTime: DateTime.parse('1900-01-01'),
      maxDateTime: DateTime.now(),
      initialDateTime: i == 0
          ? DateTime.parse(_startDate)
          : DateTime.parse(_endDate), //DateTime.now(),
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          if (i == 0) {
            _start = formatDate(dateTime, [yyyy, mm, dd]);
            _startDate = DateFormat('yyyy-MM-dd').format(dateTime);
          } else {
            _end = formatDate(dateTime, [yyyy, mm, dd]);
            _endDate = DateFormat('yyyy-MM-dd').format(dateTime);
          }
        });
        (popcontext as Element).markNeedsBuild();
      },
    );
  }

  //重置按钮
  Widget _resetButton(BuildContext popcontext) {
    return Container(
      width: MediaQuery.of(popcontext).size.width / 3.6,
      height: 30,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0x77939393), width: 0.5),
        borderRadius: BorderRadius.circular((5)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Text(
          Intl.S.of(context).reset,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        onPressed: () {
          setState(() {
            // _time = intl.S.current.the_same_month;

            _start = formatDate(
                DateTime(DateTime.now().year, DateTime.now().month, 1),
                [yyyy, mm, dd]); //显示开始时间
            _end = formatDate(DateTime.now(), [yyyy, mm, dd]); //显示结束时间
            (popcontext as Element).markNeedsBuild();
            // _startAmountController.text = '';
            // _endAmountController.text = '';
          });
        },
      ),
    );
  }

//确定按钮
  Widget _confimrButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
      width: MediaQuery.of(context).size.width / 3.6,
      height: 30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1775BA),
            Color(0xFF3A9ED1),
          ],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        borderSide: BorderSide(color: Colors.white),
        child: Text(
          Intl.S.of(context).confirm,
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            _time = _start + "—" + _end;
            // _page = 1;
            dataList.clear();
          });
          Navigator.of(context).pop();
          _loadData();
        },
      ),
    );
  }
}
