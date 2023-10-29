import 'dart:convert';
import 'package:bridge_lib/bridge_lib.dart';

getPopularNovel(MNovel novel) async {
  final url = "${novel.baseUrl}/novel/page/${novel.page}/?m_orderby=views";
  final data = {"url": url, "sourceId": novel.sourceId};
  final res = await MBridge.http('GET', json.encode(data));
  if (res.hasError) {
    return novel;
  }
  novel.urls = MBridge.xpath(res, '//*[@class^="post-title"]/h3/a/@href');
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
  novel.images = images;
  novel.names = MBridge.xpath(res, '//*[@id^="manga-item"]/a/@title');

  return novel;
}
