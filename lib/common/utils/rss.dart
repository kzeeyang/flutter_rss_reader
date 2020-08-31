import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';

RssFeed RssConn(String connString) async {
  Dio client = new Dio();
  client.options.connectTimeout = 10000;
  client.options.receiveTimeout = 5000;
  // RSS feed
  await client.get(connString).then((response) {
    return response.data.toString();
  }).then((bodyString) {
    var channel = new RssFeed.parse(bodyString);
    print(channel);
    return channel;
  });
}
