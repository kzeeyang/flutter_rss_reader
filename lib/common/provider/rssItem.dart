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

  MRssItem.fromJson(Map<String, dynamic> json) {
    rssName = json['rssName'];
    rssIcon = json['rssIcon'];
    title = json['title'];
    author = json['author'];
    description = json['description'];
    link = json['link'];
    pubDate = json['pubDate'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rssName'] = this.rssName;
    data['rssIcon'] = this.rssIcon;
    data['title'] = this.title;
    data['author'] = this.author;
    data['description'] = this.description;
    data['link'] = this.link;
    data['pubDate'] = this.pubDate;
    data['media'] = this.media;
    return data;
  }
}
