package magic.epaper

import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.IsoDep
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SETTINGS_CHANNEL = "org.fossasia.magicepaperapp/settings"
    private val NFC_CHANNEL = "org.fossasia.magicepaperapp/nfc"

    private val PRESENCE_CHECK_DELAY_MS = 35000
    private val ISODEP_TIMEOUT_MS = 35000

    private var nfcAdapter: NfcAdapter? = null
    @Volatile
    private var isoDep: IsoDep? = null

    private var isReaderModePaused = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
    }

    override fun onResume() {
        super.onResume()
        if (!isReaderModePaused) {
            enableSilentNfcReaderMode()
        }
    }

    private fun enableSilentNfcReaderMode() {
        val adapter = nfcAdapter ?: return
        val options = Bundle()
        options.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, PRESENCE_CHECK_DELAY_MS)
        try {
            adapter.enableReaderMode(
                this,
                { tag: Tag ->
                    val dep = IsoDep.get(tag)
                    if (dep != null) {
                        try {
                            dep.connect()
                            dep.timeout = ISODEP_TIMEOUT_MS
                            isoDep = dep
                        } catch (_: Exception) {
                        }
                    }
                },
                NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
                options
            )
        } catch (_: Exception) {
        }
    }

    private fun disableSilentNfcReaderMode() {
        try {
            isoDep?.close()
        } catch (_: Exception) {
        }
        isoDep = null
        try {
            nfcAdapter?.disableReaderMode(this)
        } catch (_: Exception) {
        }
    }

    override fun onPause() {
        super.onPause()
        disableSilentNfcReaderMode()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openNFCSettings") {
                startActivity(Intent(Settings.ACTION_NFC_SETTINGS))
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NFC_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pauseNfcReaderMode" -> {
                    isReaderModePaused = true
                    disableSilentNfcReaderMode()
                    result.success(null)
                }
                "resumeNfcReaderMode" -> {
                    isReaderModePaused = false
                    enableSilentNfcReaderMode()
                    result.success(null)
                }
                "isTagConnected" -> {
                    result.success(isoDep?.isConnected == true)
                }
                "resetTag" -> {
                    try {
                        isoDep?.close()
                    } catch (_: Exception) {
                    }
                    isoDep = null
                    result.success(null)
                }
                "transceive" -> {
                    val command = call.argument<ByteArray>("data")
                    val dep = isoDep
                    if (dep != null && dep.isConnected && command != null) {
                        Thread {
                            try {
                                val response = dep.transceive(command)
                                runOnUiThread { result.success(response) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("NFC_ERROR", e.message, null) }
                            }
                        }.start()
                    } else {
                        result.error("NO_TAG", "No NFC tag is connected.", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
