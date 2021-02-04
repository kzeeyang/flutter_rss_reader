import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/myScaffold.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';

class CatePage extends StatefulWidget {
  final RssSetting rssSetting;

  const CatePage({Key key, this.rssSetting}) : super(key: key);

  @override
  _CatePageState createState() => _CatePageState();
}

class _CatePageState extends State<CatePage> {
  bool _canForward = false;
  double _sliverAppBarHeight = 200;

  Future<bool> _goBackOrPopCallback() async {
    ExtendedNavigator.rootNavigator.pop();
    return false;
  }

  Widget _buildAppBar() {
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

  @override
  Widget build(BuildContext context) {
    //   return MyAppBar(
    //     title: widget.cateName,
    //     leading: TransparentIconButton(
    //       icon: Icon(
    //         Icons.arrow_back_ios,
    //         color: AppColors.primaryText,
    //       ),
    //       onPressed: () {
    //         ExtendedNavigator.rootNavigator.pop();
    //       },
    //     ),
    //     actions: <Widget>[],
    //   );
    // }
    return MyScaffold(
      showRightDragItem: _canForward,
      dragItemWidth: 30,
      onWillPop: _goBackOrPopCallback,
      onLeftDragEnd: _goBackOrPopCallback,
      // onRightDragEnd: _forwardCallback,
      // appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            // title: Text(widget.rssSetting.rssName),
            leading: TransparentIconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                ExtendedNavigator.rootNavigator.pop();
              },
            ),
            // pinned: true, //保持在顶部
            floating: true, //向下滚动时会显示回来
            expandedHeight: _sliverAppBarHeight, //标题栏高度
            flexibleSpace: Container(
              height: _sliverAppBarHeight,
              alignment: Alignment.bottomCenter,
              // color: Colors.blueAccent,
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  widget.rssSetting.rssName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: widget.rssSetting.description == null
                    ? Text("这个Rss很懒，什么信息都没有。")
                    : Text(widget.rssSetting.description),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(widget.rssSetting.iconUrl),
                  backgroundColor: Colors.transparent,
                ),
                decoration: BoxDecoration(
                  // color: Colors.black54,
                  image: DecorationImage(
                    image: NetworkImage(widget.rssSetting.iconUrl),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
