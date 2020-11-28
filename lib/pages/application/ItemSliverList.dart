import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

class ItemSliverList extends StatelessWidget {
  final List<MRssItem> mRssItems;
  final ScrollController scrollController;

  const ItemSliverList({Key key, this.scrollController, this.mRssItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var mRssitem = mRssItems[index];
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
                        ItemBody(context, mRssitem, scrollController),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        childCount: Global.appState.mRssItems.length,
      ),
    );
  }
}
