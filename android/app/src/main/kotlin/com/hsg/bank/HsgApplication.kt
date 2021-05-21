/*
 * 版权所有(C) 2021 zhanggenhua
 * 创建: zhanggenhua 2021-03-15
 */

package com.hsg.bank

import android.content.Context
import android.util.Log
import com.alibaba.sdk.android.push.CloudPushService
import com.alibaba.sdk.android.push.CommonCallback
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import com.bufeng.videoSDKbase.AppApplication
import com.hsg.bank.brillink.BuildConfig
import com.tencent.bugly.webank.Bugly
import io.flutter.FlutterInjector
import timber.log.Timber


/**
 * @author zhanggenhua
 * @date 2021-03-15
 */
class HsgApplication : AppApplication() {

  override fun onCreate() {
    if (BuildConfig.DEBUG) {
      Timber.plant(Timber.DebugTree())
    } else {
      Timber.plant(CrashReportingTree())
    }
    val startTime = System.currentTimeMillis()
    super.onCreate()
    Timber.d("签里眼SDK初始化耗时：${System.currentTimeMillis() - startTime}")
    FlutterInjector.instance().flutterLoader().startInitialization(this)

    initCloudChannel(this);

    // 获取隐私政策签署状态
    // 获取隐私政策签署状态
    val sign = true

    if (sign) {
      registerPush()
    } else {
      // 没签，等签署之后再调用registerPush()
    }
  }

  /** A tree which logs important information for crash reporting.  */
  private class CrashReportingTree : Timber.Tree() {
    override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
      if (priority == Log.VERBOSE || priority == Log.DEBUG) {
        return
      }
      CrashLibrary.log(priority, tag, message)
      if (t != null) {
        if (priority == Log.ERROR) {
          CrashLibrary.logError(t)
        } else if (priority == Log.WARN) {
          CrashLibrary.logWarning(t)
        }
      }
    }
  }

  /**
   * 初始化云推送通道
   * @param applicationContext
   */
  private val TAG: String? = "Init"
  private fun initCloudChannel(applicationContext: Context) {
    PushServiceFactory.init(applicationContext)
    val pushService: CloudPushService = PushServiceFactory.getCloudPushService()
    pushService.register(applicationContext, object : CommonCallback() {
      fun onSuccess(response: String?) {
        Log.d(TAG, "init cloudchannel success")
      }

      fun onFailed(errorCode: String, errorMessage: String) {
        Log.d(TAG, "init cloudchannel failed -- errorcode:$errorCode -- errorMessage:$errorMessage")
      }
    })
  }

  /**
   * 建立推送通道
   */
  fun registerPush() {
    val pushService: CloudPushService = PushServiceFactory.getCloudPushService()
    pushService.register(Bugly.applicationContext, object : CommonCallback() {
      fun onSuccess(response: String?) {}
      fun onFailed(errorCode: String?, errorMessage: String?) {}
    })
  }

}