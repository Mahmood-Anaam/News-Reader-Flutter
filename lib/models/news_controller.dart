import 'dart:convert';
import 'package:flutter/material.dart';
import 'news_model.dart';
import '../utils/newsApi_constants.dart';
import 'package:http/http.dart' as http;

enum NewsControllerState { empty, loading, success, error, notFount }

abstract class NewsController extends ChangeNotifier {
  NewsControllerState state = NewsControllerState.empty;
  NewsModel? news;
  String url = '';
  int pageSize = 5;
  int pageNum = 1;

  String _language = 'en';
  String get language => _language;
  set language(String newLanguage) {
    _language = newLanguage.isEmpty ? "en" : newLanguage;
  }

  String _country = 'us';
  String get country => _country;
  set country(String newCountry) {
    _country = newCountry.isEmpty ? "us" : newCountry;
  }

  Future<void> init() async {
    state = NewsControllerState.loading;
    notifyListeners();

    news = await fetchNews(url: url);
    if (news == null) {
      state = NewsControllerState.error;
    } else if (news!.articles.isEmpty) {
      state = NewsControllerState.notFount;
    } else {
      state = NewsControllerState.success;
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    await init();
  }

  Future<void> searchNews({required String urlQuery}) async {
    state = NewsControllerState.loading;
    notifyListeners();

    news = await fetchNews(url: urlQuery);
    if (news == null) {
      state = NewsControllerState.error;
    } else if (news!.articles.isEmpty) {
      state = NewsControllerState.notFount;
    } else {
      state = NewsControllerState.success;
    }

    notifyListeners();
  }

  Future<NewsModel?> fetchNews({required String url}) async {
    Map <String,String> headers = {'x-api-key': NewsApiConstants.key};
    http.Response response =
        await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'ok') {
        return NewsModel.fromJson(jsonData as Map<String, dynamic>);
      }
    }

    return null;
  }
}

class EverythingNewsController extends NewsController {
  ScrollController scrollController = ScrollController();
  final baseUrl = "https://newsapi.org/v2/everything";

  EverythingNewsController() {
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      state = NewsControllerState.loading;
      pageNum++;
      url = '${url.substring(0, url.length - 1)}$pageNum';
      NewsModel? newsPage = await fetchNews(url: url);
      if (newsPage != null && newsPage.articles.isNotEmpty) {
        news!.articles.addAll(newsPage.articles);
        state = NewsControllerState.success;
      } else {
        state = NewsControllerState.empty;
      }

      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  set url(String newUrl) {
    super.url = newUrl;
  }

  String _source = 'cnn';
  String get source => _source;
  set source(String newSource) {
    _source = newSource.isEmpty ? "cnn" : newSource;
    init();
  }

  @override
  Future<void> init() async {
    pageNum = 1;
    url =
        "$baseUrl?sources=$source&language=$language&pageSize=$pageSize&page=$pageNum";
    await super.init();
  }

  @override
  Future<void> refresh() async {
    pageNum = 1;
    url =
        "$baseUrl?sources=$source&language=$language&pageSize=$pageSize&page=$pageNum";
    await super.refresh();
  }

  @override
  Future<void> searchNews({required String urlQuery}) async {
    urlQuery = urlQuery.trim();
    if (urlQuery.isEmpty) return;
    pageNum = 1;
    url =
        "$baseUrl?sources=$source&language=$language&pageSize=$pageSize&q=$urlQuery&page=$pageNum";

    await super.searchNews(urlQuery: url);
  }
}

class CategoryNewsController extends NewsController {
  final baseUrl = "https://newsapi.org/v2/top-headlines";
  ScrollController scrollController = ScrollController();

  CategoryNewsController() {
    scrollController.addListener(_scrollListener);
  }

  String _category = 'science';
  String get category => _category;
  set category(String newCategory) {
    _category = newCategory.isEmpty ? "science" : newCategory;
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      state = NewsControllerState.loading;
      pageNum++;

      url = '${url.substring(0, url.length - 1)}$pageNum';

      NewsModel? newsPage = await fetchNews(url: url);
      if (newsPage != null && newsPage.articles.isNotEmpty) {
        news!.articles.addAll(newsPage.articles);
        state = NewsControllerState.success;
      } else {
        state = NewsControllerState.empty;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  set url(String newUrl) {
    super.url = newUrl;
  }

  @override
  Future<void> init() async {
    pageNum = 1;
    url =
        "$baseUrl?category=$category&language=$language&pageSize=$pageSize&page=$pageNum";
    await super.init();
  }

  @override
  Future<void> refresh() async {
    pageNum = 1;
    url =
        "$baseUrl?category=$category&language=$language&pageSize=$pageSize&page=$pageNum";
    await super.refresh();
  }

  @override
  Future<void> searchNews({required String urlQuery}) async {
    urlQuery = urlQuery.trim();
    if (urlQuery.isEmpty) return;
    pageNum = 1;
    url =
        "$baseUrl?category=$category&language=$language&pageSize=$pageSize&q=$urlQuery&page=$pageNum";

    await super.searchNews(urlQuery: url);
  }
}
