import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/values/values.dart';

class ExpansionText extends StatefulWidget {
  final String text;

  final int minLines;
  final int maxLines;

  /// 文字整体样式
  final TextStyle textStyle;

  /// 收起、展开文字颜色
  final Color expandKeyColor;
  final String shrinkText;
  final String expandText;

  /// 结尾按钮是否始终处于显示状态
  final bool isAlwaysDisplay;

  const ExpansionText({
    Key key,
    this.text = '',
    this.minLines,
    this.textStyle,
    this.maxLines,
    this.expandKeyColor = Colors.blue,
    this.shrinkText = '展开',
    this.expandText = '收起',
    this.isAlwaysDisplay = false,
  }) : super(key: key);

  @override
  _ExpansionTextState createState() => _ExpansionTextState();
}

class _ExpansionTextState extends State<ExpansionText> {
  bool _isExpand = false;
  bool _showExpand = false;

  @override
  void initState() {
    // isExpansion();
    super.initState();
  }

  bool isExpansion() {
    TextPainter _textPainter = TextPainter(
      maxLines: widget.minLines,
      text: TextSpan(
        text: widget.text,
        style: widget.textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth:
            MediaQuery.of(context).size.width - AppValue.horizontalPadding * 4,
      );
    if (_textPainter.didExceedMaxLines) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isExpansion()) {
      return Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              maxLines: _isExpand ? widget.maxLines : widget.minLines,
              overflow: _isExpand ? null : TextOverflow.ellipsis,
              style: widget.textStyle,
            ),
            Row(
              children: [
                GestureDetector(
                  child: Text(
                    _isExpand ? widget.expandText : widget.shrinkText,
                    style: TextStyle(
                      fontSize: AppValue.fontSize,
                      color: widget.expandKeyColor,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isExpand = !_isExpand;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              maxLines: _isExpand ? widget.maxLines : widget.minLines,
              overflow: _isExpand ? null : TextOverflow.ellipsis,
              style: widget.textStyle,
            ),
          ],
        ),
      );
    }
  }
}
