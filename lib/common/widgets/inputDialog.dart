import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

void inputDialog(BuildContext context) {
  HttpUtil client = HttpUtil();
  TextEditingController textController = TextEditingController();

  checkRssUrl() {
    if (!duIsURL(textController.text)) {
      toastInfo(msg: '请输入正确的链接');
      return;
    }
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('导入数据'),
        content: inputRSSURLEdit(
          controller: textController,
          hintText: "输入URL",
          marginTop: 0,
          onEditingComplete: checkRssUrl,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              ExtendedNavigator.rootNavigator.pop();
            },
          ),
          FlatButton(
            child: Text('确定'),
            onPressed: () async {
              // print(textController.value.text);
              await client
                  .get(textController.text, context: null)
                  .then((response) {
                Global.appState.addByJson(response);
              });
              ExtendedNavigator.rootNavigator.pop();
            },
          ),
        ],
      );
    },
  );
}
