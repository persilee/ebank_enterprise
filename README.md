# EBAK MOBILE ENTERPRISE

企业手机银行开发文档。

## 开始

本文要求对Dart语法，Flutter开发有一定基础：
- [Dart](https://dart.cn/guides)
- [Flutter](https://flutter.cn/docs)

如果遇到资源下载问题，可[配置Flutter镜像资源](https://flutter.cn/community/china)：

```bash
# MacOS or Linux
 export PUB_HOSTED_URL=https://pub.flutter-io.cn
 export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
 
# Windows则新增两个环境变量
PUB_HOSTED_URL(值：https://pub.flutter-io.cn)
FLUTTER_STORAGE_BASE_URL(值：https://storage.flutter-io.cn)
```
然后运行`flutter doctor`，则下次使用`flutter pub get`时，会从镜像地址下载资源。

### 网络请求与Json

对于每个网络请求或者其他需要用到Json序列化/反序列化的类，按以下步骤进行编写。

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

### 插件

- Flutter Intl：用于国际化开发，在lib/l10n目录下存放(编辑)语言文件

### 资源文件

图片文件存放目录：项目根目录下的`images`文件夹，并在`pubspec.yaml`文件的`assets`下声明。

其他资源存放目录：lib/config，有：
- `hsg_colors.dart`: 颜色定义
- `hsg_dimens.dart`: 尺寸定义
- `hsg_styles.dart`: 样式定义

### 对话框调用
参考`lib/feature_demo/dialog_demo.dart`
