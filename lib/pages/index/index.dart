import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/application.dart';
import 'package:flutter_rss_reader/pages/welcome/welcome.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //   context,
    //   width: 375,
    //   height: 812 - 44 - 34,
    //   allowFontScaling: true,
    // );

    return Scaffold(
      body: ApplicationPage(),
    );
  }
}
