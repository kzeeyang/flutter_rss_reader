import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/screen.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/myScaffold.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/bodyWidget.dart';
import 'package:flutter_rss_reader/pages/application/floatingActionButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage>
    with TickerProviderStateMixin {
  final String topMsg = '上面没有内容了唉~';
  final String bottomMsg = '所有内容已经看完了，休息一下吧！';

  EasyRefreshController _refreshController;
  ScrollController _scrollController;

  DateTime _willPopLastTime;

  AppBar _appBar = new AppBar(
    title: Text(
      "Home".toUpperCase(),
      style: TextStyle(
        color: AppColors.primaryText,
        fontFamily: AppColors.fontMontserrat,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _refreshController = new EasyRefreshController();
    _scrollController = new ScrollController();
    // bool firstOpen = StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    _buildAppBar();
    // debugPrint("firstOpen: $firstOpen");
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  bool _popFunction() {
    if (_willPopLastTime == null ||
        DateTime.now().difference(_willPopLastTime) > Duration(seconds: 2)) {
      //两次点击间隔超过2s重新计时
      _willPopLastTime = DateTime.now();
      toastInfo(
        msg: "再按一次退出",
        toastGravity: ToastGravity.BOTTOM,
      );
      return false;
    }
    return true;
  }

  Future<void> _exitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  // 顶部导航
  Widget _buildAppBar() {
    _appBar = MyAppBar(
      title: Global.appState.showCategory == null
          ? "Home".toUpperCase()
          : Global.appState.showCategory.cateName.toUpperCase(),
      actions: <Widget>[
        TransparentIconButton(
          icon: Icon(
            Icons.settings,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            ExtendedNavigator.rootNavigator.pushNamed(Routes.settingPage);
          },
        ),
      ],
    );
    return _appBar;
  }

  Widget scrollDragtarget({
    double left,
    double right,
    Function(dynamic) onWillAccept,
    Function(dynamic) onAccept,
  }) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final targetHeight = size.height / 4;
    final targetWidth = size.width / 3.5;
    return Global.appState.isDragging
        ? Positioned(
            left: left != null ? left : null,
            right: right != null ? right : null,
            bottom: 0,
            child: DragTarget(
              builder: (context, accepted, rejected) {
                return Container(
                  width: targetWidth,
                  height: targetHeight,
                  color: Colors.transparent,
                );
              },
              onWillAccept: onWillAccept,
              onLeave: (data) {
                Global.appState.changeDragChoice(0);
              },
              onAccept: onAccept,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final pageHeight = height - _appBar.preferredSize.height;
    return MyScaffold(
      showRightDragItem: false,
      dragItemWidth: 30,
      onWillPop: () async {
        return _popFunction();
      },
      onLeftDragEnd: () async {
        if (_popFunction()) {
          _exitApp();
        }
      },
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Global.appState.showCategory == null
              ? Center(
                  child: Text('尚未添加分类'),
                )
              : Global.appState.showCategory.rssSettings.length == 0
                  ? Center(child: Text('分类下尚未添加RSS'))
                  : Positioned(
                      child: BodyWidget(
                      appBarSize: _appBar.preferredSize,
                      scrollController: _scrollController,
                      refreshController: _refreshController,
                    )),
          scrollDragtarget(
            left: 0,
            onWillAccept: (data) {
              Global.appState.changeDragChoice(1);
              return true;
            },
            onAccept: (data) {
              if (_scrollController.offset == 0) {
                toastInfo(msg: topMsg);
              } else {
                var offsize = _scrollController.offset - pageHeight;
                if (offsize < 0) {
                  offsize = 0;
                }
                _scrollController.animateTo(offsize,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
              Global.appState.changeDragChoice(0);
            },
          ),
          scrollDragtarget(
            right: 0,
            onWillAccept: (data) {
              Global.appState.changeDragChoice(2);
              return true;
            },
            onAccept: (data) {
              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent) {
                toastInfo(msg: bottomMsg);
              } else {
                var offsize = _scrollController.offset + pageHeight;
                if (offsize > _scrollController.position.maxScrollExtent) {
                  offsize = _scrollController.position.maxScrollExtent;
                }
                _scrollController.animateTo(offsize,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
              Global.appState.changeDragChoice(0);
            },
          ),
        ],
      ),
      floatingActionButton: Global.appState.showCategory == null
          ? Container()
          : AnimationFloatingButton(
              refreshController: _refreshController,
            ),
    );
  }
}
