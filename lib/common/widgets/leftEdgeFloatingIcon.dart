import 'package:flutter/material.dart';

class LeftEdgeFloatingIcon extends StatefulWidget {
  final double width;
  final double height;
  final double animationTop;
  final Animation animation;
  final Widget icon;

  const LeftEdgeFloatingIcon(
      {Key key,
      this.width,
      this.height,
      this.animationTop,
      this.animation,
      this.icon})
      : super(key: key);

  @override
  _LeftEdgeFloatingIconState createState() => _LeftEdgeFloatingIconState();
}

class _LeftEdgeFloatingIconState extends State<LeftEdgeFloatingIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: widget.animationTop,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return ClipPath(
                clipper: EdgeClipper(
                  height: 150,
                  offset: widget.animation.value,
                ),
                child: Container(
                  color: Colors.black87,
                  width: widget.animation.value,
                  height: 150,
                  child: Row(
                    children: [widget.icon],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EdgeClipper extends CustomClipper<Path> {
  final BuildContext context;
  final bool right;
  final double height;
  final double offset;

  EdgeClipper({
    this.context,
    this.right = false,
    this.height = 200,
    this.offset = 100,
  });
  @override
  Path getClip(Size size) {
    var path = Path();
    // debugPrint("offset: $offset, height: $height");
    if (right) {
      final edgeWidth = MediaQuery.of(context).size.width;
      path.lineTo(edgeWidth, 0);
      path.lineTo(edgeWidth, height);
      var firstPoint = Offset(edgeWidth - offset / 16, height / 8 * 7);
      var secondPoint = Offset(edgeWidth - offset / 4, height / 4 * 3);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, secondPoint.dx, secondPoint.dy);

      var thirdPoint = Offset(edgeWidth - offset / 2, height / 2);
      var fourthPoint = Offset(edgeWidth - offset / 4, height / 4);
      path.quadraticBezierTo(
          thirdPoint.dx, thirdPoint.dy, fourthPoint.dx, fourthPoint.dy);

      var fivePoint = Offset(edgeWidth - offset / 16, height / 8);
      var endPotin = Offset(edgeWidth, 0);
      path.quadraticBezierTo(
          fivePoint.dx, fivePoint.dy, endPotin.dx, endPotin.dy);
    } else {
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
      var firstPoint = Offset(offset / 16, height / 8 * 7);
      var secondPoint = Offset(offset / 4, height / 4 * 3);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, secondPoint.dx, secondPoint.dy);

      var thirdPoint = Offset(offset / 2, height / 2);
      var fourthPoint = Offset(offset / 4, height / 4);
      path.quadraticBezierTo(
          thirdPoint.dx, thirdPoint.dy, fourthPoint.dx, fourthPoint.dy);

      var fivePoint = Offset(offset / 16, height / 8);
      var endPotin = Offset(0, 0);
      path.quadraticBezierTo(
          fivePoint.dx, fivePoint.dy, endPotin.dx, endPotin.dy);
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
