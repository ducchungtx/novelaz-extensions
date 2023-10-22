import 'dart:convert';
import 'package:bridge_lib/bridge_lib.dart';

getPopularManga(MangaModel manga) async {
  final url = "${manga.baseUrl}/manga/page/${manga.page}/?m_orderby=views";
  final data = {"url": url, "sourceId": manga.sourceId};
  final res = await MBridge.http('GET', json.encode(data));
  if (res.isEmpty) {
    return manga;
  }
  manga.urls = MBridge.xpath(res, '//*[@class^="post-title"]/h3/a/@href');
  var images = MBridge.xpath(res, '//*[@id^="manga-item"]/a/img/@data-src');
  if (images.isEmpty) {
    images = MBridge.xpath(res, '//*[@id^="manga-item"]/a/img/@data-lazy-src');
    if (images.isEmpty) {
      images = MBridge.xpath(res, '//*[@id^="manga-item"]/a/img/@srcset');
      if (images.isEmpty) {
        images = MBridge.xpath(res, '//*[@id^="manga-item"]/a/img/@src');
      }
    }
  }
  manga.images = images;
  manga.names = MBridge.xpath(res, '//*[@id^="manga-item"]/a/@title');

  return manga;
}
