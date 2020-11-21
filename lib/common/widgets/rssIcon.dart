import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';

Widget RssIcon(
  RssSetting rss, {
  double size = 30,
  Function onTap,
}) {
  return Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: rss.iconUrl != null
          ? Colors.white
          : rss.opened ? Colors.blue : Colors.black54,
      borderRadius: BorderRadius.circular(size / 2),
      // 圆形图片
      image: rss.iconUrl != null
          ? DecorationImage(
              image: NetworkImage(rss.iconUrl),
              fit: BoxFit.fill,
              colorFilter: rss.opened
                  ? null
                  : ColorFilter.mode(Colors.black54, BlendMode.hardLight),
            )
          : null,
    ),
    child: InkWell(
      child: rss.iconUrl == null
          ? Text(
              rss.rssName.trim().substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
          : null,
      onTap: onTap,
    ),
  );
}
