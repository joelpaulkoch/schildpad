package app.schildpad.schildpad

import android.appwidget.AppWidgetHost
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.Context
import android.content.Intent
import android.content.pm.LauncherApps
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import androidx.annotation.NonNull
import androidx.core.graphics.drawable.toBitmap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
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
        val taskQueue =
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, APPS_CHANNEL, StandardMethodCodec.INSTANCE, taskQueue
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            when (call.method) {
                ("getApplicationIds") -> {
                    val applicationIds = getApplicationIds()
                    result.success(applicationIds)
                }
                ("getApplicationLabel") -> {
                    val args = call.arguments as List<String>
                    val packageName = args.first()
                    val label = getApplicationLabel(packageName)
                    result.success(label)
                }
                ("getApplicationLaunchComponent") -> {
                    val args = call.arguments as List<String>
                    val packageName = args.first()
                    val launchComponent = getApplicationLaunchComponent(packageName)
                    result.success(launchComponent)
                }
                ("getApplicationIcon") -> {
                    val args = call.arguments as List<String>
                    val packageName = args.first()
                    val icon = getApplicationIcon(packageName)
                    result.success(icon)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, APPWIDGETS_CHANNEL, StandardMethodCodec.INSTANCE, taskQueue
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            when (call.method) {
                ("getAllApplicationWidgetIds") -> {
                    val widgetIds = getAllApplicationWidgetIds()
                    result.success(widgetIds)
                }
                ("getApplicationWidgetIds") -> {
                    val args = call.arguments as List<String>
                    val packageName = args.first()
                    val widgetIds = getApplicationWidgetIds(packageName)
                    result.success(widgetIds)
                }
                ("getApplicationId") -> {
                    val args = call.arguments as List<String>
                    val componentName = args.first()
                    val applicationId = getApplicationId(componentName)
                    if (applicationId != null) result.success(applicationId) else result.error(
                        "NOT_FOUND",
                        "Could not find provider of $componentName",
                        "Could not find provider of $componentName"
                    )
                }
                ("getAllApplicationIdsWithWidgets") -> {
                    val widgetIds = getAllApplicationIdsWithWidgets()
                    result.success(widgetIds)
                }
                ("getApplicationWidgetLabel") -> {
                    val args = call.arguments as List<String>
                    val componentName = args.first()
                    val label = getApplicationWidgetLabel(componentName)
                    if (label != null) result.success(label) else result.error(
                        "NOT_FOUND",
                        "Could not find provider of $componentName",
                        "Could not find provider of $componentName"
                    )
                }
                ("getApplicationWidgetPreview") -> {
                    val args = call.arguments as List<String>
                    val componentName = args.first()
                    val preview = getApplicationWidgetPreview(componentName)
                    if (preview != null) result.success(preview) else result.error(
                        "NOT_FOUND",
                        "Could not find provider of $componentName",
                        "Could not find provider of $componentName"
                    )
                }
                ("getApplicationWidgetSizes") -> {
                    val args = call.arguments as List<String>
                    val componentName = args.first()
                    val sizes = getApplicationWidgetSizes(componentName)
                    if (sizes != null) result.success(sizes) else result.error(
                        "NOT_FOUND",
                        "Could not find provider of $componentName",
                        "Could not find provider of $componentName"
                    )
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

    // apps
    private fun getApplicationIds(): List<String> {
        val launcherApps = getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
        val userHandle = launcherApps.profiles.first()
        val apps = launcherApps.getActivityList(null, userHandle)
        return apps.sortedBy { it.label.toString().lowercase() }
            .map { app -> app.applicationInfo.packageName }
    }

    private fun getApplicationLabel(packageName: String): String? {
        val appInfo = packageManager.getApplicationInfo(packageName, 0)
        return packageManager.getApplicationLabel(appInfo).toString()
    }

    private fun getApplicationLaunchComponent(packageName: String): String? {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        return launchIntent?.component?.className
    }

    private fun getApplicationIcon(packageName: String): ByteArray {
        val iconBmp = packageManager.getApplicationIcon(packageName).toBitmap()
        return iconBmp.convertToByteArray()
    }

    // app widgets
    private fun getAllApplicationWidgetIds(): List<String> {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val providers = appWidgetManager.installedProviders
        return providers.map { provider -> provider.provider.className }
    }

    private fun getApplicationWidgetIds(packageName: String): List<String> {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val providers = appWidgetManager.installedProviders
        return providers.filter { it.provider.packageName == packageName }
            .map { provider -> provider.provider.className }
    }

    private fun getApplicationId(providerComponentName: String): String? {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val provider =
            appWidgetManager.installedProviders.find { p: AppWidgetProviderInfo? -> p?.provider?.className == providerComponentName }
        return provider?.provider?.packageName
    }

    private fun getAllApplicationIdsWithWidgets(): List<String> {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val providers = appWidgetManager.installedProviders
        return providers.sortedBy { getApplicationLabel(it.provider.packageName)?.lowercase() }
            .map { it.provider.packageName }.toSet().toList()
    }

    private fun getApplicationWidgetLabel(providerComponentName: String): String? {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val provider =
            appWidgetManager.installedProviders.find { p: AppWidgetProviderInfo? -> p?.provider?.className == providerComponentName }
        return provider?.loadLabel(packageManager)
    }

    private fun getApplicationWidgetPreview(providerComponentName: String): ByteArray? {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val provider =
            appWidgetManager.installedProviders.find { p: AppWidgetProviderInfo? -> p?.provider?.className == providerComponentName }
        val bmp: Bitmap? = provider?.loadPreviewImage(context, DisplayMetrics.DENSITY_LOW)
            ?.toBitmap()
        if (bmp != null) {
            return bmp.convertToByteArray()
        } else {
            val bmpIcon: Bitmap? =
                provider?.loadIcon(context, DisplayMetrics.DENSITY_DEFAULT)
                    ?.toBitmap()
            if (bmpIcon != null) {
                return bmpIcon.convertToByteArray()
            }
        }
        return null
    }

    private fun getApplicationWidgetSizes(providerComponentName: String): HashMap<String, Int> {
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val provider =
            appWidgetManager.installedProviders.find { p: AppWidgetProviderInfo? -> p?.provider?.className == providerComponentName }

        val minWidth = provider?.minWidth ?: 0
        val minHeight = provider?.minHeight ?: 0
        val targetWidth =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) provider?.targetCellWidth
                ?: 0 else 0
        val targetHeight =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) provider?.targetCellHeight
                ?: 0 else 0
        val maxWidth = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) provider?.maxResizeWidth
            ?: 0 else 0
        val maxHeight =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) provider?.maxResizeHeight
                ?: 0 else 0

        return hashMapOf(
            "minWidth" to minWidth,
            "minHeight" to minHeight,
            "targetWidth" to targetWidth,
            "targetHeight" to targetHeight,
            "maxWidth" to maxWidth,
            "maxHeight" to maxHeight
        )
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
