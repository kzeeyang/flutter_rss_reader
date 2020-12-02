import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      // headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchInThirdApp(String url) async {
  if (Platform.isAndroid) {
    if (!url.startsWith("vnd.")) {
      url = "vnd." + url;
    }
  } else if (Platform.isIOS) {
    if (!url.startsWith("vnd.")) {
      url = url.substring(4);
    }
  }

  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      // headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}
