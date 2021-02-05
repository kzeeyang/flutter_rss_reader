import 'package:auto_route/auto_route.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:share/share.dart';

Widget ItemHeader(BuildContext context, MRssItem item, bool useCatePage) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = 60.0;
  final iconWidth = 40.0;
  final iconSize = 40.0;
  final shareWidth = 30.0;
  final titleWidth = width - iconWidth - shareWidth - 20;
  return Container(
    height: height,
    padding: EdgeInsets.symmetric(horizontal: AppValue.horizontalPadding),
    child: Row(
      children: [
        Container(
          width: iconWidth,
          child: RssIcon(
            Global.appState.getShowCategoryRssSetting(item.rssName),
            size: iconSize,
            onTap: () {
              if (useCatePage) {
                ExtendedNavigator.rootNavigator.pushCatePage(
                    rssSetting: Global.appState.getRss(item.rssName));
              }
            },
          ),
        ),
        InkWell(
          child: Container(
            width: titleWidth,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: AppValue.titleSize,
                      fontWeight: AppValue.titleWeight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: item.author != null
                            ? Text(
                                item.author,
                                style: TextStyle(
                                  fontSize: AppValue.dateSize,
                                  color: Colors.black54,
                                ),
                              )
                            : Container(),
                      ),
                      Text(
                        timeUtils(item.pubDate),
                        style: TextStyle(
                          fontSize: AppValue.dateSize,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.transparent,
          onTap: () {
            print('Enter item link: ${item.link}');
            ExtendedNavigator.rootNavigator.pushDetailPageRoute(item: item);
          },
        ),
        Container(
          width: shareWidth,
          child: TransparentIconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () {
              Share.share('${item.link}');
            },
          ),
        ),
      ],
    ),
  );
}
