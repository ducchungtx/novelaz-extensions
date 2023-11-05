import 'package:mangayomi/bridge_lib.dart';
import 'dart:convert';

class Madara extends MProvider {
  Madara();

  @override
  Future<MPages> getPopular(MSource source, int page) async {
    final url = "${source.baseUrl}/novel/page/$page/?m_orderby=views";
    final data = {"url": url, "sourceId": source.id};
    final res = await http('GET', json.encode(data));

    List<MNovel> novelList = [];
    final urls = xpath(res, '//*[@class^="post-title"]/h3/a/@href');
    final names = xpath(res, '//*[@id^="manga-item"]/a/@title');
    var images = xpath(res, '//*[@id^="manga-item"]/a/img/@data-src');
    if (images.isEmpty) {
      images = xpath(res, '//*[@id^="manga-item"]/a/img/@data-lazy-src');
      if (images.isEmpty) {
        images = xpath(res, '//*[@id^="manga-item"]/a/img/@srcset');
        if (images.isEmpty) {
          images = xpath(res, '//*[@id^="manga-item"]/a/img/@src');
        }
      }
    }

    for (var i = 0; i < names.length; i++) {
      MNovel novel = MNovel();
      novel.name = names[i];
      novel.imageUrl = images[i];
      novel.link = urls[i];
      novelList.add(novel);
    }

    return MPages(novelList, true);
  }

  @override
  Future<MPages> getLatestUpdates(MSource source, int page) async {
    final url = "${source.baseUrl}/manga/page/$page/?m_orderby=latest";
    final data = {"url": url, "sourceId": source.id};
    final res = await http('GET', json.encode(data));

    List<MNovel> novelList = [];
    final urls = xpath(res, '//*[@class^="post-title"]/h3/a/@href');
    final names = xpath(res, '//*[@id^="manga-item"]/a/@title');
    var images = xpath(res, '//*[@id^="manga-item"]/a/img/@data-src');
    if (images.isEmpty) {
      images = xpath(res, '//*[@id^="manga-item"]/a/img/@data-lazy-src');
      if (images.isEmpty) {
        images = xpath(res, '//*[@id^="manga-item"]/a/img/@srcset');
        if (images.isEmpty) {
          images = xpath(res, '//*[@id^="manga-item"]/a/img/@src');
        }
      }
    }

    for (var i = 0; i < names.length; i++) {
      MNovel manga = MNovel();
      manga.name = names[i];
      manga.imageUrl = images[i];
      manga.link = urls[i];
      novelList.add(manga);
    }

    return MPages(novelList, true);
  }

  @override
  Future<MPages> search(MSource source, String query, int page) async {
    final data = {
      "url": "${source.baseUrl}/?s=$query&post_type=wp-manga",
      "sourceId": source.id
    };
    final res = await http('GET', json.encode(data));

    List<MNovel> novelList = [];
    final urls = xpath(res, '//*[@class^="tab-thumb c-image-hover"]/a/@href');
    final names = xpath(res, '//*[@class^="tab-thumb c-image-hover"]/a/@title');
    var images =
        xpath(res, '//*[@class^="tab-thumb c-image-hover"]/a/img/@data-src');
    if (images.isEmpty) {
      images = xpath(
          res, '//*[@class^="tab-thumb c-image-hover"]/a/img/@data-lazy-src');
      if (images.isEmpty) {
        images =
            xpath(res, '//*[@class^="tab-thumb c-image-hover"]/a/img/@srcset');
        if (images.isEmpty) {
          images =
              xpath(res, '//*[@class^="tab-thumb c-image-hover"]/a/img/@src');
        }
      }
    }

    for (var i = 0; i < names.length; i++) {
      MNovel novel = MNovel();
      novel.name = names[i];
      novel.imageUrl = images[i];
      novel.link = urls[i];
      novelList.add(novel);
    }

    return MPages(novelList, true);
  }

  @override
  Future<MNovel> getDetail(MSource source, String url) async {
    final statusList = [
      {
        "OnGoing": 0,
        "Продолжается": 0,
        "Updating": 0,
        "Em Lançamento": 0,
        "Em lançamento": 0,
        "Em andamento": 0,
        "Em Andamento": 0,
        "En cours": 0,
        "Ativo": 0,
        "Lançando": 0,
        "Đang Tiến Hành": 0,
        "Devam Ediyor": 0,
        "Devam ediyor": 0,
        "In Corso": 0,
        "In Arrivo": 0,
        "مستمرة": 0,
        "مستمر": 0,
        "En Curso": 0,
        "En curso": 0,
        "Emision": 0,
        "En marcha": 0,
        "Publicandose": 0,
        "En emision": 0,
        "连载中": 0,
        "Completed": 1,
        "Completo": 1,
        "Completado": 1,
        "Concluído": 1,
        "Concluido": 1,
        "Finalizado": 1,
        "Terminé": 1,
        "Hoàn Thành": 1,
        "مكتملة": 1,
        "مكتمل": 1,
        "已完结": 1,
        "On Hold": 2,
        "Pausado": 2,
        "En espera": 2,
        "Canceled": 3,
        "Cancelado": 3,
      }
    ];
    MNovel novel = MNovel();
    String res = "";
    final datas = {"url": url, "sourceId": source.id};
    res = await http('GET', json.encode(datas));

    final author = querySelectorAll(res,
        selector: "div.author-content > a",
        typeElement: 0,
        attributes: "",
        typeRegExp: 0);
    if (author.isNotEmpty) {
      novel.author = author.first;
    }
    final description = querySelectorAll(res,
        selector:
            "div.description-summary div.summary__content, div.summary_content div.post-content_item > h5 + div, div.summary_content div.manga-excerpt, div.sinopsis div.contenedor, .description-summary > p",
        typeElement: 0,
        attributes: "",
        typeRegExp: 0);
    if (description.isNotEmpty) {
      novel.description = description.first;
    }
    final imageUrl = querySelectorAll(res,
        selector: "div.summary_image img",
        typeElement: 2,
        attributes: "",
        typeRegExp: 2);
    if (imageUrl.isNotEmpty) {
      novel.imageUrl = imageUrl.first;
    }
    final novelId = querySelectorAll(res,
            selector: "div[id^=manga-chapters-holder]",
            typeElement: 3,
            attributes: "data-id",
            typeRegExp: 0)
        .first;
    final status = querySelectorAll(res,
        selector: "div.summary-content",
        typeElement: 0,
        attributes: "",
        typeRegExp: 0);
    if (status.isNotEmpty) {
      novel.status = parseStatus(status.last, statusList);
    }

    novel.genre = querySelectorAll(res,
        selector: "div.genres-content a",
        typeElement: 0,
        attributes: "",
        typeRegExp: 0);

    final baseUrl = "${source.baseUrl}/";
    final headers = {
      "Referer": baseUrl,
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Requested-With": "XMLHttpRequest"
    };
    final urll =
        "${baseUrl}wp-admin/admin-ajax.php?action=manga_get_chapters&manga=$mangaId";
    final datasP = {"url": urll, "headers": headers, "sourceId": source.id};
    res = await http('POST', json.encode(datasP));
    if (res == "error") {
      final urlP = "${url}ajax/chapters";
      final datasP = {"url": urlP, "headers": headers, "sourceId": source.id};
      res = await http('POST', json.encode(datasP));
    }

    var chapUrls = xpath(res, "//li/a/@href");
    var chaptersNames = xpath(res, "//li/a/text()");
    var dateF = xpath(res, "//li/span/i/text()");
    if (dateF.isEmpty) {
      final resWebview = await getHtmlViaWebview(
          url, "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/@href");
      chapUrls = xpath(resWebview,
          "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/@href");
      chaptersNames = xpath(resWebview,
          "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/text()");
      dateF = xpath(resWebview,
          "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/span/i/text()");
    }
    var dateUploads =
        parseDates(dateF, source.dateFormat, source.dateFormatLocale);
    if (dateF.length < chaptersNames.length) {
      final length = chaptersNames.length - dateF.length;
      String date = "${DateTime.now().millisecondsSinceEpoch}";
      for (var i = 0; i < length - 1; i++) {
        date += "--..${DateTime.now().millisecondsSinceEpoch}";
      }

      final dateFF =
          parseDates(dateF, source.dateFormat, source.dateFormatLocale);
      List<String> chapterDate = date.split('--..');

      for (var date in dateFF) {
        chapterDate.add(date);
      }
      dateUploads = chapterDate;
    }

    List<MChapter>? chaptersList = [];
    for (var i = 0; i < chaptersNames.length; i++) {
      MChapter chapter = MChapter();
      chapter.name = chaptersNames[i];
      chapter.url = chapUrls[i];
      chapter.dateUpload = dateUploads[i];
      chaptersList.add(chapter);
    }
    novel.chapters = chaptersList;
    return novel;
  }

  @override
  Future<List<String>> getPageList(MSource source, String url) async {
    final datas = {"url": url, "sourceId": source.id};
    final res = await http('GET', json.encode(datas));

    final pagesSelectorRes = querySelectorAll(res,
            selector:
                "div.page-break, li.blocks-gallery-item, .reading-content, .text-left img",
            typeElement: 1,
            attributes: "",
            typeRegExp: 0)
        .first;
    final imgs = querySelectorAll(pagesSelectorRes,
        selector: "img", typeElement: 2, attributes: "", typeRegExp: 2);
    var pageUrls = [];

    if (imgs.length == 1) {
      final pages = querySelectorAll(res,
              selector: "#single-pager",
              typeElement: 2,
              attributes: "",
              typeRegExp: 0)
          .first;

      final pagesNumber = querySelectorAll(pages,
          selector: "option", typeElement: 2, attributes: "", typeRegExp: 0);

      for (var i = 0; i < pagesNumber.length; i++) {
        final val = i + 1;
        if (i.toString().length == 1) {
          pageUrls.add(querySelectorAll(pagesSelectorRes,
                  selector: "img",
                  typeElement: 2,
                  attributes: "",
                  typeRegExp: 2)
              .first
              .replaceAll("01", '0$val'));
        } else {
          pageUrls.add(querySelectorAll(pagesSelectorRes,
                  selector: "img",
                  typeElement: 2,
                  attributes: "",
                  typeRegExp: 2)
              .first
              .replaceAll("01", val.toString()));
        }
      }
    } else {
      return imgs;
    }
    return pageUrls;
  }
}

Madara main() {
  return Madara();
}
