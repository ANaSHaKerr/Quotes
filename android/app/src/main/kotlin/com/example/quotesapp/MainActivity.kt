package com.example.quotesapp

import android.app.Activity
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.dev/awspolly"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
            call,result ->
            if (call.method=="readQuote"){
                val textquote=call.argument<String>("textQuote")
                Log.i("Android",textquote.toString())
                //
                result.success(Activity.RESULT_OK)
            }else{
                result.notImplemented()
            }
        }

    }

}
