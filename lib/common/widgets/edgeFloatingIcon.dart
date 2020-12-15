import 'package:flutter/material.dart';

class EdgeFloatingIcon extends StatefulWidget {
  final bool right;
  final double width;
  final double height;
  final double animationTop;
  final Animation animation;
  final Widget icon;

  const EdgeFloatingIcon(
      {Key key,
      this.width,
      this.height,
      this.animationTop,
      this.animation,
      this.icon,
      this.right = false})
      : super(key: key);

  @override
  _EdgeFloatingIconState createState() => _EdgeFloatingIconState();
}

class _EdgeFloatingIconState extends State<EdgeFloatingIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: widget.right ? 0 : null,
          bottom: widget.animationTop,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return ClipPath(
                clipper: EdgeClipper(
                  right: widget.right,
                  height: 150,
                  offset: widget.animation.value,
                ),
                child: Opacity(
                  opacity: 0.8 * widget.animation.value / widget.width,
                  child: Container(
                    color: Colors.black,
                    width: widget.animation.value,
                    height: 150,
                    alignment: widget.right
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: widget.icon,
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
      path.lineTo(size.width, 0);
      path.lineTo(size.width, height);
      var firstPoint = Offset(size.width - offset / 8, height / 8 * 7);
      var secondPoint = Offset(size.width - offset / 2, height / 4 * 3);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, secondPoint.dx, secondPoint.dy);

      var thirdPoint = Offset(size.width - offset, height / 2);
      var fourthPoint = Offset(size.width - offset / 2, height / 4);
      path.quadraticBezierTo(
          thirdPoint.dx, thirdPoint.dy, fourthPoint.dx, fourthPoint.dy);

      var fivePoint = Offset(size.width - offset / 8, height / 8);
      var endPotin = Offset(size.width, 0);
      path.quadraticBezierTo(
          fivePoint.dx, fivePoint.dy, endPotin.dx, endPotin.dy);
    } else {
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
      var firstPoint = Offset(offset / 8, height / 8 * 7);
      var secondPoint = Offset(offset / 2, height / 4 * 3);
      path.quadraticBezierTo(
          firstPoint.dx, firstPoint.dy, secondPoint.dx, secondPoint.dy);

      var thirdPoint = Offset(offset, height / 2);
      var fourthPoint = Offset(offset / 2, height / 4);
      path.quadraticBezierTo(
          thirdPoint.dx, thirdPoint.dy, fourthPoint.dx, fourthPoint.dy);

      var fivePoint = Offset(offset / 8, height / 8);
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
