/*
 * 版权所有(C) 2021 zhanggenhua
 * 创建: zhanggenhua 2021-02-19
 */

package com.hsg.bank

/**
 * @author zhanggenhua
 * @date 2021-02-19
 */
object CrashLibrary {

  fun log(priority: Int, tag: String?, message: String) {
    /*when (priority) {
      Log.INFO -> BuglyLog.i(tag ?: "Crash", message)
      Log.WARN -> BuglyLog.w(tag ?: "Crash", message)
      Log.ERROR -> BuglyLog.e(tag ?: "Crash", message)
    }*/
  }

  fun logWarning(t: Throwable) {
    /*CrashReport.postCatchedException(t)*/
  }

  fun logError(t: Throwable) {
    /*CrashReport.postCatchedException(t)*/
  }
}