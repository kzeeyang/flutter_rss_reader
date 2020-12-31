import 'package:flutter/cupertino.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

Widget IconContainer({
  double width,
  Widget iconBtn,
  Widget textWgt,
}) {
  return Container(
    height: width,
    width: width,
    color: AppColors.primaryWhiteBackground,
    padding: EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        iconBtn,
        textWgt,
      ],
    ),
  );
}
