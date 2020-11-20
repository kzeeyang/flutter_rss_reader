import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/common/provider/rssItem.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';

Widget ItemBody(MRssItem item) {
  return Container(
    child: ExpansionText(
      text: item.description,
      minLines: 5,
      textStyle: TextStyle(
        fontSize: AppValue.fontSize,
      ),
    ),
  );
}
