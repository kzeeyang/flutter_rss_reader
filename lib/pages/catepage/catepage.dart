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
  double _sliverAppBarHeight = 230;
  ScrollController _scrollController = new ScrollController();
  bool _showTitle = false;
  final double stateHeight = MediaQueryData.fromWindow(window).padding.top;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // debugPrint("${_scrollController.offset}");
      _showTitle = _scrollController.offset + stateHeight > _sliverAppBarHeight
          ? true
          : false;
      setState(() {});
    });
  }

  Future<bool> _goBackOrPopCallback() async {
    ExtendedNavigator.rootNavigator.pop();
    return false;
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
      floating: true,
      expandedHeight: _sliverAppBarHeight,
      flexibleSpace: CatePageAppBar(
        imageUrl: widget.rssSetting.iconUrl,
        rssSetting: widget.rssSetting,
        context: context,
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
      body: EasyRefresh(
        enableControlFinishRefresh: true,
        controller: Global.refreshController,
        scrollController: _scrollController,
        // header: BezierHourGlassHeader(backgroundColor: Colors.grey),
        header: MaterialHeader(),
        onRefresh: () async {
          await _loadRss();
          Global.refreshController.finishRefresh();
        },
        child: CustomScrollView(
          slivers: [
            _sliverAppBar(),
            SliverPadding(
              padding: EdgeInsets.only(top: 5.0),
              sliver: ItemSliverList(
                mRssItems:
                    Global.appState.getCatePage(widget.rssSetting.rssName),
                scrollController: _scrollController,
                useCatePage: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container(
//               height: _sliverAppBarHeight,
//               alignment: Alignment.bottomCenter,
//               // color: Colors.blueAccent,
//               child: UserAccountsDrawerHeader(
//                 accountName: Text(
//                   widget.rssSetting.rssName,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 accountEmail: widget.rssSetting.description == null
//                     ? Text("这个Rss很懒，什么介绍都没有。")
//                     : Text(widget.rssSetting.description),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundImage: NetworkImage(widget.rssSetting.iconUrl),
//                   backgroundColor: Colors.transparent,
//                 ),
//                 decoration: BoxDecoration(
//                   // color: Colors.black54,
//                   image: DecorationImage(
//                     image: NetworkImage(widget.rssSetting.iconUrl),
//                     fit: BoxFit.cover,
//                     colorFilter:
//                         ColorFilter.mode(Colors.black54, BlendMode.darken),
//                   ),
//                 ),
//               ),
//             ),
