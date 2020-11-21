import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/rssItem.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:html/parser.dart' show parse;

Widget ItemBody(MRssItem item) {
  var document = parse(item.description);
  return Container(
    child: ExpansionText(
      text: document.body.text,
      minLines: 5,
      textStyle: TextStyle(
        fontSize: AppValue.fontSize,
      ),
    ),
    // child: HtmlTextView(data: item.description),
  );
}
