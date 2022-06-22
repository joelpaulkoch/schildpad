package app.schildpad.schildpad

import android.appwidget.AppWidgetManager
import android.content.Context
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

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            APPS_CHANNEL
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
            flutterEngine.dartExecutor.binaryMessenger,
            APPWIDGETS_CHANNEL
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            if (call.method == "getInstalledAppWidgets") {
                val widgets = getInstalledAppWidgets()
                result.success(widgets.toByteArray())
            } else {
                result.notImplemented()
            }
        }

    }

    private fun getInstalledApps(): InstalledApps {
        val appInfos = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
            .filter { it.enabled }
            .filter { (it.flags and ApplicationInfo.FLAG_SYSTEM) == 0 }

        val installedApps = installedApps {
            for (appInfo in appInfos) {

                val app = app {
                    name = appInfo.loadLabel(packageManager).toString()
                    packageName = appInfo.packageName

                    icon = AppKt.drawableData {
                        val bmp: Bitmap? =
                            appInfo.loadIcon(packageManager).toBitmap()
                        if (bmp != null) {
                            data = ByteString.copyFrom(bmp.convertToByteArray())
                        }
                    }
                }
                apps += app
            }
        }
        return installedApps
    }

    private fun getInstalledAppWidgets(): InstalledAppWidgets {
        // TODO test sdk version
        val appWidgetManager = getSystemService(Context.APPWIDGET_SERVICE) as AppWidgetManager
        val providers = appWidgetManager.installedProviders

        val installedAppWidgets = installedAppWidgets {
            for (provider in providers) {

                val widget = appWidget {
                    packageName = provider.provider.packageName
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

    private fun Bitmap.convertToByteArray(): ByteArray {
        val byteArrayOS = ByteArrayOutputStream()
        this.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOS)
        return byteArrayOS.toByteArray()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra(
            "background_mode",
            FlutterActivityLaunchConfigs.BackgroundMode.transparent.toString()
        )
        super.onCreate(savedInstanceState)
    }
}
