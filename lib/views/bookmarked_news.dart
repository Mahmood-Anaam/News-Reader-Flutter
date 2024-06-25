import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../utils/app_theme.dart';
import '../utils/db_helper.dart';
import 'news_card.dart';
import 'web_view_news.dart';

class BookmarkedNews extends StatefulWidget {
  const BookmarkedNews({super.key});

  @override
  State<BookmarkedNews> createState() => _BookmarkedNewsState();
}

class _BookmarkedNewsState extends State<BookmarkedNews> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Future<List<ArticleModel>?>? articles;

  Future<List<ArticleModel>?> _loadBookmarkedNews() async {
    final data = await DBHelper().query('articles');
    return data.map((e) => DBHelper().fromJson(e)).toList().reversed.toList();
  }

  Future<List<ArticleModel>?> _searchBookmarkedNews(String search) async {
    final data = await DBHelper().search('articles', search);
    return data.map((e) => DBHelper().fromJson(e)).toList();
  }

  @override
  void initState() {
    articles = _loadBookmarkedNews();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'BookMarked',
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      setState(() {
                        articles = _loadBookmarkedNews();
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ))
              ],
            ),
            body: FutureBuilder(
              future: articles,
              initialData: const [],
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final articlesDB = snapshot.data as List<ArticleModel>;

                  if (articlesDB.isNotEmpty) {
                    return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 4,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: TextField(
                                            focusNode: focusNode,
                                            controller: searchController,
                                            textInputAction:
                                                TextInputAction.search,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Search News"),
                                            onChanged: (val) {},
                                            onSubmitted: (value) async {
                                              String search = value.trim();
                                              if (search.isNotEmpty) {
                                                setState(() {
                                                  articles =
                                                      _searchBookmarkedNews(
                                                          search);
                                                });
                                                searchController.clear();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            color: AppColors.primaryColor,
                                            onPressed: () async {
                                              String search =
                                                  searchController.text.trim();
                                              if (search.isNotEmpty) {
                                                setState(() {
                                                  articles =
                                                      _searchBookmarkedNews(
                                                          search);
                                                });
                                                searchController.clear();
                                              }
                                            },
                                            icon: const Icon(Icons.search)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: articlesDB.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        final url = articlesDB[index].url!;
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (ctx) {
                                          return WebViewNews(newsUrl: url);
                                        }));
                                      },
                                      child: NewsCard(
                                        article: articlesDB[index],
                                        isBookmarked: true,
                                        onTap: (isBookmarked) {
                                          setState(() {
                                            articles = _loadBookmarkedNews();
                                          });
                                        },
                                      ),
                                    );
                                  })
                            ]));
                  }

                  return const Center(child: Text('Nothing Found'));
                }
              },
            )));
  }
}
