import 'package:webfeed/domain/media/media.dart';

class MRssItem {
  String rssName;
  String rssIcon;

  String title;
  String author;
  String description;
  String link;
  DateTime pubDate;
  Media media;

  MRssItem(
      {this.rssName,
      this.rssIcon,
      this.title,
      this.author,
      this.description,
      this.link,
      this.pubDate,
      this.media});
}
