import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rss_reader/common/utils/screen.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({
    this.imageProvider,
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.heroTag,
  });

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: PhotoView(
                imageProvider: imageProvider,
                loadingChild: loadingChild,
                backgroundDecoration: backgroundDecoration,
                minScale: minScale,
                maxScale: maxScale,
                heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                enableRotation: true,
              ),
            ),
            Positioned(
              right: duSetWidth(10),
              top: MediaQuery.of(context).padding.top,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              right: duSetWidth(10),
              child: IconButton(
                icon: Icon(
                  Icons.file_download,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  // saveFile("assets/images/微信图片_20200602112022.jpg");
                  requestPermission(Permission.storage).then((state) async {
                    if (state) {
                      ByteData imgData = await rootBundle
                          .load("assets/images/微信图片_20200602112022.jpg");
                      saveImg(imgData);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
