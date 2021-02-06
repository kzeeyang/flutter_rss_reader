import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';

Widget rewardWidget(double rewardHeight) {
  final rewardPic = "assets/images/微信图片_20200602112022.jpg";

  return Container(
    color: AppColors.primaryWhiteBackground,
    height: rewardHeight,
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            height: 30,
            child: Text(
              "这是一个打赏码😉",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(
            height: 30,
            child: Text(
              "CREATED BY Trevor、",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(
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
        ],
      ),
    ),
  );
}
