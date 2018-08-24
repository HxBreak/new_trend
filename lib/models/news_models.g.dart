// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => new NewsItem(
    cnBrief: json['cn_brief'] as String,
    cnTitle: json['cn_title'] as String,
    content: json['content'] as String,
    crawlTime: json['crawltime'] as String,
    enBrief: json['en_brief'] as String,
    enTitle: json['en_title'] as String,
    md5: json['md5'] as String,
    url: json['url'] as String);

abstract class _$NewsItemSerializerMixin {
  String get cnBrief;
  String get cnTitle;
  String get content;
  String get crawlTime;
  String get enBrief;
  String get enTitle;
  String get md5;
  String get url;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'cn_brief': cnBrief,
        'cn_title': cnTitle,
        'content': content,
        'crawltime': crawlTime,
        'en_brief': enBrief,
        'en_title': enTitle,
        'md5': md5,
        'url': url
      };
}
