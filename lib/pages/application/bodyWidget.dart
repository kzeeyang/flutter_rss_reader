import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:webfeed/webfeed.dart';

class BodyWidget extends StatefulWidget {
  PanelController panelController;
  BodyWidget(PanelController controller) {
    this.panelController = controller;
  }
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  EasyRefreshController _refreshController;
  List<MRssItem> mRssItems = [];
  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _loadRss();
  }

  _loadCache() {
    Timer(Duration(seconds: 3), () {
      _refreshController.callRefresh();
    });
  }

  _loadRss() async {
    List<RssSetting> channels = Global.appState.showCategory.rssSettings;
    mRssItems = [];

    for (var i = 0; i < channels.length; i++) {
      print('${channels[i].rssName}');
      if (channels[i].url.endsWith('.xml')) {
        AtomFeed atom = await Rss.getAtom(channels[i].url, context: null);
      } else {
        RssFeed rss;
        Future(() async {
          rss = await Rss.getRss(channels[i].url, context: null);
          // print('rssitemlength: ${rss.items.length}');
          // rss.items.map((item) {
          //   print('${item.title}');
          //   MRssItem mRssItem;
          //   mRssItem.rssName = channels[i].rssName;
          //   mRssItem.rssIcon = channels[i].iconUrl;
          //   mRssItem.title = item.title;
          //   mRssItem.pubDate = item.pubDate;
          //   mRssItem.author = item.author;
          //   mRssItem.description = item.description;
          //   mRssItem.link = item.link;
          //   mRssItem.media = item.media;
          //   mRssItems.add(mRssItem);
          // });
          for (var j = 0; j < rss.items.length; j++) {
            MRssItem mRssItem = new MRssItem(
              rssName: channels[i].rssName,
              rssIcon: channels[i].iconUrl,
              title: rss.items[j].title,
              pubDate: rss.items[j].pubDate,
              author: rss.items[j].author,
              description: rss.items[j].description,
              link: rss.items[j].link,
              media: rss.items[j].media,
            );
            Global.appState.mRssItems.add(mRssItem);
          }
        });
      }
    }

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
      controller: widget.panelController,
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
        controller: _refreshController,
        child: _panelBody(),
      ),
      panel: _panelWidget(_minPanelHeight, size),
    );
  }

  Widget _panelBody() {
    _loadRss();
    print('mRssItem length: ${Global.appState.mRssItems.length}');
    return ListView.builder(
      itemCount: Global.appState.mRssItems.length,
      itemBuilder: _listItemBuilder,
    );
    // return Container(
    //   child: IconButton(
    //     icon: Icon(Icons.refresh),
    //     onPressed: _loadRss,
    //   ),
    // );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Column(
      // children: rsses.map((rss) {
      //   RssSetting rssSetting =
      //       Global.appState.getShowCategoryRssSetting(rss.title);
      //   rss.items.sort((a, b) => (b.pubDate).compareTo(a.pubDate));

      children: Global.appState.mRssItems.map((mRssitem) {
        return Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(
            horizontal: AppValue.horizontalPadding,
            vertical: AppValue.verticalPadding,
          ),
          child: Column(
            children: [
              ItemHeader(context, mRssitem),
              Container(
                child: ExpansionText(
                  text: mRssitem.description,
                  minLines: 5,
                  textStyle: TextStyle(
                    fontSize: AppValue.fontSize,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
                    if (widget.panelController.isPanelOpen()) {
                      widget.panelController.close();
                    } else if (widget.panelController.isPanelClosed()) {
                      widget.panelController.open();
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
