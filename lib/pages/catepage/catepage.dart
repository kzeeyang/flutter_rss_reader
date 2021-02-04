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
  double _sliverAppBarHeight = 220;

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
      backgroundColor: Colors.black,
      // title: Text(widget.rssSetting.rssName),
      leading: Icon(null),
      // leading: TransparentIconButton(
      //   icon: Icon(
      //     Icons.arrow_back_ios,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     ExtendedNavigator.rootNavigator.pop();
      //   },
      // ),
      // pinned: true, //保持在顶部
      floating: true, //向下滚动时会显示回来
      expandedHeight: _sliverAppBarHeight, //标题栏高度
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: _sliverAppBarHeight,
          decoration: BoxDecoration(
            // color: Colors.black54,
            image: DecorationImage(
              image: NetworkImage(widget.rssSetting.iconUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black87, BlendMode.darken),
            ),
          ),
          padding: EdgeInsets.only(top: 110, left: 15, right: 15),
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Row(
                children: [
                  RssIcon(
                    Global.appState
                        .getShowCategoryRssSetting(widget.rssSetting.rssName),
                    size: 60,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.rssSetting.rssName,
                      style: TextStyle(
                        fontSize: AppValue.titleSize * 1.2,
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
                padding: EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    Text(
                      widget.rssSetting.description == null ||
                              widget.rssSetting.description == ""
                          ? "这个Rss很懒，什么介绍都没有"
                          : widget.rssSetting.description,
                      style: TextStyle(
                        fontSize: AppValue.titleSize,
                        // fontWeight: AppValue.titleWeight,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sliverAppBar2() {
    return SliverAppBar(
      backgroundColor: Colors.black,
      leading: Icon(null),
      floating: true, //向下滚动时会显示回来
      expandedHeight: _sliverAppBarHeight, //标题栏高度
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              height: _sliverAppBarHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.rssSetting.iconUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: ClipRect(
                //可裁切的矩形
                child: BackdropFilter(
                  //背景过滤器
                  filter: ImageFilter.blur(
                      sigmaX: 5.0, sigmaY: 5.0), //图片过滤器包含在dart:UI中
                  child: Opacity(
                    opacity: 0.6, //透明度,数值越大越不透明
                    child: Container(
                      width: 500.0,
                      height: 700.0,
                      decoration: BoxDecoration(
                          //盒子修饰器
                          color: Colors.grey.shade200),
                      child: Center(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        scrollController: Global.scrollController,
        // header: BezierHourGlassHeader(backgroundColor: Colors.grey),
        header: BezierCircleHeader(backgroundColor: Colors.blue[400]),
        onRefresh: () async {
          await _loadRss();
          Global.refreshController.finishRefresh();
        },
        child: CustomScrollView(
          slivers: [
            _sliverAppBar2(),
            SliverPadding(
              padding: EdgeInsets.only(top: 5.0),
              sliver: ItemSliverList(
                mRssItems:
                    Global.appState.getCatePage(widget.rssSetting.rssName),
                scrollController: Global.scrollController,
              ),
            )
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
