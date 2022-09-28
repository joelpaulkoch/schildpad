package app.schildpad.schildpad

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter


class AppsUpdateBroadcastReceiver(
    val intentFilter: IntentFilter = IntentFilter().apply {
        addDataScheme("package")
        addAction(Intent.ACTION_PACKAGE_ADDED)
        addAction(Intent.ACTION_PACKAGE_REMOVED)
        addAction(Intent.ACTION_PACKAGE_CHANGED)
    },
    private var updateCounter: Int = 0,
    var listener: (Int) -> Unit = { }
) : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        listener(++updateCounter)
    }
}

