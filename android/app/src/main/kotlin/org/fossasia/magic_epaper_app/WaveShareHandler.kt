package org.fossasia.magic_epaper_app

import android.app.Activity
import android.graphics.Bitmap
import android.nfc.tech.NfcA
import android.util.Log
import java.io.IOException
import kotlin.concurrent.thread
import waveshare.feng.nfctag.activity.a as WaveShareNfcActivity

interface FlashResult {
    val success: Boolean
    val errMessage: String
}

class WaveShareHandler(private val activity: Activity) {
    private val mInstance: WaveShareNfcActivity = WaveShareNfcActivity()

    init {
        this.mInstance.a()
    }

    val progress get() = this.mInstance.c

    /**
     * Updated sendBitmap function.
     * It now accepts a progress callback and runs asynchronously.
     */
    fun sendBitmap(
        nfcTag: NfcA,
        ePaperSize: Int,
        bitmap: Bitmap,
        onProgress: (Int) -> Unit,
        onComplete: (FlashResult) -> Unit
    ) {
        thread {
            var failMsg = ""
            var success = false
            var isFlashing = true

            // Start a separate thread to report progress
            thread {
                while (isFlashing) {
                    try {
                        onProgress(progress)
                        Thread.sleep(100) // Update progress every 100ms
                    } catch (e: InterruptedException) {
                        break
                    }
                }
            }

            try {
                nfcTag.timeout = 2000 // Increased timeout for better stability

                val connectionSuccessInt = this.mInstance.a(nfcTag)

                if (connectionSuccessInt != 1) {
                    failMsg = "Failed to connect to tag. Code: $connectionSuccessInt"
                } else {
                    val flashSuccessInt = this.mInstance.a(ePaperSize, bitmap)
                    when (flashSuccessInt) {
                        1 -> success = true
                        2 -> failMsg = "Incorrect image resolution"
                        else -> failMsg = "Failed to write over NFC, unknown reason. Code: $flashSuccessInt"
                    }
                }
            } catch (e: IOException) {
                failMsg = "A communication error occurred: ${e.message}"
                Log.e("WaveShareHandler", "IO Exception", e)
            } finally {
                isFlashing = false // Stop the progress reporting thread
                onProgress(100) // Ensure the progress bar completes

                if (nfcTag.isConnected) {
                    try {
                        nfcTag.close()
                    } catch (e: IOException) {
                        Log.e("WaveShareHandler", "Error closing tag connection", e)
                    }
                }

                onComplete(object : FlashResult {
                    override val success = success
                    override val errMessage = failMsg
                })
            }
        }
    }
}