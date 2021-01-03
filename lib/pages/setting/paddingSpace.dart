import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/global.dart';

Widget paddingSpace(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final height = size.height;
  final length = Global.appState.category.keys.toList().length;
  double spaceHeight = height - 190 - length * 50;
  return SliverFixedExtentList(
    itemExtent: spaceHeight < 0 ? 0 : spaceHeight,
    delegate: new SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        //创建列表项
        return spaceHeight < 0
            ? Container()
            : Container(
                color: AppColors.primaryGreyBackground,
                child: length > 0
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('暂无分类'),
                        ],
                      ),
              );
      },
      childCount: 1, //50个列表项
    ),
  );
}
