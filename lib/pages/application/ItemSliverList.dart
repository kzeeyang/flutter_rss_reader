import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

class ItemSliverList extends StatelessWidget {
  final List<MRssItem> mRssItems;
  final ScrollController scrollController;
  final bool useCatePage;
  final bool showCatePage;

  const ItemSliverList({
    Key key,
    this.scrollController,
    this.mRssItems,
    this.useCatePage = false,
    this.showCatePage = false,
  }) : super(key: key);

  _onTap(MRssItem mRssItem) {
    print('Enter to link: ${mRssItem.link}');
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var mRssitem = mRssItems[index];
          if (Global.appState.mRssItemIsShow(mRssitem.rssName) ||
              showCatePage) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppValue.ItemBottomPadding),
              child: Material(
                borderRadius: BorderRadius.circular(12.0),
                elevation: AppValue.ItemShadowElevation,
                shadowColor: AppValue.ItemShadowColor,
                child: Column(
                  children: [
                    ItemHeader(context, mRssitem, useCatePage),
                    ItemBody(context, mRssitem, scrollController),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        childCount: mRssItems.length,
      ),
    );
  }
}
