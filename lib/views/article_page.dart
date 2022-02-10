import 'package:flutter/material.dart';
import 'package:flutter_qiita/models/qiita_user/qiita_user.dart';
import 'package:flutter_qiita/viewModels/article_view_model.dart';
import 'package:flutter_qiita/views/article_detail_page.dart';
import 'package:flutter_qiita/views/article_search_setting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Articles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(home: ArticlesPage());
  }
}

class ArticlesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArticleSearchSettingPage(),
                  fullscreenDialog: true));
            },
            icon: Icon(Icons.search))
      ]),
      body: _Articles(),
    );
  }
}

class _Articles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(articleViewModel.notifier);
    final state = ref.watch(articleViewModel);

    if (state.articles.length == 0) {
      if (!state.hasNext) return Text('検索結果なし');
      return const LinearProgressIndicator();
    }

    return RefreshIndicator(
        child: ListView.builder(
            itemCount: state.articles.length,
            itemBuilder: (context, int index) {
              if (index == (state.articles.length - 1) && state.hasNext) {
                viewModel.getArticles();
                return const LinearProgressIndicator();
              }
              return _articleItem(context, state.articles[index]);
            }),
        onRefresh: () async {
          viewModel.refreshArticles();
        });
  }
}

Widget _articleItem(context, article) {
  return GestureDetector(
    child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0x1e333333), width: 1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _articleUser(article.user),
            SizedBox(
              height: 10.0,
            ),
            Text(article.title),
            SizedBox(
              height: 10.0,
            ),
            Wrap(
              spacing: 7.5,
              children: [
                for (int i = 0; i < article.tags.length; i++)
                  _articleTag(article.tags[i])
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            _articleCreatedAt(article.createdAt),
          ],
        )),
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArticleDetailPage(
                article: article,
              )));
    },
  );
}

Widget _articleUser(QiitaUser user) {
  final userId = user.id;
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: user.profileImageUrl != null
            ? NetworkImage(user.profileImageUrl!)
            : null,
        radius: 12.0,
        child: Text(''),
      ),
      SizedBox(width: 8.0),
      Text('@$userId'),
    ],
  );
}

Widget _articleTag(tag) {
  return GestureDetector(
      onTap: () {
        debugPrint(tag['name']);
      },
      child: Container(
        child: Text(tag['name'],
            style: TextStyle(decoration: TextDecoration.underline)),
      ));
}

Widget _articleCreatedAt(String createdAt) {
  DateFormat format = DateFormat('yyyy-MM-dd');
  String date = format.format(DateTime.parse(createdAt).toLocal());

  return Container(
    width: double.infinity,
    child: Text(
      '$dateに投稿',
      textAlign: TextAlign.right,
    ),
  );
}
