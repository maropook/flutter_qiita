import 'package:flutter_qiita/models/qiita_user/qiita_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qiita_article.freezed.dart';
part 'qiita_article.g.dart';

@freezed
class QiitaArticle with _$QiitaArticle {
  factory QiitaArticle({
    String? title,
    String? url,
    QiitaUser? user,
    List? tags,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _QiitaArticle;

  factory QiitaArticle.fromJson(Map<String, dynamic> json) =>
      _$QiitaArticleFromJson(json);
}
