///
import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use appWidgetDescriptor instead')
const AppWidget$json = const {
  '1': 'AppWidget',
  '2': const [
    const {'1': 'packageName', '3': 1, '4': 1, '5': 9, '10': 'packageName'},
    const {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {
      '1': 'icon',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.schildpad.AppWidget.DrawableData',
      '10': 'icon'
    },
    const {
      '1': 'preview',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.schildpad.AppWidget.DrawableData',
      '10': 'preview'
    },
    const {'1': 'targetWidth', '3': 7, '4': 1, '5': 5, '10': 'targetWidth'},
    const {'1': 'targetHeight', '3': 8, '4': 1, '5': 5, '10': 'targetHeight'},
    const {'1': 'minWidth', '3': 9, '4': 1, '5': 5, '10': 'minWidth'},
    const {'1': 'minHeight', '3': 10, '4': 1, '5': 5, '10': 'minHeight'},
  ],
  '3': const [AppWidget_DrawableData$json],
};

@$core.Deprecated('Use appWidgetDescriptor instead')
const AppWidget_DrawableData$json = const {
  '1': 'DrawableData',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `AppWidget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appWidgetDescriptor = $convert.base64Decode(
    'CglBcHBXaWRnZXQSIAoLcGFja2FnZU5hbWUYASABKAlSC3BhY2thZ2VOYW1lEhQKBWxhYmVsGAIgASgJUgVsYWJlbBIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SNQoEaWNvbhgEIAEoCzIhLnNjaGlsZHBhZC5BcHBXaWRnZXQuRHJhd2FibGVEYXRhUgRpY29uEjsKB3ByZXZpZXcYBiABKAsyIS5zY2hpbGRwYWQuQXBwV2lkZ2V0LkRyYXdhYmxlRGF0YVIHcHJldmlldxIgCgt0YXJnZXRXaWR0aBgHIAEoBVILdGFyZ2V0V2lkdGgSIgoMdGFyZ2V0SGVpZ2h0GAggASgFUgx0YXJnZXRIZWlnaHQSGgoIbWluV2lkdGgYCSABKAVSCG1pbldpZHRoEhwKCW1pbkhlaWdodBgKIAEoBVIJbWluSGVpZ2h0GiIKDERyYXdhYmxlRGF0YRISCgRkYXRhGAEgASgMUgRkYXRh');
@$core.Deprecated('Use installedAppWidgetsDescriptor instead')
const InstalledAppWidgets$json = const {
  '1': 'InstalledAppWidgets',
  '2': const [
    const {
      '1': 'appWidgets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.schildpad.AppWidget',
      '10': 'appWidgets'
    },
  ],
};

/// Descriptor for `InstalledAppWidgets`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List installedAppWidgetsDescriptor = $convert.base64Decode(
    'ChNJbnN0YWxsZWRBcHBXaWRnZXRzEjQKCmFwcFdpZGdldHMYASADKAsyFC5zY2hpbGRwYWQuQXBwV2lkZ2V0UgphcHBXaWRnZXRz');
