import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/myScaffold.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/ItemSliverList.dart';

class CatePage extends StatefulWidget {
  final RssSetting rssSetting;

  const CatePage({Key key, this.rssSetting}) : super(key: key);

  @override
  _CatePageState createState() => _CatePageState();
}

class _CatePageState extends State<CatePage> {
  bool _canForward = false;
  double _sliverAppBarHeight = 200;
  bool _showTitle = false;
  final double stateHeight = MediaQueryData.fromWindow(window).padding.top;
  List<MRssItem> _mRssItems = List();

  EasyRefreshController _refreshController;
  ScrollController _scrollController;
  LinkHeaderNotifier _headerNotifier;

  @override
  void initState() {
    super.initState();

    _headerNotifier = LinkHeaderNotifier();
    _refreshController = EasyRefreshController();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      // debugPrint("${_scrollController.offset}");
      _showTitle =
          _scrollController.offset > (_sliverAppBarHeight - stateHeight) / 2
              ? true
              : false;
      setState(() {});
    });
    // _loadRss();
    _mRssItems = Global.appState.getCatePage(widget.rssSetting.rssName);
  }

  @override
  void dispose() {
    super.dispose();
    _headerNotifier.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  Future<bool> _goBackOrPopCallback() async {
    ExtendedNavigator.rootNavigator.pop();
    return false;
  }

  _loadRss() async {
    _mRssItems = await Global.appState.reloadOneRSS(widget.rssSetting);
    _mRssItems.sort((left, right) => right.pubDate.compareTo(left.pubDate));
    // _mRssItems = Global.appState.mRssItems;
    if (mounted) {
      setState(() {});
    }
  }

  Widget _appBar() {
    return MyAppBar(
      title: widget.rssSetting.rssName,
      leading: TransparentIconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          ExtendedNavigator.rootNavigator.pop();
        },
      ),
    );
  }

  Widget _sliverAppBar() {
    final double stateHeight = MediaQueryData.fromWindow(window).padding.top;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      title: _showTitle ? Text(widget.rssSetting.rssName) : null,
      leading: TransparentIconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          ExtendedNavigator.rootNavigator.pop();
        },
      ),
      pinned: true,
      floating: _showTitle ? false : true,
      expandedHeight: _sliverAppBarHeight,
      flexibleSpace: CatePageAppBar(
        imageUrl: widget.rssSetting.iconUrl,
        rssSetting: widget.rssSetting,
        context: context,
        stateHeight: stateHeight,
        sliverAppBarHeight: _sliverAppBarHeight,
        refreshAction: CircleHeader(
          _headerNotifier,
        ),
        refreshActionSize: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showRightDragItem: _canForward,
      dragItemWidth: 30,
      onWillPop: _goBackOrPopCallback,
      onLeftDragEnd: _goBackOrPopCallback,
      // onRightDragEnd: _forwardCallback,
      // appBar: _appBar(),
      body: EasyRefresh.custom(
        enableControlFinishRefresh: true,
        controller: _refreshController,
        scrollController: _scrollController,
        // header: BezierHourGlassHeader(backgroundColor: Colors.grey),
        // header: MaterialHeader(displacement: 40),
        header: LinkHeader(_headerNotifier,
            completeDuration: Duration(milliseconds: 500)),
        onRefresh: () async {
          await _loadRss();
          _refreshController.finishRefresh();
        },
        slivers: [
          _sliverAppBar(),
          SliverPadding(
            padding: EdgeInsets.only(top: 5.0),
            sliver: ItemSliverList(
              mRssItems: _mRssItems,
              scrollController: _scrollController,
              useCatePage: false,
            ),
          ),
        ],
      ),
    );
  }
}

// 圆形下拉刷新
class CircleHeader extends StatefulWidget {
  final LinkHeaderNotifier linkNotifier;
  final double size;

  const CircleHeader(this.linkNotifier, {Key key, this.size = 24})
      : super(key: key);

  @override
  CircleHeaderState createState() {
    return CircleHeaderState();
  }
}

class CircleHeaderState extends State<CircleHeader> {
  // 指示器值
  double _indicatorValue = 0.0;

  RefreshMode get _refreshState => widget.linkNotifier.refreshState;
  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  @override
  void initState() {
    super.initState();
    widget.linkNotifier.addListener(onLinkNotify);
  }

  void onLinkNotify() {
    setState(() {
      if (_refreshState == RefreshMode.armed ||
          _refreshState == RefreshMode.refresh) {
        _indicatorValue = null;
      } else if (_refreshState == RefreshMode.refreshed ||
          _refreshState == RefreshMode.done) {
        _indicatorValue = 1.0;
      } else {
        if (_refreshState == RefreshMode.inactive) {
          _indicatorValue = 0.0;
        } else {
          double indicatorValue = _pulledExtent / 70.0 * 0.8;
          _indicatorValue = indicatorValue < 0.8 ? indicatorValue : 0.8;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        margin: EdgeInsets.only(
          right: 20.0,
        ),
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          value: _indicatorValue,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 2.4,
        ),
      ),
    );
  }
}
