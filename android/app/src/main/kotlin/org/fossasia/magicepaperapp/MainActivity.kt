package org.fossasia.magicepaperapp

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.NfcA
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterActivity() {
    private val SETTINGS_CHANNEL = "org.fossasia.magicepaperapp/settings"
    private val NFC_CHANNEL = "org.fossasia.magicepaperapp/nfc"
    private val NFC_PROGRESS_CHANNEL = "org.fossasia.magicepaperapp/nfc_progress"

    private var nfcAdapter: NfcAdapter? = null
    private lateinit var waveShareHandler: WaveShareHandler
    private var progressEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        waveShareHandler = WaveShareHandler(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openNFCSettings") {
                val intent = Intent(Settings.ACTION_NFC_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NFC_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "flashImage") {
                val arguments = call.arguments as Map<String, Any>
                val imageBytes = arguments["imageBytes"] as ByteArray
                val ePaperSize = arguments["ePaperSize"] as Int

                if (nfcAdapter == null) {
                    result.error("NFC_UNAVAILABLE", "NFC is not available on this device.", null)
                    return@setMethodCallHandler
                }

                if (!nfcAdapter!!.isEnabled) {
                    result.error("NFC_DISABLED", "NFC is disabled.", null)
                    return@setMethodCallHandler
                }

                val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

                GlobalScope.launch {
                    flashImageToTag(bitmap, ePaperSize, result)
                }
            } else {
                result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, NFC_PROGRESS_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    progressEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    progressEventSink = null
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openNFCSettings") {
                val intent = Intent(Settings.ACTION_NFC_SETTINGS)
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private suspend fun flashImageToTag(bitmap: Bitmap, ePaperSize: Int, channelResult: MethodChannel.Result) {
    withContext(Dispatchers.IO) {
        try {
            nfcAdapter?.enableReaderMode(this@MainActivity, { tag ->
                val nfcA = NfcA.get(tag)
                if (nfcA != null) {
                    waveShareHandler.sendBitmap(
                        nfcTag = nfcA,
                        ePaperSize = ePaperSize,
                        bitmap = bitmap,
                        onProgress = { progress ->
                            runOnUiThread {
                                progressEventSink?.success(progress)
                            }
                        },
                        onComplete = { flashResult ->
                            runOnUiThread {
                                if (flashResult.success) {
                                    channelResult.success("Image flashed successfully!")
                                } else {
                                    channelResult.error("FLASH_FAILED", flashResult.errMessage, null)
                                }
                            }
                            nfcAdapter?.disableReaderMode(this@MainActivity)
                        }
                    )
                } else {
                    runOnUiThread {
                        channelResult.error("TAG_NOT_SUPPORTED", "NFC tag type not supported.", null)
                    }
                    nfcAdapter?.disableReaderMode(this@MainActivity)
                }
            }, NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK, null)
        } catch (e: Exception) {
            runOnUiThread {
                channelResult.error("NFC_ERROR", e.message, null)
            }
        }
    }
}

}
