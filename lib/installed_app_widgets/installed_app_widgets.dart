import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schildpad/installed_app_widgets/proto/installed_app_widgets.pb.dart';

final installedAppWidgetsProvider =
    FutureProvider<InstalledAppWidgets>((ref) async {
  const platform = MethodChannel('schildpad.schildpad.app/appwidgets');
  final Uint8List result =
      await platform.invokeMethod('getInstalledAppWidgets');
  return InstalledAppWidgets.fromBuffer(result);
});
