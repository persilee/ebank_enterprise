//本文件下的宏是网络API宏
String URLMacros() {
  //内部版本号 每次发版递增
  // var kVersionCode = 1;

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */
  var devSever = 0;
  var sitSever = 1;
  var uatSever = 0;
  // var proSever = 0;

  String urlSuffix = '';
  String urlMain = '';

  if (devSever == 1) {
    urlSuffix = '';
    urlMain = 'http://161.189.48.75:5040';
  } else if (sitSever == 1) {
    urlSuffix = '';
    urlMain = 'http://47.57.236.20:5040';
  } else if (uatSever == 1) {
    urlSuffix = '';
    urlMain = '';
  } else {
    urlSuffix = '';
    urlMain = '';
  }

  return urlMain + urlSuffix;
}
