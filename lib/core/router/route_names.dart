class RouteNames {
  RouteNames._();

  static const welcome = '/welcome';
  static const permissions = '/permissions';
  static const search = '/search';
  static const networks = '/networks';
  static const favorites = '/favorites';
  static const profile = '/profile';

  static String linesOf(String type) =>
      '$networks/${Uri.encodeComponent(type)}';

  static String stopsOf(String type, String line) =>
      '${linesOf(type)}/${Uri.encodeComponent(line)}';
  static const hubs = '/hubs';

  static String hubOf(String id) => '$hubs/${Uri.encodeComponent(id)}';
  static String placePicker(String field) => '$search/place?field=$field';
  static const timePicker = '$search/time';
  static const preferences = '$search/preferences';
  static const results = '$search/results';
  static const roadmap = '$search/roadmap';
  static const favoritePicker = '$favorites/add';
  static const history = '/history';
}
