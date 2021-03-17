package com.hsg.bank

import com.google.gson.Gson
import com.hsg.bank.model.AuthIdentityReq
import com.hsg.bank.model.AuthIdentityResp
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL = "com.hsg.bank.brillink/auth-identity"

class MainActivity : FlutterActivity() {

  private val gson = Gson()

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "startAuth" -> {
          startAuth(this, gson.fromJson(call.argument("body") as String?, AuthIdentityReq::class.java))
          result.success(gson.toJson(AuthIdentityResp("invoke success")))
        }
        else -> result.notImplemented()
      }
    }
  }
}
