///
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AppWidget_DrawableData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'AppWidget.DrawableData',
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

  AppWidget_DrawableData._() : super();
  factory AppWidget_DrawableData({
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory AppWidget_DrawableData.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AppWidget_DrawableData.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AppWidget_DrawableData clone() =>
      AppWidget_DrawableData()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AppWidget_DrawableData copyWith(
          void Function(AppWidget_DrawableData) updates) =>
      super.copyWith((message) => updates(message as AppWidget_DrawableData))
          as AppWidget_DrawableData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AppWidget_DrawableData create() => AppWidget_DrawableData._();
  AppWidget_DrawableData createEmptyInstance() => create();
  static $pb.PbList<AppWidget_DrawableData> createRepeated() =>
      $pb.PbList<AppWidget_DrawableData>();
  @$core.pragma('dart2js:noInline')
  static AppWidget_DrawableData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppWidget_DrawableData>(create);
  static AppWidget_DrawableData? _defaultInstance;

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

class AppWidget extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'AppWidget',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'schildpad'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'packageName',
        protoName: 'packageName')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'componentName',
        protoName: 'componentName')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'description')
    ..aOM<AppWidget_DrawableData>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'icon',
        subBuilder: AppWidget_DrawableData.create)
    ..aOM<AppWidget_DrawableData>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preview',
        subBuilder: AppWidget_DrawableData.create)
    ..a<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'targetWidth',
        $pb.PbFieldType.O3,
        protoName: 'targetWidth')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'targetHeight',
        $pb.PbFieldType.O3,
        protoName: 'targetHeight')
    ..a<$core.int>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'minWidth',
        $pb.PbFieldType.O3,
        protoName: 'minWidth')
    ..a<$core.int>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'minHeight',
        $pb.PbFieldType.O3,
        protoName: 'minHeight')
    ..hasRequiredFields = false;

  AppWidget._() : super();
  factory AppWidget({
    $core.String? packageName,
    $core.String? componentName,
    $core.String? label,
    $core.String? description,
    AppWidget_DrawableData? icon,
    AppWidget_DrawableData? preview,
    $core.int? targetWidth,
    $core.int? targetHeight,
    $core.int? minWidth,
    $core.int? minHeight,
  }) {
    final _result = create();
    if (packageName != null) {
      _result.packageName = packageName;
    }
    if (componentName != null) {
      _result.componentName = componentName;
    }
    if (label != null) {
      _result.label = label;
    }
    if (description != null) {
      _result.description = description;
    }
    if (icon != null) {
      _result.icon = icon;
    }
    if (preview != null) {
      _result.preview = preview;
    }
    if (targetWidth != null) {
      _result.targetWidth = targetWidth;
    }
    if (targetHeight != null) {
      _result.targetHeight = targetHeight;
    }
    if (minWidth != null) {
      _result.minWidth = minWidth;
    }
    if (minHeight != null) {
      _result.minHeight = minHeight;
    }
    return _result;
  }
  factory AppWidget.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AppWidget.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AppWidget clone() => AppWidget()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AppWidget copyWith(void Function(AppWidget) updates) =>
      super.copyWith((message) => updates(message as AppWidget))
          as AppWidget; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AppWidget create() => AppWidget._();
  AppWidget createEmptyInstance() => create();
  static $pb.PbList<AppWidget> createRepeated() => $pb.PbList<AppWidget>();
  @$core.pragma('dart2js:noInline')
  static AppWidget getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppWidget>(create);
  static AppWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packageName => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPackageName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get componentName => $_getSZ(1);

  @$pb.TagNumber(2)
  set componentName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasComponentName() => $_has(1);

  @$pb.TagNumber(2)
  void clearComponentName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);

  @$pb.TagNumber(3)
  set label($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);

  @$pb.TagNumber(3)
  void clearLabel() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);

  @$pb.TagNumber(4)
  set description($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);

  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  AppWidget_DrawableData get icon => $_getN(4);

  @$pb.TagNumber(5)
  set icon(AppWidget_DrawableData v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasIcon() => $_has(4);

  @$pb.TagNumber(5)
  void clearIcon() => clearField(5);

  @$pb.TagNumber(5)
  AppWidget_DrawableData ensureIcon() => $_ensure(4);

  @$pb.TagNumber(6)
  AppWidget_DrawableData get preview => $_getN(5);

  @$pb.TagNumber(6)
  set preview(AppWidget_DrawableData v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPreview() => $_has(5);

  @$pb.TagNumber(6)
  void clearPreview() => clearField(6);

  @$pb.TagNumber(6)
  AppWidget_DrawableData ensurePreview() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get targetWidth => $_getIZ(6);
  @$pb.TagNumber(7)
  set targetWidth($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTargetWidth() => $_has(6);

  @$pb.TagNumber(7)
  void clearTargetWidth() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get targetHeight => $_getIZ(7);
  @$pb.TagNumber(8)
  set targetHeight($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasTargetHeight() => $_has(7);

  @$pb.TagNumber(8)
  void clearTargetHeight() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get minWidth => $_getIZ(8);
  @$pb.TagNumber(9)
  set minWidth($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasMinWidth() => $_has(8);

  @$pb.TagNumber(9)
  void clearMinWidth() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get minHeight => $_getIZ(9);
  @$pb.TagNumber(10)
  set minHeight($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasMinHeight() => $_has(9);

  @$pb.TagNumber(10)
  void clearMinHeight() => clearField(10);
}

class InstalledAppWidgets extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'InstalledAppWidgets',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'schildpad'),
      createEmptyInstance: create)
    ..pc<AppWidget>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'appWidgets',
        $pb.PbFieldType.PM,
        protoName: 'appWidgets',
        subBuilder: AppWidget.create)
    ..hasRequiredFields = false;

  InstalledAppWidgets._() : super();
  factory InstalledAppWidgets({
    $core.Iterable<AppWidget>? appWidgets,
  }) {
    final _result = create();
    if (appWidgets != null) {
      _result.appWidgets.addAll(appWidgets);
    }
    return _result;
  }
  factory InstalledAppWidgets.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory InstalledAppWidgets.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  InstalledAppWidgets clone() => InstalledAppWidgets()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  InstalledAppWidgets copyWith(void Function(InstalledAppWidgets) updates) =>
      super.copyWith((message) => updates(message as InstalledAppWidgets))
          as InstalledAppWidgets; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static InstalledAppWidgets create() => InstalledAppWidgets._();
  InstalledAppWidgets createEmptyInstance() => create();
  static $pb.PbList<InstalledAppWidgets> createRepeated() =>
      $pb.PbList<InstalledAppWidgets>();
  @$core.pragma('dart2js:noInline')
  static InstalledAppWidgets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InstalledAppWidgets>(create);
  static InstalledAppWidgets? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AppWidget> get appWidgets => $_getList(0);
}
