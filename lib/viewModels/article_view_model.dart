import 'package:flutter_qiita/repositories/article_repository.dart';
import 'package:flutter_qiita/states/articles_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final articleViewModel = StateNotifierProvider<ArticleViewModel, ArticlesState>(
    (_) => ArticleViewModel(
          ArticleRepository(),
        ));

class ArticleViewModel extends StateNotifier<ArticlesState> {
  ArticleViewModel(this.repository) : super(ArticlesState()) {
    getArticles();
  }

  final ArticleRepository repository;
  int _page = 1;
  bool _isLoading = false;

  Future<void> getArticles() async {
    if (_isLoading || !state.hasNext) {
      return;
    }
    _isLoading = true;

    final articles = await repository.fetchArticles(_page, state.keyword);
    final newArticles = [...state.articles, ...articles];

    if (articles.length % 20 != 0 || articles.length == 0) {
      state = state.copyWith(hasNext: false);
    }

    state = state.copyWith(articles: newArticles);
    _page++;
    _isLoading = false;
  }

  Future<void> setQuery(String keyword) async {
    state = state.copyWith(articles: [], keyword: keyword, hasNext: true);
    _page = 1;
  }

  Future<void> refreshArticles() async {
    state = state.copyWith(articles: [], hasNext: true);
    _page = 1;
    getArticles();
  }
}
