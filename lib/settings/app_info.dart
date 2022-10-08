import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

final Widget schildpadLogo = SvgPicture.asset('assets/schildpad_logo.svg',
    semanticsLabel: 'Schildpad Logo');

final _packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

final schildpadVersionProvider = Provider<String>((ref) {
  final packageInfo = ref.watch(_packageInfoProvider);
  final version = packageInfo.maybeWhen(
      data: (packageInfo) => packageInfo.version, orElse: () => "");
  return version;
});

final schildpadAppNameProvider = Provider<String>((ref) {
  final packageInfo = ref.watch(_packageInfoProvider);
  final appName = packageInfo.maybeWhen(
      data: (packageInfo) => packageInfo.appName, orElse: () => "");
  return appName;
});
