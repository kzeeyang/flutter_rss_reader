import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/pages/catepage/catepage.dart';

Widget CatePageAppBar({
  String imageUrl,
  RssSetting rssSetting,
  BuildContext context,
  double stateHeight,
  double sliverAppBarHeight,
  CircleHeader refreshAction,
  double refreshActionSize,
}) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  return Stack(
    children: [
      Container(
        // padding: EdgeInsets.only(top: stateHeight),
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        // width: pageWidth,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Opacity(
              opacity: 0.6,
              child: Container(
                width: width,
                height: 700.0,
                decoration: BoxDecoration(color: Colors.black),
                child: Center(),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: sliverAppBarHeight / 4 + 20 + stateHeight,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: width,
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Row(
                children: [
                  RssIcon(rssSetting, size: 60),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 12),
                    child: Text(
                      rssSetting.rssName,
                      style: TextStyle(
                        fontSize: AppValue.titleSize,
                        fontWeight: AppValue.titleWeight,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    rssSetting.description == null ||
                            rssSetting.description == ""
                        ? "这个Rss很懒，什么介绍都没有"
                        : rssSetting.description,
                    style: TextStyle(
                      fontSize: AppValue.titleSize * 0.8,
                      // fontWeight: AppValue.titleWeight,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 20 + stateHeight,
        right: 0,
        child: refreshAction,
      ),
    ],
  );
}
