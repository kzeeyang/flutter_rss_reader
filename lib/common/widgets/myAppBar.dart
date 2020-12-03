import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

Widget MyAppBar({
  String title,
  Widget leading,
  List<Widget> actions,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    brightness: Brightness.light,
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.primaryText,
        fontFamily: AppColors.fontMontserrat,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true,
    leading: leading,
    actions: actions,
  );
}

Widget cardListSkeleton() {
  return PKCardListSkeleton(
    isCircularImage: true,
    isBottomLinesActive: false,
    length: 10,
  );
}
