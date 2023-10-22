import '../../../config/config.dart';
import '../../../model/source.dart';
import '../../../utils/utils.dart';

const madaraVersion = "0.1";
const madaraSourceCodeUrl =
    "$defaultExtensionPath/novel/multisrc/madara/madara-v$madaraVersion.dart";
const defaultDateFormat = "MMMM dd, yyyy";
const defaultDateFormatLocale = "en_US";

List<Source> get madaraSourcesList => _madaraSourcesList;
List<Source> _madaraSourcesList = [
  Source(
    name: "BoxNovel",
    baseUrl: "https://boxnovel.com",
    lang: "en",
    typeSource: "madara",
    iconUrl: getIconUrl("frscan", "fr"),
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "en",
    version: madaraVersion,
    sourceCodeUrl: madaraSourceCodeUrl,
  ),
];
