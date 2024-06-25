import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../utils/db_helper.dart';

class NewsCard extends StatefulWidget {
  final ArticleModel article;
  final bool? isBookmarked;
  final Function(bool isBookmarked)? onTap;
  const NewsCard({
    super.key,
    required this.article,
    this.isBookmarked,
    required this.onTap,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool? isBookmarked;
  late ArticleModel article;
  @override
  void initState() {
    isBookmarked = widget.isBookmarked;
    article = widget.article;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (article.urlToImage!.isNotEmpty)
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  article.urlToImage!,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  // if the image is null
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    );
                  },
                )),
          const SizedBox(height: 15.0),
          if (article.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                article.title!,
                maxLines: 2,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          if (article.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                article.description!,
                maxLines: 2,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          if (isBookmarked == null)
            FutureBuilder(
                future: DBHelper().query('articles',
                    where: 'url = ? and publishedAt = ?',
                    whereArgs: [article.url!, article.publishedAt!]),
                initialData: const [],
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    final articles =
                        snapshot.data as List<Map<String, dynamic>>;
                    isBookmarked = articles.isNotEmpty;
                    if (isBookmarked!) {
                      article.id = articles[0]["id"];
                    }

                    return Padding(
                        padding: const EdgeInsets.all(6),
                        child: Center(
                          child: IconButton(
                            icon: isBookmarked!
                                ? const Icon(Icons.bookmark)
                                : const Icon(Icons.bookmark_border),
                            onPressed: () async {
                              isBookmarked = !isBookmarked!;
                              if (isBookmarked!) {
                                Map<String, dynamic> articleMap =
                                    DBHelper().toJson(article);
                                article.id = await DBHelper()
                                    .insert('articles', articleMap);
                              } else {
                                await DBHelper()
                                    .delete('articles', article.id!);
                              }

                              setState(() {});
                              widget.onTap!(isBookmarked!);
                            },
                          ),
                        ));
                  }
                  return const SizedBox();
                }),
          if (isBookmarked != null)
            Padding(
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: IconButton(
                    icon: isBookmarked!
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_border),
                    onPressed: () async {
                      isBookmarked = !isBookmarked!;
                      if (isBookmarked!) {
                        Map<String, dynamic> articleMap =
                            DBHelper().toJson(article);
                        article.id =
                            await DBHelper().insert('articles', articleMap);
                      } else {
                        await DBHelper().delete('articles', article.id!);
                      }

                      setState(() {});
                      widget.onTap!(isBookmarked!);
                    },
                  ),
                ))
        ],
      ),
    );
  }
}
