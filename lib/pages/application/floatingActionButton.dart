import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/app.dart';
import 'package:flutter_rss_reader/common/utils/full_screen_dialog_util.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottomCircleWidget.dart';

class AnimationFloatingButton extends StatefulWidget {
  PanelController panelController;
  AnimationFloatingButton(PanelController controller) {
    this.panelController = controller;
  }

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
    return Transform.rotate(
      angle: -pi / 2,
      child: FloatingActionButton(
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
            _iconUtil
                .getIconDataForCategory(Global.appState.showCategory.iconName),
            size: 25,
            color: Colors.white,
          ),
        ),
        shape: FloatingBorder(),
      ),
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
          child: Text(
            "😏",
            style: TextStyle(
              fontSize: duSetFontSize(18),
            ),
          ),
        ),

        //拖动结束后的Widget
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          // 计算组件可移动范围  更新位置信息
          // kBottomNavigationBarHeight
          var moveX = velocity.pixelsPerSecond.dx;
          var moveY = velocity.pixelsPerSecond.dy;
          debugPrint("movex: $moveX, moveY: $moveY");

          if (moveX < -kBottomNavigationBarHeight &&
              moveY > -kBottomNavigationBarHeight &&
              moveY < kBottomNavigationBarHeight) {
            debugPrint("move to left");
          } else if (moveX > kBottomNavigationBarHeight &&
              moveY > -kBottomNavigationBarHeight &&
              moveY < kBottomNavigationBarHeight) {
            debugPrint("move to right");
          } else if (moveY < -kBottomNavigationBarHeight &&
              moveX > -kBottomNavigationBarHeight &&
              moveX < kBottomNavigationBarHeight) {
            debugPrint("move to top");
            widget.panelController.open();
          } else if (moveY > kBottomNavigationBarHeight / 2 &&
              moveX > -kBottomNavigationBarHeight &&
              moveX < kBottomNavigationBarHeight) {
            debugPrint("move to down");
            widget.panelController.close();
          }
        },
        child: hexagonButton(),
      ),
    );
  }
}
