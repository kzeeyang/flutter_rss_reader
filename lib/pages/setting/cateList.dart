import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';

Widget cateList(BuildContext context, double itemHeight) {
  List<String> cateList = Global.appState.category.keys.toList();
  final size = MediaQuery.of(context).size;
  // final height = size.height;
  final width = size.width;
  final iconWidth = 40.0;
  var iconUtil = IconUtil.getInstance();
  return Container(
    child: Column(
      children: cateList.map((catename) {
        return InkWell(
          child: Container(
            height: itemHeight,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryWhiteBackground,
            ),
            child: Row(
              children: [
                Container(
                  width: iconWidth,
                  child: Icon(
                    iconUtil.getIconDataForCategory(
                      Global.appState.categoryIconName(catename),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: width - 10 * 2 - iconWidth,
                  padding: EdgeInsets.only(left: 10),
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
                      Container(
                        width: width - 10 * 3 - iconWidth * 2,
                        child: Text(
                          catename,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: iconWidth,
                        child: TransparentIconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: AppColors.primaryText,
                          ),
                          onPressed: () {
                            ExtendedNavigator.rootNavigator
                                .pushCateDetail(cateName: catename);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            ExtendedNavigator.rootNavigator.pushCateDetail(cateName: catename);
          },
        );
      }).toList(),
    ),
  );
}
