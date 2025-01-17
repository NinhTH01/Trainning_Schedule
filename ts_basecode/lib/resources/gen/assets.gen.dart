/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/NotoSans-Bold.ttf
  String get notoSansBold => 'assets/fonts/NotoSans-Bold.ttf';

  /// File path: assets/fonts/NotoSans-Medium.ttf
  String get notoSansMedium => 'assets/fonts/NotoSans-Medium.ttf';

  /// File path: assets/fonts/NotoSans-Regular.ttf
  String get notoSansRegular => 'assets/fonts/NotoSans-Regular.ttf';

  /// List of all assets
  List<String> get values => [notoSansBold, notoSansMedium, notoSansRegular];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/clear.jpg
  AssetGenImage get clear => const AssetGenImage('assets/images/clear.jpg');

  /// File path: assets/images/cloud.jpg
  AssetGenImage get cloud => const AssetGenImage('assets/images/cloud.jpg');

  /// File path: assets/images/drizzle.jpg
  AssetGenImage get drizzle => const AssetGenImage('assets/images/drizzle.jpg');

  /// File path: assets/images/finish_marker.png
  AssetGenImage get finishMarker =>
      const AssetGenImage('assets/images/finish_marker.png');

  /// File path: assets/images/icon.jpg
  AssetGenImage get icon => const AssetGenImage('assets/images/icon.jpg');

  /// File path: assets/images/lightning.jpg
  AssetGenImage get lightning =>
      const AssetGenImage('assets/images/lightning.jpg');

  /// File path: assets/images/location_marker.png
  AssetGenImage get locationMarker =>
      const AssetGenImage('assets/images/location_marker.png');

  /// File path: assets/images/marker_left.png
  AssetGenImage get markerLeft =>
      const AssetGenImage('assets/images/marker_left.png');

  /// File path: assets/images/marker_right.png
  AssetGenImage get markerRight =>
      const AssetGenImage('assets/images/marker_right.png');

  /// File path: assets/images/normal.jpg
  AssetGenImage get normal => const AssetGenImage('assets/images/normal.jpg');

  /// File path: assets/images/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding1.png');

  /// File path: assets/images/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding2.png');

  /// File path: assets/images/onboarding3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/images/onboarding3.png');

  /// File path: assets/images/rain.jpg
  AssetGenImage get rain => const AssetGenImage('assets/images/rain.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
        clear,
        cloud,
        drizzle,
        finishMarker,
        icon,
        lightning,
        locationMarker,
        markerLeft,
        markerRight,
        normal,
        onboarding1,
        onboarding2,
        onboarding3,
        rain
      ];
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
