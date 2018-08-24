import 'package:json_annotation/json_annotation.dart';

part 'news_models.g.dart';

@JsonSerializable()
class NewsItem extends Object with _$NewsItemSerializerMixin {
  @JsonKey(name: "cn_brief")
  String cnBrief;
  @JsonKey(name: "cn_title")
  String cnTitle;
  String content;
  @JsonKey(name: "crawltime")
  String crawlTime;
  @JsonKey(name: "en_brief")
  String enBrief;
  @JsonKey(name: "en_title")
  String enTitle;
  String md5;
  String url;

  NewsItem(
      {this.cnBrief,
      this.cnTitle,
      this.content,
      this.crawlTime,
      this.enBrief,
      this.enTitle,
      this.md5,
      this.url});

  factory NewsItem.fromJson(Map<String, dynamic> json) =>
      _$NewsItemFromJson(json);

  @override
  String toString() {
    return 'NewsItem{cnBrief: $cnBrief, cnTitle: $cnTitle, content: $content, crawlTime: $crawlTime, enBrief: $enBrief, enTitle: $enTitle, md5: $md5, url: $url}';
  }
}
