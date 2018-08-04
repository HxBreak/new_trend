import 'dart:convert' show json;

class NewsItem {
  String cn_brief;
  String cn_title;
  String content;
  String crawltime;
  String en_brief;
  String en_title;
  String md5;
  String url;

  NewsItem.fromParams(
      {this.cn_brief,
      this.cn_title,
      this.content,
      this.crawltime,
      this.en_brief,
      this.en_title,
      this.md5,
      this.url});

  factory NewsItem(jsonStr) => jsonStr is String
      ? NewsItem.fromJson(json.decode(jsonStr))
      : NewsItem.fromJson(jsonStr);

  NewsItem.fromJson(jsonRes) {
    cn_brief = jsonRes['cn_brief'];
    cn_title = jsonRes['cn_title'];
    content = jsonRes['content'];
    crawltime = jsonRes['crawltime'];
    en_brief = jsonRes['en_brief'];
    en_title = jsonRes['en_title'];
    md5 = jsonRes['md5'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return '{"cn_brief": ${cn_brief != null?'${json.encode(cn_brief)}':'null'},"cn_title": ${cn_title != null?'${json.encode(cn_title)}':'null'},"content": ${content != null?'${json.encode(content)}':'null'},"crawltime": ${crawltime != null?'${json.encode(crawltime)}':'null'},"en_brief": ${en_brief != null?'${json.encode(en_brief)}':'null'},"en_title": ${en_title != null?'${json.encode(en_title)}':'null'},"md5": ${md5 != null?'${json.encode(md5)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'}}';
  }
}
