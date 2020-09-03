import 'package:dio/dio.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';

class Rss {
  static HttpUtil client = HttpUtil();

  /// 获取数据
  static Future<RssFeed> testConn(
    String url, {
    @required BuildContext context,
    bool cacheDisk = false,
  }) async {
    var channel = await client.get(url, context: null).then((response) {
      var channel = new RssFeed.parse(response);
      return channel;
    });
    return channel;
  }
}
