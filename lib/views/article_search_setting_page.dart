import 'package:flutter/material.dart';
import 'package:flutter_qiita/viewModels/article_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleSearchSettingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(articleViewModel.notifier);
    final state = ref.watch(articleViewModel);
    return Scaffold(
      appBar: AppBar(title: Text('検索')),
      body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(children: [
            TextFormField(
              controller: TextEditingController(text: state.keyword),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(hintText: 'キーワード'),
              onFieldSubmitted: (value) async {
                await viewModel.setQuery(value);
                viewModel.getArticles();
                Navigator.of(context).pop();
              },
            )
          ])),
    );
  }
}
