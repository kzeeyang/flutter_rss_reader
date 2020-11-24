import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

class ItemSliverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var mRssitem = Global.appState.mRssItems[index];
          if (Global.appState.mRssItemIsShow(mRssitem.rssName)) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppValue.ItemBottomPadding),
              child: Material(
                borderRadius: BorderRadius.circular(12.0),
                elevation: AppValue.ItemShadowElevation,
                shadowColor: AppValue.ItemShadowColor,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: [
                        ItemHeader(context, mRssitem),
                        ItemBody(context, mRssitem),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
        childCount: Global.appState.mRssItems.length,
      ),
    );
  }
}
