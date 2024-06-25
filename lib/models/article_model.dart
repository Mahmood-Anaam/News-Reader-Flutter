import 'source_model.dart';

class ArticleModel {
  ArticleModel(
      {this.id,
      required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

   int? id;
  String? author, description, urlToImage, content;
  String? title, url, publishedAt;
  SourceModel? source;

  Map<String, dynamic> toJson() {
    return {
      if(id!=null)
      'id': id,
      'author': author,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'title': title,
      'url': url,
      'publishedAt': publishedAt,
      'source': source,
    };
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      source: SourceModel.fromJson(json['source'] as Map<String, dynamic>),
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
