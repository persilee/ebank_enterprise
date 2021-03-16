/*
 * 版权所有(C) 2021 zhanggenhua
 * 创建: zhanggenhua 2021-03-16
 */

package com.hsg.bank.model

/**
 * @author zhanggenhua
 * @date 2021-03-16
 */

class AuthIdentityReq(
  val tenantId: String,
  val businessId: String,
  val language: String,
  // 字符串 1  大陆证件识别，2 港澳台证件识别，3 护照识别
  val type: String,
)

class AuthIdentityResp(
  val result: String
)