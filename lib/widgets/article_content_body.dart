import 'package:flutter/material.dart';

import '../models/article_subcontent.dart';
import '../utils/constants/breakpoint.dart';
import '../utils/theme/app_text_styles.dart';
import 'article_subcontent_widget.dart';

class ArticleContentList extends StatelessWidget {
  const ArticleContentList({
    super.key,
    required this.scrollController,
    required this.subContentKeys,
    required this.articleTitle,
    required this.subContent,
  });

  final ScrollController scrollController;
  final String articleTitle;
  final List<ArticleSubcontent> subContent;
  final List<GlobalKey> subContentKeys;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kTwentyFour, vertical: 8),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // -- Title
                Text(articleTitle, style: AppTextStyles.heading),
                const SizedBox(height: 36),

                // -- Sub content
                ...List<Widget>.generate(subContent.length, (int i) {
                  return ArticleSubcontentWidget(contentKey: subContentKeys[i], articleSubcontent: subContent[i]);
                }),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
