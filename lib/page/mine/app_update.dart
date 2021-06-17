import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:ebank_mobile/data/source/model/other/get_last_version.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/base_dio.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: non_constant_identifier_names
void AppUpdateCheck(BuildContext context) async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  // print(info.appName);
  // print(info.buildNumber);
  // print(info.packageName);
  // print(info.version);

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    _deviceData = deviceData;
  }

  openUrl() async {
    var url = '';
    if (Platform.isAndroid) {
      switch (BaseDio.TYPEINT) {
        case 1:
          url = 'https://www.pgyer.com/nUA8';
          break;
        case 2:
          url = 'https://www.pgyer.com/SY5b';
          break;
        case 3:
          url = 'https://www.pgyer.com/A9Sh';
          break;
        default:
          url = 'https://www.pgyer.com/nUA8';
      }
    } else if (Platform.isIOS) {
      switch (BaseDio.TYPEINT) {
        case 1:
          url = 'https://www.pgyer.com/Gjv6';
          break;
        case 2:
          url = 'https://www.pgyer.com/rww7';
          break;
        case 3:
          url = 'https://www.pgyer.com/JwO0';
          break;
        default:
          url = 'https://www.pgyer.com/Gjv6';
      }
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  initPlatformState();

  String _systemTypeStr = '0';
  if (Platform.isIOS) {
    _systemTypeStr = '1';
  }

  String _versionIdStr = BaseDio.VERSIONANDROID;
  if (Platform.isIOS) {
    _versionIdStr = BaseDio.VERSIONIOS;
  }

  ///版本更新接口
  ApiClientAccount()
      .getlastVersion(GetLastVersionReq(
    platUserType: 'C',
    systemType: _systemTypeStr,
    versionId: _versionIdStr,
  ))
      .then((value) {
    GetLastVersionResp resp = value;
    print('_+_+_+_+_+_+$resp');
    bool isForceUpdate = resp.forceUpdate == '1';
    HsgShowTip.versionUpdateTip(
      context: context,
      showTipStr: resp.updateText ?? '',
      barrierDismissible: !isForceUpdate,
      click: (value) {
        print('<><><>');
        if (value == true) {
          openUrl();
        }
      },
    );
  });
}
