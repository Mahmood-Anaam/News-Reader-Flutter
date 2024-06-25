import 'article_model.dart';

class NewsModel {
  NewsModel(
      {required this.status,
      required this.totalResults,
      required this.articles});

  String status;
  int totalResults;
  List<ArticleModel> articles;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles,
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final articlesJson = json['articles'] as List<dynamic>;
    List<ArticleModel> articles = [];


    for (var element in articlesJson) {
      var articleMap = element as Map<String, dynamic>;
      if ((articleMap['urlToImage'] != null &&
              (articleMap['urlToImage'] as String).isNotEmpty) &&
          (articleMap['url'] != null &&
              (articleMap['url'] as String).isNotEmpty)) {
        articles.add(ArticleModel.fromJson(articleMap));
      }
    }


    return NewsModel(
      status: json['status'],
      totalResults: json['totalResults'] ?? -1,
      articles: articles,
    );
  }
}
