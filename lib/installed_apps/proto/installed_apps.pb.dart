///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class App_DrawableData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'App.DrawableData',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'schildpad'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  App_DrawableData._() : super();

  factory App_DrawableData({
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }

  factory App_DrawableData.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory App_DrawableData.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  App_DrawableData clone() => App_DrawableData()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  App_DrawableData copyWith(void Function(App_DrawableData) updates) =>
      super.copyWith((message) => updates(message as App_DrawableData))
          as App_DrawableData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static App_DrawableData create() => App_DrawableData._();

  App_DrawableData createEmptyInstance() => create();

  static $pb.PbList<App_DrawableData> createRepeated() =>
      $pb.PbList<App_DrawableData>();

  @$core.pragma('dart2js:noInline')
  static App_DrawableData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<App_DrawableData>(create);
  static App_DrawableData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);

  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);

  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class App extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'App',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'schildpad'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'packageName',
        protoName: 'packageName')
    ..aOM<App_DrawableData>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'icon',
        subBuilder: App_DrawableData.create)
    ..hasRequiredFields = false;

  App._() : super();

  factory App({
    $core.String? name,
    $core.String? packageName,
    App_DrawableData? icon,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (packageName != null) {
      _result.packageName = packageName;
    }
    if (icon != null) {
      _result.icon = icon;
    }
    return _result;
  }

  factory App.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory App.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  App clone() => App()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  App copyWith(void Function(App) updates) =>
      super.copyWith((message) => updates(message as App))
          as App; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static App create() => App._();

  App createEmptyInstance() => create();

  static $pb.PbList<App> createRepeated() => $pb.PbList<App>();

  @$core.pragma('dart2js:noInline')
  static App getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<App>(create);
  static App? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);

  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);

  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get packageName => $_getSZ(1);

  @$pb.TagNumber(2)
  set packageName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPackageName() => $_has(1);

  @$pb.TagNumber(2)
  void clearPackageName() => clearField(2);

  @$pb.TagNumber(3)
  App_DrawableData get icon => $_getN(2);

  @$pb.TagNumber(3)
  set icon(App_DrawableData v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);

  @$pb.TagNumber(3)
  void clearIcon() => clearField(3);

  @$pb.TagNumber(3)
  App_DrawableData ensureIcon() => $_ensure(2);
}

class InstalledApps extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InstalledApps',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'schildpad'),
      createEmptyInstance: create)
    ..pc<App>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'apps',
        $pb.PbFieldType.PM,
        subBuilder: App.create)
    ..hasRequiredFields = false;

  InstalledApps._() : super();

  factory InstalledApps({
    $core.Iterable<App>? apps,
  }) {
    final _result = create();
    if (apps != null) {
      _result.apps.addAll(apps);
    }
    return _result;
  }

  factory InstalledApps.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory InstalledApps.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InstalledApps clone() => InstalledApps()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InstalledApps copyWith(void Function(InstalledApps) updates) =>
      super.copyWith((message) => updates(message as InstalledApps))
          as InstalledApps; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InstalledApps create() => InstalledApps._();

  InstalledApps createEmptyInstance() => create();

  static $pb.PbList<InstalledApps> createRepeated() =>
      $pb.PbList<InstalledApps>();

  @$core.pragma('dart2js:noInline')
  static InstalledApps getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InstalledApps>(create);
  static InstalledApps? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<App> get apps => $_getList(0);
}
