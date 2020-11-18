import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:webfeed/webfeed.dart';

class Rss {
  static HttpUtil client = HttpUtil();
  static String icon = "/favicon.ico";

  /// 获取数据
  static Future<RssSetting> testConn(
    String url, {
    @required BuildContext context,
    bool cacheDisk = false,
  }) async {
    var channel = await client.get(url, context: null).then((response) {
      // debugPrint("$response");
      RssSetting rssSetting;
      String iconUrl = "";
      String host = urlHost(url);
      if (url.endsWith('.xml')) {
        var feed = AtomFeed.parse(response);
        if (feed.logo == null || feed.logo == '') {
          iconUrl = host + icon;
        } else {
          iconUrl = feed.logo;
        }
        rssSetting = RssSetting(
          url: url,
          rssName: feed.title,
          iconUrl: iconUrl,
          opened: true,
        );
      } else {
        var channel = new RssFeed.parse(response);
        if (channel.image == null) {
          iconUrl = host + icon;
        } else {
          iconUrl = channel.image.url;
        }

        rssSetting = RssSetting(
          url: url,
          rssName: channel.title,
          iconUrl: iconUrl,
          opened: true,
        );
      }
      return rssSetting;
    });
    return channel;
  }

  static Future<String> rssIcon(
    String url, {
    @required BuildContext context,
    bool cacheDisk = false,
  }) async {
    var iconString = await client.get(url, context: null).then((response) {
      // debugPrint("$response");
      String iconUrl = "";
      String host = urlHost(url);
      if (url.endsWith('.xml')) {
        var feed = AtomFeed.parse(response);
        if (feed.logo == null || feed.logo == '') {
          iconUrl = host + icon;
        } else {
          iconUrl = feed.logo;
        }
      } else {
        var channel = new RssFeed.parse(response);
        if (channel.image == null) {
          iconUrl = host + icon;
        } else {
          iconUrl = channel.image.url;
        }
      }
      return iconUrl;
    });
    return iconString;
  }

  static Future<AtomFeed> getAtom(
    String url, {
    @required BuildContext context,
    bool cacheDisk = false,
  }) async {
    var feed = await client.get(url, context: null).then((response) {
      AtomFeed feed = AtomFeed.parse(response);
      return feed;
    });
    return feed;
  }

  static Future<RssFeed> getRss(
    String url, {
    @required BuildContext context,
    bool cacheDisk = false,
  }) async {
    var channel = await client.get(url, context: null).then((response) {
      var channel = RssFeed.parse(response);
      return channel;
    });
    return channel;
  }
}
