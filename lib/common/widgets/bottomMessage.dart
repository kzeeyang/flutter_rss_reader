import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future bottomMessage({
  BuildContext context,
  // Widget title,
  // Widget content,
}) async {
  await showModalBottomSheet(
    context: context,
    // barrierDismissible: true,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('选项一'),
              onTap: () {
                Navigator.pop(context, '选项一');
              },
            ),
            ListTile(
              title: Text('选项二'),
              onTap: () {
                Navigator.pop(context, '选项二');
              },
            ),
            ListTile(
              title: Text('选项三'),
              onTap: () {
                Navigator.pop(context, '选项三');
              },
            ),
          ],
        ),
      );
    },
  );
}

Future bottomModalBottomSheet({
  BuildContext context,
  String content = "测试文本",
  Function cancel,
  Function makeSure,
}) async {
  final option = await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          height: 200,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    InkWell(
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      splashColor: Colors.transparent, //渐变效果
                      onTap: cancel,
                    ),
                    Spacer(),
                    InkWell(
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      splashColor: Colors.transparent, //渐变效果
                      onTap: makeSure,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
