package org.fossasia.magic_epaper_app

import android.app.Activity
import android.graphics.Bitmap
import android.nfc.tech.NfcA
import android.util.Log
import java.io.IOException
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

    fun sendBitmap(nfcTag: NfcA, ePaperSize: Int, bitmap: Bitmap): FlashResult {
        var failMsg = ""
        var success = false

        try {
            nfcTag.timeout = 1200
            
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
            failMsg = "An IO Exception occurred: ${e.message}"
            Log.e("WaveShareHandler", "IO Exception", e)
        } finally {
             if (nfcTag.isConnected) {
                try {
                    nfcTag.close()
                } catch (e: IOException) {
                    Log.e("WaveShareHandler", "Error closing tag connection", e)
                }
            }
        }

        return object : FlashResult {
            override val success = success
            override val errMessage = failMsg
        }
    }
}