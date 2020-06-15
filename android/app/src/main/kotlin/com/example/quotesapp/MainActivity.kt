package com.example.quotesapp

import android.app.Activity
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import androidx.annotation.RequiresApi
import com.amazonaws.auth.CognitoCachingCredentialsProvider
import com.amazonaws.mobile.client.AWSMobileClient
import com.amazonaws.mobile.client.Callback
import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.regions.Regions
import com.amazonaws.services.polly.AmazonPollyPresigningClient
import com.amazonaws.services.polly.model.OutputFormat
import com.amazonaws.services.polly.model.SynthesizeSpeechPresignRequest
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URL


class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.dev/awspolly"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
            call,result ->
            if (call.method=="readQuote"){
                val textquote=call.argument<String>("textQuote")
                Log.i("Android",textquote.toString())
                playVoice(textquote.toString())
                //
                result.success(Activity.RESULT_OK)
            }else{
                result.notImplemented()
            }
        }

    }
     private  fun playVoice(text:String) {

        AWSMobileClient.getInstance().initialize(this, object :Callback<UserStateDetails?> {
            @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
            override fun onResult(result: UserStateDetails?) {
                 var client: AmazonPollyPresigningClient = AmazonPollyPresigningClient(AWSMobileClient.getInstance())

                    try {
                        val credentialsProvider = CognitoCachingCredentialsProvider(
                            applicationContext,
                            "eu-west-2:fa947d6b-41cd-4578-b2a5-3893fb3e04ad",  // Identity pool ID
                            Regions.EU_WEST_2)

                        val synthesizeSpeechPresignRequest: SynthesizeSpeechPresignRequest = SynthesizeSpeechPresignRequest() // Set the text to synthesize.
                                .withText(text) // Select voice for synthesis.
                                .withVoiceId("Salli") // "Joanna"
                                // Set format to MP3.
                                .withOutputFormat(OutputFormat.Mp3)


                        val presignedSynthesizeSpeechUrl: URL = client.getPresignedSynthesizeSpeechUrl(synthesizeSpeechPresignRequest)
                        val mediaPlayer: MediaPlayer? = MediaPlayer().apply {
                            setAudioStreamType(AudioManager.STREAM_MUSIC)
                            setDataSource(presignedSynthesizeSpeechUrl.toString())
                            prepare() // might take long! (for buffering, etc)
                            start()
                        }
                    } catch (e: RuntimeException) {
                        Log.i("aws init",e.toString())
                        return
                    }
                }

            override fun onError(e: Exception?) {
                Log.e("AWS polly ",e.toString())
            }

        })



    }
}
