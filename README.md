# EBAK MOBILE ENTERPRISE

企业手机银行开发文档。

## 开始

本文要求对 Dart 语法，Flutter 开发有一定基础：

- [Dart](https://dart.cn/guides)
- [Flutter](https://flutter.cn/docs)

如果遇到资源下载问题，可[配置 Flutter 镜像资源](https://flutter.cn/community/china)：

```bash
# MacOS or Linux
 export PUB_HOSTED_URL=https://pub.flutter-io.cn
 export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# Windows则新增两个环境变量
PUB_HOSTED_URL(值：https://pub.flutter-io.cn)
FLUTTER_STORAGE_BASE_URL(值：https://storage.flutter-io.cn)
```

然后运行`flutter doctor`，则下次使用`flutter pub get`时，会从镜像地址下载资源。

### 网络请求与 Json

对于每个网络请求或者其他需要用到 Json 序列化/反序列化的类，按以下步骤进行编写。

1.进入项目根目录，在终端或命令行中运行：

```bash
# 一次性生成
flutter pub run build_runner build

# 持续生成
flutter packages pub run build_runner watch
```

2.定义完实体和属性，对类声明注解`@JsonSerializable()`，然后手动编写序列化与序列化代码，调用插件生成的方法，序列化调用`_$XXXToJson()`方法，反序列化调用`_$XXXFromJson()`方法。如：

```Dart
import 'package:json_annotation/json_annotation.dart';
/// 手动输入这行xxx(文件名).g.dart
part 'login.g.dart';

/// 对象实体定义
@JsonSerializable()
class LoginResp {
  String userId;
  String custId;
  String userAccount;
  String headPortrait;
  String actualName;
  String userPhone;

  /// 默认构造方法给_$LoginRespFromJson使用
  LoginResp(this.userId, this.custId, this.userAccount, this.headPortrait,
      this.actualName, this.userPhone);

  factory LoginResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginRespToJson(this);
}

/// 调用
Future<LoginResp> login(LoginReq loginReq, String tag) {
    return request(
        'security/cutlogin', loginReq, tag, (data) => LoginResp.fromJson(data));
  }

```

3.另外，为了方便将 json 数据转换成实体类型，可以使用转换工具，比如：[点击这里](https://caijinglong.github.io/json2dart/index_ch.html)。

### 插件

- Flutter Intl：用于国际化开发，在 lib/l10n 目录下存放(编辑)语言文件
  注意：若手动修改了 intl_en.arb 和 intl_zh_CN.arb 两个文件，末尾的逗号记得删除，保证文件格式是 JSON 格式

### 资源文件

图片文件存放目录：项目根目录下的`images`文件夹，并在`pubspec.yaml`文件的`assets`下声明。

其他资源存放目录：lib/config，有：

- `hsg_colors.dart`: 颜色定义
- `hsg_dimens.dart`: 尺寸定义
- `hsg_styles.dart`: 样式定义

### 对话框调用

参考`lib/feature_demo/dialog_demo.dart`

### 文件头配置

为了方便追踪文件作者，需要配置一个通用文件头。安装`psioniq File Header`插件，配置`settings.json`文件：

```Json
"psi-header.config": {
    "forceToTop": true,
    "blankLinesAfter": 0,
},
"psi-header.variables": [
    ["company", "深圳高阳寰球科技有限公司"],
    ["author", "你的名字"],
],
"psi-header.lang-config": [
    {
        "language": "dart",
        "begin": "",
        "prefix": "///",
        "end": "",
        "blankLinesAfter": 1
    }
],
"psi-header.templates": [
    {
        "language": "*",
        "template": [
            " Copyright (c) <<year>> <<company>>",
            "",
            " Author: <<author>>",
            " Date: <<filecreated('YYYY-MM-DD')>>",
        ]
    }
]
```

添加 header 快捷键：双击`control+option+h`(macOS)/双击`ctrl+alt+h`(windows)

### Android 打包

输入以下命令：

```bash
flutter build apk
```

打包完成后的输出文件(apk)目录： `<app dir>/build/app/outputs/apk/app-release.apk`

### pub finished with exit code 78 解决办法

一、常规办法
执行 flutter packages pub run build_runner build 后报 code 78 错误
1、flutter packages pub run build_runner clean
2、flutter packages pub run build_runner build --delete-conflicting-outputs
以上方法会解决大部分错误
