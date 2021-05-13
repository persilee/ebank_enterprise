import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class LoanProductListPage extends StatefulWidget {
  @override
  _LoanProductState createState() => _LoanProductState();
}

class _LoanProductState extends State<LoanProductListPage> {
  // List<TdepProducHeadDTO> _productList = [];//产品列表

  var _productList = [
    {
      'sectionTitle': S.current.loan_Product_Characteristics,
      'sectionDetail': [
        {
          'pro_image': 'images/loanProduct/loan_product_flower.png',
          'pro_name': S.current.loan_Product_Per_regular, //标题
          'pro_detai': S.current.loan_Product_Per_detail, //描述
          'pro_linesText': S.current.loan_Product_PlaceholdMore, //额度文本
          'pro_linesNo': '2000000', //额度
          'pro_ID': '0' //产品ID
        },
        {
          'pro_image': 'images/loanProduct/loan_product_have.png',
          'pro_name': S.current.loan_Product_Business, //标题
          'pro_detai': S.current.loan_Product_Business_Deatil, //描述
          'pro_linesText': S.current.loan_Product_PlaceholdMore, //额度
          'pro_linesNo': '10000000', //额度
          'pro_ID': '1' //产品ID
        },
        {
          'pro_image': 'images/loanProduct/loan_product_borrow.png',
          'pro_name': S.current.loan_Product_Foreign, //标题
          'pro_detai': S.current.loan_Product_Foreign_detail, //描述
          'pro_linesText': S.current.loan_Product_PlaceholdMore, //额度
          'pro_linesNo': '5000000', //额度
          'pro_ID': '2' //产品ID
        }
      ]
    },
  ];

//目前是根据定期开立的接口去获取产品的ID 以及名称和汇率等信息
  // Future<void> _loadData() async {
  //   _isLoading = true;
  //   TimeDepositDataRepository()
  //       .getGetTimeDepositProduct(
  //           'getGetTimeDepositProduct',
  //           TimeDepositProductReq(
  //               _accuPeriod == '' ? null : _accuPeriod,
  //               _auctCale == '' ? null : _auctCale,
  //               _changedCcy == S.current.hint_please_select
  //                   ? null
  //                   : _changedCcy,
  //               _bal == 0.0 ? null : _bal,
  //               page,
  //               10,
  //               ''))
  //       .then((data) {
  //     if (data.length != 0) {
  //       List ccys = [];
  //       _isDate = true;
  //       if (this.mounted) {
  //         setState(() {
  //           productList.clear();
  //           producDTOList.clear();
  //           data.forEach((element) {
  //             productList.add(element.tdepProducHeadDTO);
  //             producDTOList.add(element.tdepProductDTOList);
  //             element.tdepProductDTOList.forEach((data) {
  //               ccys.add(data.ccy);
  //               bool isContainer = ccyList.contains(data.ccy);
  //               if (!isContainer) {
  //                 ccyList.add(data.ccy);
  //               }
  //             });
  //           });
  //           _isLoading = false;
  //         });
  //       }
  //     } else {
  //       _isDate = false;
  //     }
  //   }).catchError((e) {
  //     HSProgressHUD.showToast(e);
  //   });
  // }

  //在此进行数据设置
  ScrollController _sctrollController;

  @override
  void initState() {
    _sctrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> productSlivers = []; //每组的数量
    productSlivers.addAll(_loanProductGetListData(context, _productList));
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_Product_NavTitle),
        centerTitle: true,
        elevation: 1, //设置导航栏分割线
      ),
      body: Container(
        color: Color(0xFFF7F7F7),
        child: CustomScrollView(
          controller: _sctrollController,
          slivers: productSlivers,
        ),
      ),
    );
  }

  ///底下列表
  List<Widget> _loanProductGetListData(BuildContext buildContext, List data) {
    List<Widget> _grids = [];
    data.forEach((element) {
      SliverToBoxAdapter adapter = SliverToBoxAdapter(
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 15),
          child: Text(
            element['sectionTitle'],
            style: TextStyle(
              color: HsgColors.firstDegreeText,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      SliverList list = SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return _cellButton(
              //返回创建的cell格式数量
              element['sectionDetail'],
              Color(0xFF242424),
              buildContext,
            );
          },
          childCount: 1, //每组有几行
        ),
      );
      _grids.add(adapter); //添加顶部
      _grids.add(list); //添加中间行
    });
    return _grids;
  }

  ///横向单元格
  Widget _cellButton(
    List data,
    Color bgColor,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _getProductCellWidget(data[0]),
          _getProductCellWidget(data[1]),
          _getProductCellWidget(data[2]),
        ],
      ),
    );
  }

//创建单个的cell
  Widget _getProductCellWidget(Map indexMap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, //设置点击的范围属性

      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
                child: Row(
              children: [
                Container(
                  height: 95,
                  width: 70,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 23),
                  child: Image(
                    image: AssetImage(indexMap["pro_image"]),
                    width: 56,
                    height: 56,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        indexMap["pro_name"],
                        style: TextStyle(
                          color: Color(0xFF242424),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        indexMap["pro_detai"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xFF242424),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: indexMap["pro_linesText"],
                                style: TextStyle(
                                    color: Color(0xFF9C9C9C), fontSize: 13),
                              ),
                              TextSpan(
                                text: indexMap["pro_linesNo"],
                                style: TextStyle(
                                    color: Color(0xFFF8514D), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
            Container(
              color: Color(0xFFE9E9E9),
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
