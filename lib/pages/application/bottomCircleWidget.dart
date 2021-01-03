import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/floatingActionButton.dart';

class BottomCircleWidget extends StatefulWidget {
  final VoidCallback onExit;

  BottomCircleWidget({this.onExit});

  @override
  _BottomCircleWidgetState createState() => _BottomCircleWidgetState();
}

class _BottomCircleWidgetState extends State<BottomCircleWidget>
    with SingleTickerProviderStateMixin {
  List<String> cateList;
  int cateLength;
  IconUtil _iconUtil;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _controller.forward();

    super.initState();
  }

  Future doExit() async {
    widget?.onExit();
    await _controller.reverse();
    ExtendedNavigator.rootNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final circleSize = width;
    final offsetHeight = size.width / 2;

    cateList = Global.appState.category.keys.toList();
    cateLength = cateList.length;
    _iconUtil = IconUtil.getInstance();

    return WillPopScope(
      onWillPop: () async {
        doExit();
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () async {
          doExit();
        },
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0),
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 20,
                  left: size.width / 2 - 28,
                  child: AnimatedBuilder(
                    animation: _animation,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    builder: (ctx, child) {
                      return Transform.scale(
                        scale: (max(size.height, size.width) / 28) *
                            (_animation.value),
                        child: child,
                      );
                    },
                  ),
                ),
                Positioned(
                  // left: circleOrigin.dx,
                  top: offsetHeight - 30,
                  child: AnimatedBuilder(
                    animation: _animation,
                    child: CircleList(
                      outerCircleColor: Colors.blue[600],
                      innerCircleColor: Colors.white24,
                      origin: Offset(0, 0),
                      showInitialAnimation: true,
                      children: List.generate(
                        cateLength,
                        (index) {
                          return IconButton(
                            onPressed: () {
                              Global.appState
                                  .changeShowCategory(cateList[index]);
                              doExit();
                            },
                            icon: Icon(
                              _iconUtil.getIconDataForCategory(
                                Global.appState
                                    .categoryIconName(cateList[index]),
                              ),
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                      centerWidget: GestureDetector(
                        onTap: () {
                          doExit();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    builder: (ctx, child) {
                      return Transform.translate(
                        offset: Offset(
                            0,
                            MediaQuery.of(context).size.height -
                                (_animation.value) * circleSize),
                        child: Transform.scale(
                            scale: _animation.value, child: child),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
