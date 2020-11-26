# EBAK MOBILE ENTERPRISE

企业手机银行

## 开始

本文要求对Dart语法，Flutter开发有一定基础：
- [Dart](https://dart.cn/guides)
- [Flutter](https://flutter.cn/docs)

### Json

对于每个网络请求或者其他需要用到Json序列化/反序列化的类，按以下步骤进行编写。

1.进入项目根目录，在终端或命令行中运行：

```bash
 flutter packages pub run build_runner watch
```

2.定义完实体和属性，对类声明注解`@JsonSerializable()`，然后手动编写序列化与序列化代码，调用插件生成的方法，序列化调用`_$XXXToJson()`方法，反序列化调用`_$XXXFromJson()`方法。如：

```Dart
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

图片文件存放目录：项目根目录下的`images`文件夹，并在`pubspec.yaml`文件的`assets`下声明
