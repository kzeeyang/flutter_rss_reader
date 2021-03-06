import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/ItemSliverList.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webfeed/webfeed.dart';

class BodyWidget extends StatefulWidget {
  final Size appBarSize;
  final ScrollController scrollController;
  final EasyRefreshController refreshController;

  const BodyWidget(
      {Key key, this.appBarSize, this.scrollController, this.refreshController})
      : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  // List<MRssItem> _mRssItems = new List();
  PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _panelController = new PanelController();
    if (Global.appState.showCategory.rssSettings.isNotEmpty) {
      // print("body init get rss");
      _loadRss();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadCache() {
    Timer(Duration(seconds: 3), () {
      widget.refreshController.callRefresh();
    });
  }

  _loadRss() async {
    await Global.appState.reloadMRssItems();
    Global.appState.mRssItems
        .sort((left, right) => right.pubDate.compareTo(left.pubDate));
    // _mRssItems = Global.appState.mRssItems;

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
      controller: _panelController,
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
        controller: widget.refreshController,
        scrollController: widget.scrollController,
        // header: BezierHourGlassHeader(backgroundColor: Colors.grey),
        header: BezierCircleHeader(backgroundColor: Colors.blue[400]),
        onRefresh: () async {
          await _loadRss();
          widget.refreshController.finishRefresh();
        },

        child: Global.appState.mRssItems.length > 0
            ? _panelBody()
            : Container(
                height: height - widget.appBarSize.height,
                child: Center(
                  child: LoadingBouncingGrid.square(
                    backgroundColor: Colors.blue[400],
                  ),
                ),
              ),
      ),
      panel: _panelWidget(_minPanelHeight, size),
    );
  }

  Widget _panelBody() {
    print("show mRssItems length: ${Global.appState.mRssItems.length}");
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverPadding(
            padding: EdgeInsets.only(top: 5.0, bottom: 135),
            sliver: ItemSliverList(
              mRssItems: Global.appState.mRssItems,
              scrollController: widget.scrollController,
              useCatePage: true,
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
                    if (_panelController.isPanelOpen()) {
                      _panelController.close();
                    } else if (_panelController.isPanelClosed()) {
                      _panelController.open();
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
                  rss: rssSetting,
                  size: 40,
                  stokeWidth: 2,
                  onTap: () {
                    Global.appState.changeShowRssOpened(index);
                  },
                  onLongPress: () {
                    ExtendedNavigator.rootNavigator.pushCatePage(
                        rssSetting: Global.appState.getRss(rssSetting.rssName));
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
