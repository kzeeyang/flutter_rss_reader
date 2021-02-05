import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:flutter_rss_reader/global.dart';

class MyScaffold extends StatefulWidget {
  final WillPopCallback onWillPop;
  final Widget appBar;
  final Widget body;
  final Widget floatingActionButton;

  final bool showLeftDragItem;
  final bool showRightDragItem;
  final double dragItemWidth;
  final double dragItemHeight;
  final double dragItemEnableWidth;
  final Function onLeftDragEnd;
  final Function onRightDragEnd;

  final Color backgroundColor;

  const MyScaffold({
    Key key,
    this.onWillPop,
    this.appBar,
    this.body,
    this.onLeftDragEnd,
    this.onRightDragEnd,
    this.floatingActionButton,
    this.showLeftDragItem = true,
    this.showRightDragItem = true,
    this.dragItemWidth = 40,
    this.dragItemHeight = 120,
    this.dragItemEnableWidth = 10,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  double _animationWidth;
  double _animationTop;

  double _enbaleWidth = 10;
  double _edgeFloatingBtnHeight = 120;
  double _edgeFloatingBtnWidth = 40;
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

    _enbaleWidth = widget.dragItemEnableWidth;
    _edgeFloatingBtnHeight = widget.dragItemHeight;
    _edgeFloatingBtnWidth = widget.dragItemWidth;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    _startOffset = details.globalPosition;
    // debugPrint("startOffset: ${_startOffset.dx}");
    _enbaleWidth =
        Global.appState.mRssItems.length > 0 ? 15 + _enbaleWidth : _enbaleWidth;
    if (_startOffset.dx + _enbaleWidth > screenWidth &&
        widget.showRightDragItem) {
      _enabel = true;
      _right = true;
    }

    if (_startOffset.dx < _enbaleWidth && widget.showLeftDragItem) {
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
        _animationWidth =
            (width - _endOffset.dx) * 4 * _edgeFloatingBtnWidth / width;
        if (_endOffset.dx < width * 7 / 8) {
          _showIcon = true;
        } else {
          _showIcon = false;
        }
        if (_endOffset.dx > width / 4 * 3) {
          _cando = false;
          debugPrint("cancel do something...");
        } else {
          _cando = true;
          debugPrint("will do something...");
        }
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
          ? _cando
              ? Icon(
                  _right ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.white,
                )
              : Padding(
                  padding: _right
                      ? EdgeInsets.only(right: 5)
                      : EdgeInsets.only(left: 5),
                  child: SizedBox(
                    width: 2.5,
                    height: 16,
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
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: GestureDetector(
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Scaffold(
          appBar: widget.appBar,
          backgroundColor: widget.backgroundColor,
          body: Container(
            color: AppColors.primaryGreyBackground,
            child: Stack(
              children: [
                widget.body == null ? Container() : widget.body,
                _floatingIcon(),
              ],
            ),
          ),
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
