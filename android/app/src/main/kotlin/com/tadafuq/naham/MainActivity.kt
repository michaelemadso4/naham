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
                    // Receive arguments
                    val arg1: String? = call.argument("arg1")
                    val arg2: String? = call.argument("arg2")

                    startForegroundService(arg1, arg2)
                    result.success("Foreground Service Started")
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startForegroundService(arg1: String?, arg2: String?) {
        val intent = Intent(this, MyForegroundService::class.java).apply {
            putExtra("arg1", arg1)
            putExtra("arg2", arg2)
        }
        startService(intent)
    }


}
