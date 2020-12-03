import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';

Widget rewardWidget() {
  final rewardPic = "assets/images/微信图片_20200602112022.jpg";
  final double extentHeight = 280.0;

  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Container(
      color: AppColors.primaryWhiteBackground,
      height: extentHeight,
      child: Column(
        children: [
          Container(
            height: 30,
            child: Text(
              "这是一个赞赏码😉",
              style: TextStyle(
                fontSize: duSetFontSize(16),
              ),
            ),
          ),
          Container(
            height: 30,
            child: Text(
              "CREATED BY Trevor、",
              style: TextStyle(
                fontSize: duSetFontSize(16),
              ),
            ),
          ),
          InkWell(
            child: Container(
              height: 200,
              color: Colors.grey,
              child: Hero(
                tag: "simple",
                child: Image.asset(
                  rewardPic,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              ExtendedNavigator.rootNavigator.pushPhotoViewScreen(
                imageProvider: AssetImage(rewardPic),
                heroTag: 'simple',
              );
            },
          ),
        ],
      ),
    ),
  );
}
