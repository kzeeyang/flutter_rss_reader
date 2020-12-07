import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';
import 'package:flutter_rss_reader/common/utils/screen.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/colors.dart';
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

class _ApplicationPageState extends State<ApplicationPage> {
  final String topMsg = '已在最顶层';
  final String bottomMsg = '已在最底层';
  DateTime _lastTime;
  bool _draggingBtn = false;
  int _draggingChoice = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 顶部导航
  Widget _buildAppBar() {
    return MyAppBar(
      title: Global.appState.showCategory == null
          ? "Home".toUpperCase()
          : Global.appState.showCategory.cateName.toUpperCase(),
      actions: <Widget>[
        IconButton(
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
    return WillPopScope(
      onWillPop: () async {
        if (_lastTime == null ||
            DateTime.now().difference(_lastTime) > Duration(seconds: 2)) {
          //两次点击间隔超过2s重新计时
          _lastTime = DateTime.now();
          toastInfo(
            msg: "再按一次退出",
            toastGravity: ToastGravity.BOTTOM,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Global.appState.showCategory == null
            ? Container(
                color: AppColors.primaryGreyBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('尚未添加分类'),
                      ],
                    ),
                  ],
                ),
              )
            : Global.appState.showCategory.rssSettings.length == 0
                ? Container(
                    color: AppColors.primaryGreyBackground,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('分类下尚未添加RSS'),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Stack(
                      children: [
                        Positioned(child: BodyWidget()),
                        scrollDragtarget(
                          left: 0,
                          onWillAccept: (data) {
                            Global.appState.changeDragChoice(1);
                            return true;
                          },
                          onAccept: (data) {
                            _draggingChoice = 0;
                            if (Global.scrollController.offset == 0) {
                              toastInfo(msg: topMsg);
                            } else {
                              var offsize =
                                  Global.scrollController.offset - height;
                              if (offsize < 0) {
                                offsize = 0;
                              }
                              Global.scrollController.animateTo(offsize,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            }
                          },
                        ),
                        scrollDragtarget(
                          right: 0,
                          onWillAccept: (data) {
                            Global.appState.changeDragChoice(2);
                            return true;
                          },
                          onAccept: (data) {
                            if (Global.scrollController.offset ==
                                Global.scrollController.position
                                    .maxScrollExtent) {
                              toastInfo(msg: bottomMsg);
                            } else {
                              var offsize =
                                  Global.scrollController.offset + height;
                              if (offsize >
                                  Global.scrollController.position
                                      .maxScrollExtent) {
                                offsize = Global
                                    .scrollController.position.maxScrollExtent;
                              }
                              Global.scrollController.animateTo(offsize,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
        floatingActionButton: Global.appState.showCategory == null
            ? Container()
            : AnimationFloatingButton(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
