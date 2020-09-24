import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

Widget rewardWidget() {
  return SliverFixedExtentList(
    itemExtent: 230,
    delegate: new SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        //创建列表项
        return Container(
          color: AppColors.primaryWhiteBackground,
          child: Column(
            children: [
              Container(
                height: 30,
                child: Text(
                  "这是一个赞赏码😉",
                ),
              ),
              Container(
                height: 200,
                child: Image.asset(
                  "assets/images/微信图片_20200602112022.jpg",
                ),
              ),
            ],
          ),
        );
      },
      childCount: 1, //50个列表项
    ),
  );
}
