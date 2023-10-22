import '../config/config.dart';

String getIconUrl(String name, String lang) {
  return name.isEmpty
      ? ""
      : '$defaultExtensionPath/icons/mangayomi-$lang-$name.png';
}
