import 'article_subcontent.dart';

/// Data class for Article content
///
/// Contains a [List] of subcontent for the article and article title
class Article {
  const Article({
    required this.title,
    required this.author,
    required this.articleTime,
    required this.subContent,
  });

  final String title;
  final String author;
  final Duration articleTime;
  final List<ArticleSubcontent> subContent;
}
