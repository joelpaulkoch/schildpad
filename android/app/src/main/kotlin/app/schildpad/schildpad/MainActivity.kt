package app.schildpad.schildpad

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", FlutterActivityLaunchConfigs.BackgroundMode.transparent.toString())
        super.onCreate(savedInstanceState)
    }
}
