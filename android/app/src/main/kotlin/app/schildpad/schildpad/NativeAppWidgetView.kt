package app.schildpad.schildpad

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetHostView
import android.appwidget.AppWidgetManager
import android.content.Context
import android.graphics.Color
import android.view.View
import io.flutter.plugin.platform.PlatformView

internal class NativeAppWidgetView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    private val appWidgetHost: AppWidgetHost
) :
    PlatformView {
    private val appWidgetHostView: AppWidgetHostView
    private val appWidgetId: Int

    override fun getView(): View {
        appWidgetHost.startListening()
        return appWidgetHostView
    }

    override fun dispose() {
        appWidgetHost.deleteAppWidgetId(appWidgetId)
    }

    init {
        appWidgetId = creationParams?.get("appWidgetId") as? Int ?: 0

        val appWidgetManager =
            context.applicationContext.getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val appInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)

        val view = appWidgetHost.createView(context, appWidgetId, appInfo)
        // TODO check models where transparency is a problem
        view.setBackgroundColor(Color.argb(255, 0, 0, 0))
        appWidgetHostView = view
    }
}