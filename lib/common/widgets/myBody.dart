import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyBody extends StatefulWidget {
  final Widget body;

  final bool showLeftDragItem;
  final bool showRightDragItem;
  final double dragItemWidth;
  final double dragItemHeight;
  final double dragItemEnableWidth;
  final Function onLeftDragEnd;
  final Function onRightDragEnd;

  const MyBody({
    Key key,
    this.body,
    this.showLeftDragItem = true,
    this.showRightDragItem = true,
    this.dragItemWidth = 30,
    this.dragItemHeight = 160,
    this.dragItemEnableWidth = 10,
    this.onLeftDragEnd,
    this.onRightDragEnd,
  }) : super(key: key);
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  double _animationWidth;
  double _animationTop;

  double _startDx;
  double _enbaleWidth = 10;
  double _edgeFloatingBtnHeight = 160;
  double _edgeFloatingBtnWidth = 40;
  bool _enabel = false;
  bool _cando = false;
  bool _showIcon = false;
  bool _right = false;
  // Offset _startOffset;
  // Offset _endOffset;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: const Duration(milliseconds: 0), vsync: this);
    _animation = Tween(begin: 0.0, end: 0).animate(_animationController);

    _enbaleWidth = widget.dragItemEnableWidth;
    _edgeFloatingBtnHeight = widget.dragItemHeight;
    _edgeFloatingBtnWidth = widget.dragItemWidth;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    _startDx = event.position.dx;

    if (_startDx < widget.dragItemEnableWidth) {
      _enabel = true;
    }
    if (_startDx + widget.dragItemEnableWidth > width &&
        widget.showRightDragItem) {
      _enabel = true;
      _right = true;
    }
  }

  Future<void> _onPointerMove(PointerMoveEvent event) async {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    var dx = event.position.dx;
    var dy = event.position.dy;

    if (_enabel) {
      _animationTop = height - dy - _edgeFloatingBtnHeight / 2;
      if (_right) {
        _animationWidth = (width - dx) * 4 * _edgeFloatingBtnWidth / width;
        if (dx < width * 7 / 8) {
          _showIcon = true;
        } else {
          _showIcon = false;
        }
        if (dx > width / 4 * 3) {
          _cando = false;
          debugPrint("cancel do something...");
        } else {
          _cando = true;
          debugPrint("will do something...");
        }
      } else {
        _animationWidth = dx * 4 * _edgeFloatingBtnWidth / width;
        if (dx > width / 8) {
          _showIcon = true;
        } else {
          _showIcon = false;
        }
        if (dx > width / 4) {
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

  void _onPointerUp(PointerUpEvent event) {
    _animationController.reverse();
    if (_cando) {
      if (_right && widget.onRightDragEnd != null) {
        debugPrint("do right someting...");
        Future(widget.onRightDragEnd);
      }
      if (!_right && widget.onLeftDragEnd != null) {
        debugPrint("do left someting...");
        Future(widget.onLeftDragEnd);
      }
    }
    _cando = false;
    _enabel = false;
    _right = false;
    _showIcon = false;
  }

  Widget _floatingIcon() {
    return EdgeFloatingIcon(
      right: _right,
      width: _edgeFloatingBtnWidth,
      height: _edgeFloatingBtnHeight,
      animation: _animation,
      animationTop: _animationTop,
      icon: _showIcon
          ? Padding(
              padding:
                  _right ? EdgeInsets.only(right: 5) : EdgeInsets.only(left: 5),
              child: _cando
                  ? Icon(
                      _right ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                      size: 15,
                      color: Colors.white,
                    )
                  : SizedBox(
                      width: 2,
                      height: 13,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Scrollbar(
                child: widget.body == null ? Container() : widget.body,
              ),
            ],
          ),
          _floatingIcon(),
        ],
      ),
    );
  }
}
