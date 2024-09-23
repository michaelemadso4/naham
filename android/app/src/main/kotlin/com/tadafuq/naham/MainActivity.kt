package com.tadafuq.naham

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.tadafuq.naham"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "startForegroundService") {
                    startForegroundService()
                    result.success("Foreground Service Started")
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startForegroundService() {
        val intent = Intent(this, MyForegroundService::class.java)
        startService(intent)
    }


}
