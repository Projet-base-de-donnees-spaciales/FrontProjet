import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

typedef TileReady = void Function(
    Coords<double> coords, dynamic error, Tile tile);

class Tile {
  final Coords<double> coords;
  final CustomPoint<num> tilePos;
  ImageProvider imageProvider;

  bool current;
  bool retain;
  bool active;
  bool loadError;
  DateTime? loaded;
  late DateTime loadStarted;

  final AnimationController? animationController;

  double get opacity => animationController == null
      ? (active ? 1.0 : 0.0)
      : animationController!.value;

  // callback when tile is ready / error occurred
  // it maybe be null for instance when download aborted
  TileReady? tileReady;
  ImageInfo? imageInfo;
  ImageStream? _imageStream;
  late ImageStreamListener _listener;

  Tile({
    required this.coords,
    required this.tilePos,
    required this.imageProvider,
    required final TickerProvider vsync,
    this.tileReady,
    this.current = false,
    this.active = false,
    this.retain = false,
    this.loadError = false,
    final Duration? duration,
  }) : animationController = duration != null
            ? AnimationController(duration: duration, vsync: vsync)
            : null {
    animationController?.addStatusListener(_onAnimateEnd);
  }

  void loadTileImage() {
    loadStarted = DateTime.now();

    try {
      final oldImageStream = _imageStream;
      _imageStream = imageProvider.resolve(ImageConfiguration.empty);

      if (_imageStream!.key != oldImageStream?.key) {
        oldImageStream?.removeListener(_listener);

        _listener = ImageStreamListener(_tileOnLoad, onError: _tileOnError);
        _imageStream!.addListener(_listener);
      }
    } catch (e, s) {
      // make sure all exception is handled - #444 / #536
      _tileOnError(e, s);
    }
  }

  // call this before GC!
  void dispose([bool evict = false]) {
    if (evict) {
      try {
        imageProvider.evict().catchError((Object e) {
          debugPrint(e.toString());
        });
      } catch (e) {
        // this may be never called because catchError will handle errors, however
        // we want to avoid random crashes like in #444 / #536
        debugPrint(e.toString());
      }
    }

    animationController?.removeStatusListener(_onAnimateEnd);
    animationController?.dispose();
    _imageStream?.removeListener(_listener);
  }

  void startFadeInAnimation({double? from}) {
    animationController?.reset();
    animationController?.forward(from: from);
  }

  void _onAnimateEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      active = true;
    }
  }

  void _tileOnLoad(ImageInfo imageInfo, bool synchronousCall) {
    if (tileReady != null) {
      this.imageInfo = imageInfo;
      tileReady!(coords, null, this);
    }
  }

  void _tileOnError(dynamic exception, StackTrace? stackTrace) {
    if (tileReady != null) {
      tileReady!(
          coords, exception ?? 'Unknown exception during loadTileImage', this);
    }
  }

  String get coordsKey => coords.key;

  double zIndex(double maxZoom, double currentZoom) =>
      maxZoom - (currentZoom - coords.z).abs();

  @override
  int get hashCode => coords.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Tile && coords == other.coords;
  }
}
