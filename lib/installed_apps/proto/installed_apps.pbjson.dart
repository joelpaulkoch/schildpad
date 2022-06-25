///
//  Generated code. Do not modify.
//  source: lib/installed_apps/proto/installed_apps.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use appDescriptor instead')
const App$json = const {
  '1': 'App',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'packageName', '3': 2, '4': 1, '5': 9, '10': 'packageName'},
    const {
      '1': 'icon',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.schildpad.App.DrawableData',
      '10': 'icon'
    },
    const {
      '1': 'launchComponent',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'launchComponent'
    },
  ],
  '3': const [App_DrawableData$json],
};

@$core.Deprecated('Use appDescriptor instead')
const App_DrawableData$json = const {
  '1': 'DrawableData',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `App`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appDescriptor = $convert.base64Decode(
    'CgNBcHASEgoEbmFtZRgBIAEoCVIEbmFtZRIgCgtwYWNrYWdlTmFtZRgCIAEoCVILcGFja2FnZU5hbWUSLwoEaWNvbhgDIAEoCzIbLnNjaGlsZHBhZC5BcHAuRHJhd2FibGVEYXRhUgRpY29uEigKD2xhdW5jaENvbXBvbmVudBgEIAEoCVIPbGF1bmNoQ29tcG9uZW50GiIKDERyYXdhYmxlRGF0YRISCgRkYXRhGAEgASgMUgRkYXRh');
@$core.Deprecated('Use installedAppsDescriptor instead')
const InstalledApps$json = const {
  '1': 'InstalledApps',
  '2': const [
    const {
      '1': 'apps',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.schildpad.App',
      '10': 'apps'
    },
  ],
};

/// Descriptor for `InstalledApps`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List installedAppsDescriptor = $convert.base64Decode(
    'Cg1JbnN0YWxsZWRBcHBzEiIKBGFwcHMYASADKAsyDi5zY2hpbGRwYWQuQXBwUgRhcHBz');
