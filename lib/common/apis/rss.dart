import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart' show parse;

class Rss {
  static HttpUtil client = HttpUtil();
  static String icon = "/favicon.ico";

  /// 获取数据
  static Future<RssEntity> getRss(
    String url, {
    @required BuildContext context,
    bool cacheDisk = false,
    bool getRssSetting = false,
    bool getMRssItems = false,
    bool getIconUrl = false,
    String rssIconUrl,
  }) async {
    var rssEntity = await client
        .get(url, context: null, cacheDisk: cacheDisk)
        .then((response) {
      // debugPrint("$response");
      RssEntity rssEntity = new RssEntity();
      String host = urlHost(url);
      if (url.endsWith('.xml') || url.endsWith('.atom')) {
        var atomFeed = _parseAtomFeed(response);

        if (getRssSetting) {
          rssEntity.rssSetting = RssSetting(
            url: url,
            rssName: atomFeed.title,
            iconUrl: _getIconURL(atomFeed.logo, host),
            opened: true,
            description: atomFeed.subtitle,
          );
        }

        if (getMRssItems) {
          rssEntity.mrssItems = new List<MRssItem>();
          atomFeed.items.forEach((item) {
            // print('offset: ${item.updated.timeZoneOffset}');
            // print('Atom updated: ${item.updated}');
            MRssItem mRssItem = _parseItemToMRssItem(false, null, item);
            mRssItem.rssName = atomFeed.title;
            mRssItem.rssIcon = rssIconUrl;

            rssEntity.mrssItems.add(mRssItem);
          });
        }

        if (getIconUrl) {
          rssEntity.iconUrl = _getIconURL(atomFeed.logo, host);
        }
      } else {
        var rssFeed = _praseRssFeed(response);
        // debugPrint("rssFeed description: ${rssFeed.description}");
        if (getRssSetting) {
          rssEntity.rssSetting = RssSetting(
            url: url,
            rssName: rssFeed.title,
            iconUrl: _getIconURL(
                rssFeed.image == null ? "" : rssFeed.image.url, host),
            opened: true,
            description: rssFeed.description,
          );
        }

        if (getMRssItems) {
          rssEntity.mrssItems = new List<MRssItem>();

          rssFeed.items.forEach((item) {
            MRssItem mRssItem = _parseItemToMRssItem(true, item, null);
            mRssItem.rssName = rssFeed.title;
            mRssItem.rssIcon = rssIconUrl;

            rssEntity.mrssItems.add(mRssItem);
          });
        }

        if (getIconUrl) {
          rssEntity.iconUrl =
              _getIconURL(rssFeed.image == null ? "" : rssFeed.image.url, host);
        }
      }
      return rssEntity;
    });
    return rssEntity;
  }

  static AtomFeed _parseAtomFeed(String xmlResponse) {
    var feed = AtomFeed.parse(xmlResponse);
    return feed;
  }

  static RssFeed _praseRssFeed(String xmlResponse) {
    var channel = new RssFeed.parse(xmlResponse);
    return channel;
  }

  static String _getIconURL(String logoUrl, host) {
    if (logoUrl == null || logoUrl == '') {
      return host + icon;
    } else {
      return logoUrl;
    }
  }

  static MRssItem _parseItemToMRssItem(
      bool isRssItem, RssItem rssItem, AtomItem atomItem) {
    MRssItem mRssItem = new MRssItem();
    if (isRssItem) {
      mRssItem.title = rssItem.title;
      mRssItem.pubDate = rssItem.pubDate;
      mRssItem.author = rssItem.author;
      mRssItem.description = rssItem.description;
      mRssItem.link = rssItem.link;
      mRssItem.media = rssItem.media;
    } else {
      mRssItem.title = atomItem.title;
      mRssItem.pubDate = atomItem.updated;
      mRssItem.author = atomItem.authors.first.name;
      mRssItem.description = atomItem.content;
      mRssItem.link = atomItem.links.first.href;
      mRssItem.media = atomItem.media;
    }

    return mRssItem;
  }

  // static Future<String> rssIcon(
  //   String url, {
  //   @required BuildContext context,
  //   bool cacheDisk = false,
  // }) async {
  //   var iconString = await client.get(url, context: null).then((response) {
  //     debugPrint("get rss: $url");
  //     String iconUrl = "";
  //     String host = urlHost(url);
  //     if (url.endsWith('.xml')) {
  //       var feed = AtomFeed.parse(response);
  //       if (feed.logo == null || feed.logo == '') {
  //         iconUrl = host + icon;
  //       } else {
  //         iconUrl = feed.logo;
  //       }
  //     } else {
  //       var channel = new RssFeed.parse(response);
  //       if (channel.image == null) {
  //         iconUrl = host + icon;
  //       } else {
  //         iconUrl = channel.image.url;
  //       }
  //     }
  //     return iconUrl;
  //   });
  //   return iconString;
  // }

//   static Future<List<MRssItem>> getMRssItems(
//     List<RssSetting> rssSettings, {
//     @required BuildContext context,
//     bool cacheDisk = false,
//   }) async {
//     List<MRssItem> mRssItems = List();
//     for (var i = 0; i < rssSettings.length; i++) {
//       var rss = rssSettings[i];
//       print('getMRssItems: ${rss.url}');
//       var response = await client.get(rss.url, context: context);
//       if (isAtomUrl(rss.url)) {
//         var atomFeed = AtomFeed.parse(response);
//         atomFeed.items.forEach((item) {
//           // print('offset: ${item.updated.timeZoneOffset}');
//           // print('Atom updated: ${item.updated}');
//           MRssItem mRssItem = new MRssItem();
//           mRssItem.rssName = atomFeed.title;
//           mRssItem.rssIcon = rss.iconUrl;
//           mRssItem.title = item.title;
//           mRssItem.pubDate = item.updated;
//           mRssItem.author = item.authors.first.name;
//           mRssItem.description = item.content;
//           mRssItem.link = item.links.first.href;
//           mRssItem.media = item.media;

//           mRssItems.add(mRssItem);
//         });
//       } else {
//         var rssFeed = new RssFeed.parse(response);

//         rssFeed.items.forEach((item) {
//           MRssItem mRssItem = new MRssItem();
//           mRssItem.rssName = rssFeed.title;
//           mRssItem.rssIcon = rss.iconUrl;
//           mRssItem.title = item.title;
//           mRssItem.pubDate = item.pubDate;
//           mRssItem.author = item.author;
//           mRssItem.description = item.description;
//           mRssItem.link = item.link;
//           mRssItem.media = item.media;
//           mRssItems.add(mRssItem);
//         });
//       }
//     }

//     return mRssItems;
//   }
}
