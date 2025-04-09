// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsStore on _NewsStore, Store {
  late final _$newsListAtom =
      Atom(name: '_NewsStore.newsList', context: context);

  @override
  ObservableList<News> get newsList {
    _$newsListAtom.reportRead();
    return super.newsList;
  }

  @override
  set newsList(ObservableList<News> value) {
    _$newsListAtom.reportWrite(value, super.newsList, () {
      super.newsList = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_NewsStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$loadNewsAsyncAction =
      AsyncAction('_NewsStore.loadNews', context: context);

  @override
  Future<void> loadNews() {
    return _$loadNewsAsyncAction.run(() => super.loadNews());
  }

  late final _$_NewsStoreActionController =
      ActionController(name: '_NewsStore', context: context);

  @override
  void addNews(News news) {
    final _$actionInfo =
        _$_NewsStoreActionController.startAction(name: '_NewsStore.addNews');
    try {
      return super.addNews(news);
    } finally {
      _$_NewsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
newsList: ${newsList},
isLoading: ${isLoading}
    ''';
  }
}
