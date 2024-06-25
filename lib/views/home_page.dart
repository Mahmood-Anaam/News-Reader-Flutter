import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../models/auth_services.dart';
import '../utils/newsApi_constants.dart';
import '../models/news_controller.dart';
import 'bookmarked_news.dart';
import 'category_news.dart';
import 'news_card.dart';
import 'web_view_news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String category = "Everything News";
  String source = "BBC News";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final everythingNewsController =
        Provider.of<EverythingNewsController>(context);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'News Reader',
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      everythingNewsController.refresh();
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ))
              ],
            ),
            drawer: Drawer(
              backgroundColor: AppColors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'News Reader',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.email!,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                      ],
                    ),
                  ),
                  ExpansionTile(
                    iconColor: AppColors.primaryColor,
                    textColor: AppColors.primaryColor,
                    title: const Text("News Channels"),
                    leading: const Icon(Icons.wifi_channel),
                    subtitle: Text(
                      source,
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                    children: [
                      for (int i = 0;
                          i < NewsApiConstants.listOfNewsSource.length;
                          i++)
                        GestureDetector(
                          child: ListTile(
                            title: Text(NewsApiConstants.listOfNewsSource[i]
                                    ['name']!
                                .toUpperCase()),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                everythingNewsController.source =
                                    NewsApiConstants.listOfNewsSource[i]
                                            ['code'] ??
                                        '';
                                source = NewsApiConstants.listOfNewsSource[i]
                                        ['name'] ??
                                    '';
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  const Divider(),
                  ExpansionTile(
                      iconColor: AppColors.primaryColor,
                      title: const Text("News Category"),
                      leading: const Icon(Icons.category),
                      subtitle: Text(
                        category,
                        style: const TextStyle(color: AppColors.primaryColor),
                      ),
                      children: [
                        for (int i = 0;
                            i < NewsApiConstants.listOfCategory.length;
                            i++)
                          ListTile(
                            title: Text(
                                NewsApiConstants.listOfCategory[i]['name']!),
                            onTap: () async {
                              Navigator.pop(context);

                              final categoryNewsController =
                                  Provider.of<CategoryNewsController>(context,
                                      listen: false);
                              categoryNewsController.category =
                                  NewsApiConstants.listOfCategory[i]['Code'] ??
                                      '';
                              categoryNewsController.init();

                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return CategoryNews(
                                    title: NewsApiConstants.listOfCategory[i]
                                            ['name'] ??
                                        '');
                              }));

                              if (mounted) {
                                everythingNewsController.refresh();
                              }
                            },
                          ),
                      ]),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: const Text('BookMarked News'),
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) {
                        return const BookmarkedNews();
                      }));
                      if (mounted) {
                        everythingNewsController.refresh();
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('LogOut'),
                    onTap: ()async{
                      Navigator.pop(context);
                      await AuthServices.signOut();
                    },
                  ),
                ],
              ),
            ),
            body: Consumer<EverythingNewsController>(
                builder: (ctx, everythingNewsController, _) {
              if (everythingNewsController.state ==
                  NewsControllerState.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (everythingNewsController.state ==
                  NewsControllerState.notFount) {
                return const Center(child: Text('Nothing Found'));
              } else if (everythingNewsController.state ==
                  NewsControllerState.error) {
                return const Center(child: Text('Error'));
              }

              return SingleChildScrollView(
                  controller: everythingNewsController.scrollController,
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
                                          everythingNewsController.searchNews(
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
                                          everythingNewsController.searchNews(
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
                            (everythingNewsController.news!.articles.length) +
                                (everythingNewsController
                                    .news!.articles.isNotEmpty
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index ==
                                  everythingNewsController
                                      .news!.articles.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return InkWell(
                                onTap: () {
                                  final url = everythingNewsController
                                      .news!.articles[index].url!;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (ctx) {
                                        return WebViewNews(newsUrl: url);
                                      }));
                                },
                                child: NewsCard(
                                  article: everythingNewsController.news!.articles[index],
                                  onTap: (isBookmarked){},
                                ),
                              );
                            }),


                      ]));
            })));
  }
}
