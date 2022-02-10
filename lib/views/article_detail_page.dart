import 'package:flutter/material.dart';
import 'package:flutter_qiita/models/qiita_article/qiita_article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetailPage extends StatelessWidget {
  ArticleDetailPage({required this.article});
  final QiitaArticle? article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(article!.title ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13))),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              initialUrl: article?.url,
              javascriptMode: JavascriptMode.unrestricted,
            ))
          ],
        ));
  }
}
