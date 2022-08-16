package app.schildpad.schildpad

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetHostView
import android.appwidget.AppWidgetManager
import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView

internal class NativeAppWidgetView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    appWidgetHost: AppWidgetHost
) :
    PlatformView {
    private val appWidgetHostView: AppWidgetHostView

    override fun getView(): View {
        return appWidgetHostView
    }

    override fun dispose() {
    }

    init {
        val appWidgetId = creationParams?.get("appWidgetId") as? Int ?: 0

        val appWidgetManager =
            context.applicationContext.getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val appInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)

        val view = appWidgetHost.createView(context, appWidgetId, appInfo)
        appWidgetHostView = view
    }
}