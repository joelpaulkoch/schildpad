package app.schildpad.schildpad

import android.appwidget.AppWidgetHost
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeAppWidgetViewFactory(private val appWidgetHost: AppWidgetHost) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeAppWidgetView(context!!, viewId, creationParams, appWidgetHost)
    }
}
