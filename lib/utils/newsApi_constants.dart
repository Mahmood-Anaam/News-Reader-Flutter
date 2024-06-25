import 'package:flutter_dotenv/flutter_dotenv.dart';


class NewsApiConstants {
  NewsApiConstants._();
  static String key = dotenv.env['API_KEY'] ?? '';


  static const listOfCategory = [
    {"name": "General", "code": "general"},
    {"name": "Science", "code": "science"},
    {"name": "Business", "code": "business"},
    {"name": "Technology", "code": "technology"},
    {"name": "Sports", "code": "sports"},
    {"name": "Health", "code": "health"},
    {"name": "Entertainment", "code": "entertainment"},
  ];

  static const listOfNewsSource = [
    {"name": "BBC News", "code": "bbc-news"},
    {"name": "ABC News", "code": "abc-news"},
    {"name": "The Times of India", "code": "the-times-of-india"},
    {"name": "ESPN Cricket", "code": "espn-cric-info"},
    {"code": "politico", "name": "Politico"},
    {"code": "the-washington-post", "name": "The Washington Post"},
    {"code": "reuters", "name": "Reuters"},
    {"code": "cnn", "name": "cnn"},
    {"code": "nbc-news", "name": "NBC news"},
    {"code": "the-hill", "name": "The Hill"},
    {"code": "fox-news", "name": "Fox News"},
  ];
}


