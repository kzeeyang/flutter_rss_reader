import 'dart:io';

import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFile(String data) async {
  String filePath =
      "/storage/emulated/0/flutter_rss_reader/file/flutter_rss_reader.txt";

  final file = File(filePath);
  bool had = await file.exists();
  if (!had) {
    file.create(recursive: true);
  }
  file.writeAsString(data);
  toastInfo(
    msg: '数据已保存至 $filePath',
    toastGravity: ToastGravity.BOTTOM,
  );
}
