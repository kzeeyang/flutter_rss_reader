import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/widgets/gradientCircularProgressIndicator.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';

class RssIcon extends StatefulWidget {
  final RssSetting rss;
  final double size;
  final Function onTap;
  final double stokeWidth;

  const RssIcon({
    Key key,
    this.rss,
    this.size = 30,
    this.onTap,
    this.stokeWidth = 0,
  }) : super(key: key);
  @override
  _RssIconState createState() => _RssIconState();
}

class _RssIconState extends State<RssIcon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _cachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: widget.rss.iconUrl,
      fit: BoxFit.fill,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.size / 2)),
          border: Border.all(
              color: Colors.black38, width: 0.5, style: BorderStyle.solid),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                widget.rss.opened ? null : Colors.black54, BlendMode.hardLight),
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: 130,
        height: 80,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, object, stackTrace) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: widget.rss.opened ? Colors.blue : Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(widget.size / 2)),
            border: Border.all(width: 1, style: BorderStyle.none),
          ),
          // color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            widget.rss.rssName.trim().substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Image image = Image.network(widget.rss.iconUrl);
    // final ImageStream stream = image.image.resolve(ImageConfiguration.empty);

    return Container(
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      child: InkWell(
        child: GradientCircularProgressIndicator(
          colors: [
            Colors.red,
            Colors.amber,
            Colors.cyan,
            Colors.green[200],
            Colors.blue,
            Colors.red
          ],
          radius: widget.size / 2,
          stokeWidth: widget.stokeWidth,
          strokeCapRound: true,
          value: 1,
          child: _cachedNetworkImage(),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}

// class _CircleProgressPaint extends CustomPainter {
//   final double progress;

//   _CircleProgressPaint(this.progress);

//   Paint _paint = Paint()
//     ..style = PaintingStyle.stroke
//     ..strokeWidth = 20;

//   @override
//   void paint(Canvas canvas, Size size) {
//     _paint.shader = ui.Gradient.sweep(
//         Offset(size.width / 2, size.height / 2), [Colors.red, Colors.yellow]);
//     canvas.drawArc(
//         Rect.fromLTWH(0, 0, size.width, size.height), 0, pi*2, false, _paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// Widget RssIcon(
//   RssSetting rss, {
//   double size = 30,
//   Function onTap,
// }) {
//   // return Container(
//   //   width: size,
//   //   height: size,
//   //   alignment: Alignment.center,
//   //   decoration: BoxDecoration(
//   //     color: rss.iconUrl != null
//   //         ? Colors.white
//   //         : rss.opened ? Colors.blue : Colors.black54,
//   //     borderRadius: BorderRadius.circular(size / 2),
//   //     // 圆形图片
//   //     image: rss.iconUrl != null
//   //         ? DecorationImage(
//   //             image: NetworkImage(rss.iconUrl),
//   //             fit: BoxFit.fill,
//   //             colorFilter: rss.opened
//   //                 ? null
//   //                 : ColorFilter.mode(Colors.black54, BlendMode.hardLight),
//   //           )
//   //         : null,
//   //   ),
//   //   child: InkWell(
//   //     child: rss.iconUrl == null
//   //         ? Text(
//   //             rss.rssName.trim().substring(0, 1),
//   //             style: TextStyle(
//   //               color: Colors.white,
//   //               fontSize: 18,
//   //             ),
//   //           )
//   //         : null,
//   //     onTap: onTap,
//   //   ),
//   // );
//   return Container(
//     width: size,
//     height: size,
//     alignment: Alignment.center,
//     child: InkWell(
//       child: _cachedNetworkImage(rss, size),
//       onTap: onTap,
//     ),
//   );
// }

// Future<bool> _loadAsync(String url) async {
//   final HttpClient _httpClient = HttpClient();
//   final HttpClientRequest request =
//       await _httpClient.getUrl(Uri.base.resolve(url));

//   final HttpClientResponse response = await request.close();

//   if (response.length == 0) {
//     return false;
//   }

//   return true;
// }

// Widget _cachedNetworkImage(RssSetting rss, double size) {
//   CachedNetworkImage _cachedNetworkImage;
//   try {
//     _cachedNetworkImage = CachedNetworkImage(
//       imageUrl: rss.iconUrl,
//       fit: BoxFit.fill,
//       imageBuilder: (context, imageProvider) => Container(
//         decoration: BoxDecoration(
//           // color: Colors.grey,
//           borderRadius: BorderRadius.all(Radius.circular(size / 2)),
//           image: DecorationImage(
//               image: imageProvider,
//               fit: BoxFit.fill,
//               colorFilter: ColorFilter.mode(
//                   rss.opened ? null : Colors.black54, BlendMode.hardLight)),
//         ),
//       ),
//       placeholder: (context, url) => Container(
//         width: 130,
//         height: 80,
//         child: Center(
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//           ),
//         ),
//       ),
//       errorWidget: (context, object, stackTrace) {
//         return Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             color: rss.opened ? Colors.blue : Colors.black54,
//             borderRadius: BorderRadius.all(Radius.circular(size / 2)),
//           ),
//           // color: Colors.blue,
//           alignment: Alignment.center,
//           child: Text(
//             rss.rssName.trim().substring(0, 1).toUpperCase(),
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//             ),
//           ),
//         );
//       },
//     );
//   } catch (e, s) {
//     print('error caught from `ImageProvider` \n ####\n $e\n $s\n ####');
//   }
//   return _cachedNetworkImage;
// }

// Widget _imageError(RssSetting rss, double size) {
//   return Container(
//     width: double.infinity,
//     height: double.infinity,
//     decoration: BoxDecoration(
//       color: rss.opened ? Colors.blue : Colors.black54,
//       borderRadius: BorderRadius.all(Radius.circular(size / 2)),
//     ),
//     // color: Colors.blue,
//     alignment: Alignment.center,
//     child: Text(
//       rss.rssName.trim().substring(0, 1).toUpperCase(),
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//       ),
//     ),
//   );
// }
