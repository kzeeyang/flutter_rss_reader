import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';

Widget cateList(BuildContext context) {
  List<String> cateList = Global.appState.category.keys.toList();
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final itemHeight = 50.0;
  var iconUtil = IconUtil.getInstance();
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        if (cateList.length <= 0) {
          return null;
        }
        String key = cateList[index];
        return InkWell(
          child: Row(
            children: [
              Container(
                height: duSetHeight(itemHeight),
                padding: EdgeInsets.symmetric(horizontal: duSetWidth(15)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhiteBackground,
                ),
                child: Icon(
                  iconUtil.getIconDataForCategory(
                    Global.appState.categoryIconName(key),
                  ),
                ),
              ),
              Container(
                height: duSetHeight(50),
                width: duSetWidth(width - 92),
                padding: EdgeInsets.only(right: duSetWidth(10)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhiteBackground,
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: AppColors.primaryGreyBackground,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                        fontSize: duSetFontSize(20),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: AppColors.primaryText,
                      ),
                      onPressed: () {
                        ExtendedNavigator.rootNavigator
                            .pushCateDetail(cateName: key);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            ExtendedNavigator.rootNavigator.pushCateDetail(cateName: key);
          },
        );
      },
      childCount: cateList.length < 1 ? 1 : cateList.length,
    ),
  );
}
