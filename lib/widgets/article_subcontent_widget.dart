import '../models/article_subcontent.dart';
import '../utils/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ArticleSubcontentWidget extends StatefulWidget {
  const ArticleSubcontentWidget({super.key, required this.articleSubcontent, required this.contentKey});

  final ArticleSubcontent articleSubcontent;
  final GlobalKey contentKey;

  @override
  State<ArticleSubcontentWidget> createState() => _ArticleSubcontentWidgetState();
}

class _ArticleSubcontentWidgetState extends State<ArticleSubcontentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.contentKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // -- Heading
        Text(widget.articleSubcontent.heading, style: AppTextStyles.contentHeading),

        // -- Body
        Text(widget.articleSubcontent.body, style: AppTextStyles.bodyLarge),
      ],
    );
  }
}
