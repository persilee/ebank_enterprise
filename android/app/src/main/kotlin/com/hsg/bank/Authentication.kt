/*
 * 版权所有(C) 2021 zhanggenhua
 * 创建: zhanggenhua 2021-03-15
 */

package com.hsg.bank

import android.app.Activity
import com.bufeng.videoSDKbase.activity.SelectTypeActivity
import com.bufeng.videoSDKbase.utils.SharedCacheUtils
import com.bufeng.videoSDKbase.utils.VideoUtil
import com.hsg.bank.model.AuthIdentityReq
import timber.log.Timber

/**
 * @author zhanggenhua
 * @date 2021-03-15
 */

fun startAuth(act: Activity, req: AuthIdentityReq, result: (String) -> Unit) {
  SharedCacheUtils.putString(act,"tokId",req.tokId)
  SharedCacheUtils.putString(act,"language",req.language)
  SharedCacheUtils.putString(act,"country",req.country)
  VideoUtil.startActivity(act, req.tenantId, req.businessId, req.language, req.type, object : VideoUtil.FaceRecognitionBack {
    override fun faceSuccess(p0: String) {
      Timber.tag("qianli").d("success:$p0")
      result("success")
    }

    override fun faceError(p0: String) {
      Timber.tag("qianli").d("failed:$p0")
      result("failed")
    }
  })
}