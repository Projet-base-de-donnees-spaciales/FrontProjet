part of 'tile_layer.dart';

typedef TemplateFunction = String Function(
    String str, Map<String, String> data);

enum EvictErrorTileStrategy {
  // never evict error Tiles
  none,
  // evict error Tiles during _pruneTiles / _abortLoading calls
  dispose,
  // evict error Tiles which are not visible anymore but respect margin (see keepBuffer option)
  // (Tile's zoom level not equals current _tileZoom or Tile is out of viewport)
  notVisibleRespectMargin,
  // evict error Tiles which are not visible anymore
  // (Tile's zoom level not equals current _tileZoom or Tile is out of viewport)
  notVisible,
}

typedef ErrorTileCallBack = void Function(Tile tile, dynamic error);

class WMSTileLayerOptions {
  final service = 'WMS';
  final request = 'GetMap';

  /// WMS service's URL, for example 'http://ows.mundialis.de/services/service?'
  final String baseUrl;

  /// List of WMS layers to show
  final List<String> layers;

  /// List of WMS styles
  final List<String> styles;

  /// WMS image format (use 'image/png' for layers with transparency)
  final String format;

  /// Version of the WMS service to use
  final String version;

  /// Whether to make tiles transparent
  final bool transparent;

  /// Encode boolean values as uppercase in request
  final bool uppercaseBoolValue;

  /// Sets map projection standard
  final Crs crs;

  /// Other request parameters
  final Map<String, String> otherParameters;

  late final String _encodedBaseUrl;

  late final double _versionNumber;

  WMSTileLayerOptions({
    required this.baseUrl,
    this.layers = const [],
    this.styles = const [],
    this.format = 'image/png',
    this.version = '1.1.1',
    this.transparent = true,
    this.uppercaseBoolValue = false,
    this.crs = const Epsg3857(),
    this.otherParameters = const {},
  }) {
    _versionNumber = double.tryParse(version.split('.').take(2).join('.')) ?? 0;
    _encodedBaseUrl = _buildEncodedBaseUrl();
  }

  String _buildEncodedBaseUrl() {
    final projectionKey = _versionNumber >= 1.3 ? 'crs' : 'srs';
    final buffer = StringBuffer(baseUrl)
      ..write('&service=$service')
      ..write('&request=$request')
      ..write('&layers=${layers.map(Uri.encodeComponent).join(',')}')
      ..write('&styles=${styles.map(Uri.encodeComponent).join(',')}')
      ..write('&format=${Uri.encodeComponent(format)}')
      ..write('&$projectionKey=${Uri.encodeComponent(crs.code)}')
      ..write('&version=${Uri.encodeComponent(version)}')
      ..write(
          '&transparent=${uppercaseBoolValue ? transparent.toString().toUpperCase() : transparent}');
    otherParameters
        .forEach((k, v) => buffer.write('&$k=${Uri.encodeComponent(v)}'));
    return buffer.toString();
  }

  String getUrl(Coords coords, int tileSize, bool retinaMode) {
    final tileSizePoint = CustomPoint(tileSize, tileSize);
    final nvPoint = coords.scaleBy(tileSizePoint);
    final sePoint = nvPoint + tileSizePoint;
    final nvCoords = crs.pointToLatLng(nvPoint, coords.z as double)!;
    final seCoords = crs.pointToLatLng(sePoint, coords.z as double)!;
    final nv = crs.projection.project(nvCoords);
    final se = crs.projection.project(seCoords);
    final bounds = Bounds(nv, se);
    final bbox = (_versionNumber >= 1.3 && crs is Epsg4326)
        ? [bounds.min.y, bounds.min.x, bounds.max.y, bounds.max.x]
        : [bounds.min.x, bounds.min.y, bounds.max.x, bounds.max.y];

    final buffer = StringBuffer(_encodedBaseUrl);
    buffer.write('&width=${retinaMode ? tileSize * 2 : tileSize}');
    buffer.write('&height=${retinaMode ? tileSize * 2 : tileSize}');
    buffer.write('&bbox=${bbox.join(',')}');
    return buffer.toString();
  }
}
