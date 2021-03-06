import 'package:auto_route/auto_route.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/common/provider/rssItem.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart' show parse;

Widget ItemBody(
    BuildContext context, MRssItem item, ScrollController scrollController) {
  var document = parse(item.description);

  Future _openAlertDialog() async {
    final action = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog'),
          content: Text('复制文字'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                ExtendedNavigator.rootNavigator.pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                ClipboardData data =
                    new ClipboardData(text: document.body.text);
                Clipboard.setData(data);
                toastInfo(msg: "已复制所有文字", toastGravity: ToastGravity.BOTTOM);
                ExtendedNavigator.rootNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: AppValue.horizontalPadding),
    child: GestureDetector(
      child: ExpansionText(
        text: document.body.text,
        minLines: 5,
        maxLines: 60,
        textStyle: TextStyle(
          fontSize: AppValue.fontSize,
        ),
        scrollController: scrollController,
      ),
      onLongPress: () {
        _openAlertDialog();
      },
      onTap: () {
        print('Enter item link: ${item.link}');
        ExtendedNavigator.rootNavigator.pushDetailPageRoute(item: item);
      },
    ),
    // child: HtmlTextView(data: item.description),
  );
}
