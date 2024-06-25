import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';
import '../models/news_controller.dart';
import 'news_card.dart';
import 'web_view_news.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({super.key, required this.title});

  final String title;
  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryNewsController = Provider.of<CategoryNewsController>(context);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                    onPressed: () async {
                      categoryNewsController.refresh();
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ))
              ],
            ),
            body: Consumer<CategoryNewsController>(
                builder: (ctx, categoryNewsController, _) {
              if (categoryNewsController.state == NewsControllerState.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (categoryNewsController.state ==
                  NewsControllerState.notFount) {
                return const Center(child: Text('Nothing Found'));
              } else if (categoryNewsController.state ==
                  NewsControllerState.error) {
                return const Center(child: Text('Error'));
              }

              return SingleChildScrollView(
                  controller: categoryNewsController.scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: TextField(
                                      focusNode: focusNode,
                                      controller: searchController,
                                      textInputAction: TextInputAction.search,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Search News"),
                                      onChanged: (val) {},
                                      onSubmitted: (value) async {
                                        if (value.trim().isNotEmpty) {
                                          categoryNewsController.searchNews(
                                              urlQuery: searchController.text);
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
                                        if (searchController.text
                                            .trim()
                                            .isNotEmpty) {
                                          categoryNewsController.searchNews(
                                              urlQuery: searchController.text);
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
                            itemCount:
                                (categoryNewsController.news!.articles.length) +
                                    (categoryNewsController
                                            .news!.articles.isNotEmpty
                                        ? 1
                                        : 0),
                            itemBuilder: (context, index) {
                              if (index ==
                                  categoryNewsController
                                      .news!.articles.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return InkWell(
                                onTap: () {
                                  final url = categoryNewsController
                                      .news!.articles[index].url!;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (ctx) {
                                    return WebViewNews(newsUrl: url);
                                  }));
                                },
                                child: NewsCard(
                                  article: categoryNewsController.news!.articles[index],
                                  onTap: (isBookmarked){},
                                ),
                              );
                            })
                      ]));
            })));
  }
}
