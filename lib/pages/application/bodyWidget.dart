import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/ItemSliverList.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webfeed/webfeed.dart';

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  ScrollController _scrollController = new ScrollController();

  List<MRssItem> _mRssItems = new List();

  @override
  void initState() {
    super.initState();
    _loadRss();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  _loadCache() {
    Timer(Duration(seconds: 3), () {
      Global.refreshController.callRefresh();
    });
  }

  _loadRss() async {
    await Global.appState.reloadMRssItems();
    // Global.appState.mRssItems
    //     .sort((left, right) => left.pubDate.compareTo(right.pubDate));
    _mRssItems = Global.appState.mRssItems;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final double _minPanelHeight = 35;
    final double _maxPanelHeight = height / 2.3;

    return SlidingUpPanel(
      controller: Global.panelController,
      minHeight: _minPanelHeight,
      maxHeight: _maxPanelHeight,
      backdropEnabled: true,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      onPanelClosed: () {
        Global.appState.changePanelOpen(false);
      },
      onPanelOpened: () {
        Global.appState.changePanelOpen(true);
      },
      body: EasyRefresh(
        enableControlFinishRefresh: true,
        controller: Global.refreshController,
        scrollController: _scrollController,
        // header: BezierHourGlassHeader(backgroundColor: Colors.grey),
        header: BezierCircleHeader(),
        onRefresh: () async {
          await _loadRss();
          Global.refreshController.finishRefresh();
        },
        child: _mRssItems.length > 0
            ? _panelBody()
            : Container(
                child: Text('暂无数据'),
              ),
      ),
      panel: _panelWidget(_minPanelHeight, size),
    );
  }

  Widget _panelBody() {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverPadding(
            padding: EdgeInsets.only(top: 8.0),
            sliver: ItemSliverList(
              mRssItems: _mRssItems,
              scrollController: _scrollController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _panelWidget(double _minPanelHeight, Size size) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: _minPanelHeight / 1.5,
                width: size.width,
                child: FlatButton(
                  onPressed: () {
                    if (Global.panelController.isPanelOpen()) {
                      Global.panelController.close();
                    } else if (Global.panelController.isPanelClosed()) {
                      Global.panelController.open();
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Global.appState.panelOpen
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Wrap(
              spacing: 10.0,
              children:
                  Global.appState.showCategory.rssSettings.map((rssSetting) {
                var index = Global.appState.showCategory.rssSettings
                    .indexOf(rssSetting);
                return RssIcon(
                  rssSetting,
                  size: 40,
                  onTap: () {
                    Global.appState.changeShowRssOpened(index);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
