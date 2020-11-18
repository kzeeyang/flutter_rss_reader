import 'package:flutter_rss_reader/common/apis/api.dart';

class RssSetting {
  String rssName;
  String url;
  String iconUrl;
  bool opened;

  RssSetting({this.rssName, this.url, this.iconUrl, this.opened});

  RssSetting.fromJson(Map<String, dynamic> json) {
    rssName = json['rssName'];
    url = json['url'];
    if (json['iconUrl'] != null || json['iconUrl'] != '') {
      iconUrl = json['iconUrl'];
    }
    if (json['iconUrl'] == null) {
      Future(() async {
        // print('$url');
        String str = await Rss.rssIcon(this.url, context: null);
        if (str == null || str == '') {
          str = rssName.trim().substring(0, 1);
        }
        iconUrl = str;
      });
    }
    opened = json['opened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rssName'] = this.rssName;
    data['url'] = this.url;
    data['iconUrl'] = this.iconUrl;
    data['opened'] = this.opened;
    return data;
  }
}
