package app.schildpad.schildpad

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import androidx.annotation.NonNull
import androidx.core.graphics.drawable.toBitmap
import app.schildpad.schildpad.protos.*
import com.google.protobuf.ByteString
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.ByteArrayOutputStream


class MainActivity : FlutterActivity() {
    private val APPS_CHANNEL = "schildpad.schildpad.app/apps"
    private val APPWIDGETS_CHANNEL = "schildpad.schildpad.app/appwidgets"
    private val appWidgetHost: AppWidgetHost by lazy { AppWidgetHost(context, 0) }
    private val nativeAppWidgetViewFactory: NativeAppWidgetViewFactory by lazy {
        NativeAppWidgetViewFactory(
            appWidgetHost
        )
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "app.schildpad.schildpad/appwidgetview", nativeAppWidgetViewFactory
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, APPS_CHANNEL
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            if (call.method == "getInstalledApps") {
                val widgets = getInstalledApps()
                result.success(widgets.toByteArray())
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, APPWIDGETS_CHANNEL
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            when (call.method) {
                ("getInstalledAppWidgets") -> {
                    val widgets = getInstalledAppWidgets()
                    result.success(widgets.toByteArray())
                }
                ("getWidgetId") -> {
                    val args = call.arguments as List<String>
                    val componentName = args.first()
                    val widgetId = createAndBindWidget(componentName)
                    if (widgetId != null) result.success(widgetId) else result.error(
                        "FAILED",
                        "No widget id",
                        "Could neither find existing widget corresponding to $componentName nor create a new one"
                    )
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

    }

    private fun getInstalledApps(): InstalledApps {
        val packageInfos =
            packageManager.getInstalledPackages(PackageManager.GET_META_DATA)
                .filter { it.applicationInfo.enabled }
                .filter { (it.applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0 }

        val installedApps = installedApps {

            for (packageInfo in packageInfos) {
                val launchIntent = packageManager.getLaunchIntentForPackage(packageInfo.packageName)
                val launchIntentComponent = launchIntent?.component
                if (launchIntent != null && launchIntentComponent != null) {
                    val app = app {
                        name = packageInfo.applicationInfo.loadLabel(packageManager).toString()
                        packageName = packageInfo.packageName

                        icon = AppKt.drawableData {
                            val bmp: Bitmap? =
                                packageInfo.applicationInfo.loadIcon(packageManager).toBitmap()
                            if (bmp != null) {
                                data = ByteString.copyFrom(bmp.convertToByteArray())
                            }
                        }
                        launchComponent = launchIntentComponent.className
                    }
                    apps += app
                }
            }
        }
        return installedApps
    }

    private fun getInstalledAppWidgets(): InstalledAppWidgets {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val providers = appWidgetManager.installedProviders

        val installedAppWidgets = installedAppWidgets {
            for (provider in providers) {
                val widget = appWidget {
                    packageName = provider.provider.packageName
                    componentName = provider.provider.className

                    val appInfo = packageManager.getApplicationInfo(
                        provider.provider.packageName, PackageManager.GET_META_DATA
                    )
                    appName = appInfo.loadLabel(packageManager).toString()
                    label = provider.loadLabel(packageManager)

                    minWidth = provider.minWidth
                    minHeight = provider.minHeight
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        description = provider.loadDescription(context).toString()
                        targetWidth = provider.targetCellWidth
                        targetHeight = provider.targetCellHeight
                    }
                    icon = AppWidgetKt.drawableData {
                        val bmp: Bitmap? =
                            provider.loadIcon(context, DisplayMetrics.DENSITY_DEFAULT).toBitmap()
                        if (bmp != null) {
                            data = ByteString.copyFrom(bmp.convertToByteArray())
                        }
                    }
                }
                appWidgets += widget
            }
        }
        return installedAppWidgets
    }

    private fun getWidgetId(componentName: String): Int? {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val provider =
            appWidgetManager.installedProviders.find { p: AppWidgetProviderInfo? -> p?.provider?.className == componentName }

        val existingIds = appWidgetManager.getAppWidgetIds(provider?.provider)

        if (existingIds.isEmpty()) {
            return createAndBindWidget(componentName)
        }
        return existingIds.first()

    }

    private fun createAndBindWidget(componentName: String): Int? {

        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager

        val provider =
            appWidgetManager.installedProviders.find { p: AppWidgetProviderInfo? -> p?.provider?.className == componentName }
                ?: return null

        val appWidgetId = appWidgetHost.allocateAppWidgetId()
        val allowed = appWidgetManager.bindAppWidgetIdIfAllowed(appWidgetId, provider.provider)

        if (!allowed) {
            val intent = Intent(AppWidgetManager.ACTION_APPWIDGET_BIND).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_PROVIDER, provider.provider)
                // This is the options bundle described in the preceding section.
                // putExtra(AppWidgetManager.EXTRA_APPWIDGET_OPTIONS, options)
            }
            val REQUEST_BIND_APPWIDGET = 1
            startActivityForResult(intent, REQUEST_BIND_APPWIDGET)
        }
        //TODO test binding
        return appWidgetId
    }

    private fun Bitmap.convertToByteArray(): ByteArray {
        val byteArrayOS = ByteArrayOutputStream()
        this.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOS)
        return byteArrayOS.toByteArray()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra(
            "background_mode", FlutterActivityLaunchConfigs.BackgroundMode.transparent.toString()
        )
        super.onCreate(savedInstanceState)
    }

    override fun onStart() {
        appWidgetHost.startListening()
        super.onStart()
    }

    override fun onStop() {
        appWidgetHost.stopListening()
        super.onStop()
    }
}
