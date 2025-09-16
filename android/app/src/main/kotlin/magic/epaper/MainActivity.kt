package magic.epaper

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
import java.util.concurrent.atomic.AtomicBoolean

class MainActivity : FlutterActivity() {
    private val SETTINGS_CHANNEL = "org.fossasia.magicepaperapp/settings"
    private val NFC_CHANNEL = "org.fossasia.magicepaperapp/nfc"
    private val NFC_PROGRESS_CHANNEL = "org.fossasia.magicepaperapp/nfc_progress"

    private var nfcAdapter: NfcAdapter? = null
    private lateinit var waveShareHandler: WaveShareHandler
    private var progressEventSink: EventChannel.EventSink? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        waveShareHandler = WaveShareHandler(this)
    }

    override fun onResume() {
        super.onResume()
        nfcAdapter?.enableReaderMode(
            this,
            { tag: Tag? -> /* Do nothing, just intercept the event to silence it */ },
            NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
            null
        )
    }

    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableReaderMode(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NFC_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "flashImage" -> {
                    val arguments = call.arguments as Map<String, Any>
                    val imageBytes = arguments["imageBytes"] as ByteArray
                    val ePaperSize = arguments["ePaperSize"] as Int

                    if (nfcAdapter == null || !nfcAdapter!!.isEnabled) {
                        result.error("NFC_ERROR", "NFC is not available or not enabled.", null)
                        return@setMethodCallHandler
                    }

                    val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                    GlobalScope.launch {
                        flashImageToTag(bitmap, ePaperSize, result)
                    }
                }
                
                "disableNfcReaderMode" -> {
                    // First, disable whatever reader mode is currently active
                    nfcAdapter?.disableReaderMode(this@MainActivity)
                    
                    // Re-enable the silent, reader mode.
                    // Prevents the OS from reading the tag.
                    nfcAdapter?.enableReaderMode(
                        this@MainActivity,
                        { tag: Tag? -> /* Do nothing */ },
                        NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                        null
                    )
                    
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Handler for reporting progress back to Flutter
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
    }

    private suspend fun flashImageToTag(bitmap: Bitmap, ePaperSize: Int, channelResult: MethodChannel.Result) {
        // Create a thread-safe flag to ensure we only send a result ONCE
        val resultSent = AtomicBoolean(false)

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
                                runOnUiThread { progressEventSink?.success(progress) }
                            },
                            onComplete = { flashResult ->
                                runOnUiThread {
                                    // Atomically check and set the flag. This block will only run once.
                                    if (resultSent.compareAndSet(false, true)) {
                                        if (flashResult.success) {
                                            channelResult.success("Image flashed successfully!")
                                        } else {
                                            nfcAdapter?.disableReaderMode(this@MainActivity)
                                            nfcAdapter?.enableReaderMode(
                                                this@MainActivity,
                                                { t: Tag? -> /* Do nothing */ },
                                                NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                                                null
                                            )
                                            channelResult.error("FLASH_FAILED", flashResult.errMessage, null)
                                        }
                                    }
                                }
                            }
                        )
                    } else {
                        runOnUiThread {
                            if (resultSent.compareAndSet(false, true)) {
                                nfcAdapter?.disableReaderMode(this@MainActivity)
                                nfcAdapter?.enableReaderMode(
                                    this@MainActivity,
                                    { t: Tag? -> /* Do nothing */ },
                                    NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                                    null
                                )
                                channelResult.error("TAG_NOT_SUPPORTED", "NFC tag type not supported.", null)
                            }
                        }
                    }
                }, NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK, null)
            } catch (e: Exception) {
                runOnUiThread {
                    if (resultSent.compareAndSet(false, true)) {
                        nfcAdapter?.disableReaderMode(this@MainActivity)
                        nfcAdapter?.enableReaderMode(
                            this@MainActivity,
                            { t: Tag? -> /* Do nothing */ },
                            NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                            null
                        )
                        channelResult.error("NFC_ERROR", e.message, null)
                    }
                }
            }
        }
    }
}