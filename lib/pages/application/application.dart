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

class _ApplicationPageState extends State<ApplicationPage>
    with TickerProviderStateMixin {
  final String topMsg = '已在最顶层';
  final String bottomMsg = '已在最底层';

  DateTime _willPopLastTime;

  Animation _animation;
  AnimationController _animationController;
  double _animationWidth;
  double _animationTop;

  double _enbaleWidth = 25;
  double _edgeFloatingBtnHeight = 150;
  double _edgeFloatingBtnWidth = 80;
  bool _enabel = false;
  bool _cando = false;
  bool _showIcon = false;
  bool _right = false;
  Offset _startOffset;
  Offset _endOffset;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: const Duration(milliseconds: 0), vsync: this);
    _animation = Tween(begin: 0.0, end: 0).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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

  void _onHorizontalDragStart(DragStartDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    _startOffset = details.globalPosition;
    debugPrint("startOffset: ${_startOffset.dx}");

    if (_startOffset.dx + _enbaleWidth > screenWidth) {
      // _enabel = true;
      _right = true;
    }

    if (_startOffset.dx < _enbaleWidth) {
      _enabel = true;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    _endOffset = details.globalPosition;
    if (_enabel) {
      _animationTop = height - _endOffset.dy - _edgeFloatingBtnHeight / 2;
      if (_right) {
        // _animationWidth =
        //     (width - _endOffset.dx) * 4 * _edgeFloatingBtnWidth / width;
        // if (_endOffset.dx > width / 4 * 3) {
        //   _cando = false;
        //   debugPrint("cancel do something...");
        // } else {
        //   _cando = true;
        //   debugPrint("will do something...");
        // }
      } else {
        _animationWidth = _endOffset.dx * 4 * _edgeFloatingBtnWidth / width;
        if (_endOffset.dx > width / 8) {
          _showIcon = true;
        } else {
          _showIcon = false;
        }
        if (_endOffset.dx > width / 4) {
          _cando = true;
          debugPrint("will do something...");
        } else {
          _cando = false;
          debugPrint("cancel do something...");
        }
      }
      _animation = Tween(
              begin: 0.0,
              end: _animationWidth > _edgeFloatingBtnWidth
                  ? _edgeFloatingBtnWidth
                  : _animationWidth)
          .animate(_animationController);
      _animationController.reset();
      _animationController.forward();
      setState(() {});
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _animationController.reverse();
    if (_cando) {
      print("do someting...");
      _popFunction();
    }
    _cando = false;
    _enabel = false;
    _right = false;
    _showIcon = false;
  }

  Widget _leftFloatingIcon() {
    return LeftEdgeFloatingIcon(
      width: _edgeFloatingBtnWidth,
      height: _edgeFloatingBtnHeight,
      animation: _animation,
      animationTop: _animationTop,
      icon: _showIcon
          ? _cando
              ? Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: SizedBox(
                    width: 3,
                    height: 28,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                )
          : Container(),
    );
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
        return _popFunction();
      },
      child: GestureDetector(
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Container(
            color: AppColors.primaryGreyBackground,
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Global.appState.showCategory == null
                    ? Center(
                        child: Text('尚未添加分类'),
                      )
                    : Global.appState.showCategory.rssSettings.length == 0
                        ? Center(child: Text('分类下尚未添加RSS'))
                        : Positioned(child: BodyWidget()),
                _leftFloatingIcon(),
                scrollDragtarget(
                  left: 0,
                  onWillAccept: (data) {
                    Global.appState.changeDragChoice(1);
                    return true;
                  },
                  onAccept: (data) {
                    // _draggingChoice = 0;
                    if (Global.scrollController.offset == 0) {
                      toastInfo(msg: topMsg);
                    } else {
                      var offsize = Global.scrollController.offset - height;
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
                        Global.scrollController.position.maxScrollExtent) {
                      toastInfo(msg: bottomMsg);
                    } else {
                      var offsize = Global.scrollController.offset + height;
                      if (offsize >
                          Global.scrollController.position.maxScrollExtent) {
                        offsize =
                            Global.scrollController.position.maxScrollExtent;
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
