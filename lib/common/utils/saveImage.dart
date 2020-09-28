import 'dart:typed_data';

import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

void saveImg(ByteData imgData) async {
  final result =
      await ImageGallerySaver.saveImage(imgData.buffer.asUint8List());

  if (result != "") {
    String path = result.toString().substring(7, result.toString().length - 18);
    toastInfo(
      msg: '已保存图片至 $path 文件夹',
      toastGravity: ToastGravity.BOTTOM,
    );
  }
}
