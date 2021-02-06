import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rss_reader/common/utils/full_screen_dialog_util.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_rss_reader/common/router/router.gr.dart';

import 'bottomCircleWidget.dart';

class AnimationFloatingButton extends StatefulWidget {
  // PanelController panelController;
  // AnimationFloatingButton(PanelController controller) {
  //   this.panelController = controller;
  // }
  final EasyRefreshController refreshController;

  const AnimationFloatingButton({Key key, this.refreshController})
      : super(key: key);

  @override
  _AnimationFloatingButtonState createState() =>
      _AnimationFloatingButtonState();
}

class _AnimationFloatingButtonState extends State<AnimationFloatingButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  IconUtil _iconUtil;
  Offset floatOffset = Offset(500, kToolbarHeight + 100);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget hexagonButton() {
    return GestureDetector(
      child: Transform.rotate(
        angle: -pi / 2,
        child: FloatingActionButton(
          highlightElevation: 0,
          splashColor: Colors.white.withOpacity(0.1),
          focusColor: Colors.transparent,
          onPressed: () {
            FullScreenDialog.getInstance().showDialog(
              context,
              BottomCircleWidget(
                onExit: () {
                  _controller.reverse();
                },
              ),
            );
            _controller.forward();
          },
          child: Transform.rotate(
            angle: pi / 2,
            child: Icon(
              _iconUtil.getIconDataForCategory(
                  Global.appState.showCategory.iconName),
              size: 25,
              color: Colors.white,
            ),
          ),
          shape: FloatingBorder(),
        ),
      ),
      onDoubleTap: () {
        widget.refreshController.callRefresh();
      },
      onLongPress: () {
        ExtendedNavigator.rootNavigator
            .pushCateDetail(cateName: Global.appState.showCategory.cateName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    _iconUtil = IconUtil.getInstance();
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (_animation.value) * 56),
          child: Transform.scale(scale: 1 - _animation.value, child: child),
        );
      },
      child: Draggable(
        //拖动过程中的Widget
        feedback: hexagonButton(),
        //拖动过程中，在原来位置停留的Widget，设定这个可以保留原本位置的残影，如果不需要可以直接设置为Container()
        childWhenDragging: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Global.appState.draggingChoice == 0
              ? Text(
                  "😏",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              : Global.appState.draggingChoice == 1
                  ? Icon(Icons.keyboard_arrow_up)
                  : Icon(Icons.keyboard_arrow_down),
        ),
        //拖动结束后的Widget
        // onDraggableCanceled: (Velocity velocity, Offset offset) {
        //   // 计算组件可移动范围  更新位置信息
        //   // kBottomNavigationBarHeight
        //   var moveX = velocity.pixelsPerSecond.dx;
        //   var moveY = velocity.pixelsPerSecond.dy;
        //   debugPrint("movex: $moveX, moveY: $moveY");

        //   if (moveX < -kBottomNavigationBarHeight &&
        //       moveY > -kBottomNavigationBarHeight &&
        //       moveY < kBottomNavigationBarHeight) {
        //     debugPrint("move to left");
        //     if (Global.scrollController.offset == 0) {
        //       toastInfo(msg: topMsg);
        //     } else {
        //       var offsize = Global.scrollController.offset - height;
        //       if (offsize < 0) {
        //         offsize = 0;
        //       }
        //       Global.scrollController.animateTo(offsize,
        //           duration: Duration(milliseconds: 300), curve: Curves.ease);
        //     }
        //   } else if (moveX > kBottomNavigationBarHeight &&
        //       moveY > -kBottomNavigationBarHeight &&
        //       moveY < kBottomNavigationBarHeight) {
        //     debugPrint("move to right");
        //     if (Global.scrollController.offset ==
        //         Global.scrollController.position.maxScrollExtent) {
        //       toastInfo(msg: bottomMsg);
        //     } else {
        //       var offsize = Global.scrollController.offset + height;
        //       if (offsize > Global.scrollController.position.maxScrollExtent) {
        //         offsize = Global.scrollController.position.maxScrollExtent;
        //       }
        //       Global.scrollController.animateTo(offsize,
        //           duration: Duration(milliseconds: 300), curve: Curves.ease);
        //     }
        //   } else if (moveY < -kBottomNavigationBarHeight &&
        //       moveX > -kBottomNavigationBarHeight &&
        //       moveX < kBottomNavigationBarHeight) {
        //     debugPrint("move to top");
        //     // Global.panelController.open();
        //     if (Global.scrollController.offset == 0) {
        //       toastInfo(msg: topMsg);
        //     } else {
        //       Global.scrollController.animateTo(0,
        //           duration: Duration(milliseconds: 300), curve: Curves.ease);
        //     }
        //   } else if (moveY > kBottomNavigationBarHeight / 2 &&
        //       moveX > -kBottomNavigationBarHeight &&
        //       moveX < kBottomNavigationBarHeight) {
        //     debugPrint("move to down");
        //     // Global.panelController.close();

        //   }
        // },
        onDragStarted: () {
          Global.appState.changeDragging(true);
        },
        onDragEnd: (value) {
          Global.appState.changeDragging(false);
        },
        child: hexagonButton(),
      ),
    );
  }
}
