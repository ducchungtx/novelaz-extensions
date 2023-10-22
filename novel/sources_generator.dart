import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../model/source.dart';
import 'multisrc/madara/sources.dart';

void main() {
  List<Source> _sourcesList = [
    ...madaraSourcesList,
  ];
  final List<Map<String, dynamic>> jsonList =
      _sourcesList.map((source) => source.toJson()).toList();
  final jsonString = jsonEncode(jsonList);

  final file = File('index.json');
  file.writeAsStringSync(jsonString);

  log('JSON file created: ${file.path}');
}
