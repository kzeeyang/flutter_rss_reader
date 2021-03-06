import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/myScaffold.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final MRssItem item;

  const DetailPage({Key key, this.item}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  ScrollController _scrollController = ScrollController();

  bool _isPageFinished = false;
  bool _canCallBack = false;
  bool _canForward = false;
  List<String> _shareEndUrl = new List();

  @override
  void initState() {
    _shareEndUrl.add(widget.item.link);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _canPopCallback() async {
    WebViewController webViewController = await _controller.future;
    _canCallBack = await webViewController.canGoBack();
    setState(() {});
  }

  Future<bool> _canForwardCallback() async {
    WebViewController webViewController = await _controller.future;
    _canForward = await webViewController.canGoForward();
    setState(() {});
    return _canForward;
  }

  Future<bool> _goBackOrPopCallback() async {
    WebViewController webViewController = await _controller.future;
    _canCallBack = await webViewController.canGoBack();
    if (_canCallBack) {
      webViewController.goBack();
      _canCallBack = await webViewController.canGoBack();
      _canForward = await webViewController.canGoForward();
      _shareEndUrl.removeLast();
      setState(() {});
    } else {
      ExtendedNavigator.rootNavigator.pop();
    }
  }

  void _forwardCallback() async {
    WebViewController webViewController = await _controller.future;
    _canCallBack = await webViewController.canGoForward();
    if (_canCallBack) {
      webViewController.goForward();
      _canCallBack = await webViewController.canGoBack();
      _canForward = await webViewController.canGoForward();
      setState(() {});
    } else {
      toastInfo(
        msg: "没有记录",
        toastGravity: ToastGravity.TOP,
      );
    }
  }

  // 顶部导航
  Widget _buildAppBar() {
    return MyAppBar(
      title: widget.item.rssName,
      leading: TransparentIconButton(
        icon: Icon(
          Icons.close,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          ExtendedNavigator.rootNavigator.pop();
        },
      ),
      actions: <Widget>[
        TransparentIconButton(
          icon: Icon(
            Icons.share,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            Share.share('${_shareEndUrl.last}');
          },
        ),
      ],
    );
  }

// web内容
  Widget _buildWebView() {
    return WebView(
      initialUrl: widget.item.link,
      // userAgent:
      //     "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
      //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: true,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      javascriptChannels: <JavascriptChannel>[
        _invokeJavascriptChannel(context),
      ].toSet(),
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith("mailto") ||
            request.url.startsWith("tel") ||
            request.url.startsWith("http") ||
            request.url.startsWith("https")) {
          print('allowing navigation to $request');
          if (request.url.contains(".apk")) {
            bottomModalBottomSheet(
              context: context,
              content: "是否下载安装包",
              height: 150,
              cancel: () {
                ExtendedNavigator.rootNavigator.pop();
              },
              makeSure: () {
                debugPrint("jump to browser download file: ${request.url}");
                launchInBrowser(request.url);
                ExtendedNavigator.rootNavigator.pop();
              },
            );
          }
          _shareEndUrl.add(request.url);
          return NavigationDecision.navigate;
        } else if (request.url.startsWith("jike")) {
          // _launchURL(request.url);
          debugPrint('allowing navigation to $request');
          bottomModalBottomSheet(
            context: context,
            content: "是否跳转到APP打开",
            height: 150,
            cancel: () {
              ExtendedNavigator.rootNavigator.pop();
            },
            makeSure: () {
              debugPrint("jump to browser download file: ${request.url}");
              launchInThirdApp(request.url);
              ExtendedNavigator.rootNavigator.pop();
            },
          );

          return NavigationDecision.prevent;
        }

        debugPrint('blocking navigation to $request}');
        return NavigationDecision.prevent;
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {
        _canPopCallback();
        _isPageFinished = true;
        print('Page finished loading: $url');
      },
    );
  }

  // 注册js回调
  JavascriptChannel _invokeJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Invoke',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
        var webHeight = double.parse(message.message);
        if (webHeight != null) {
          setState(() {
            // _webViewHeight = webHeight;
          });
        }
      },
    );
  }

  // 删除广告
  _removeWebViewAd() async {
    await (await _controller.future)?.evaluateJavascript('''
    try {
          function removeElement(elementName){
            let _element = document.getElementById(elementName);
            if(!_element) {
              _element = document.querySelector(elementName);
            }
            if(!_element) {
              return;
            }
            let _parentElement = _element.parentNode;
            if(_parentElement){
                _parentElement.removeChild(_element);
            }
          }
          removeElement('module-engadget-deeplink-top-ad');
          removeElement('module-engadget-deeplink-streams');
          removeElement('footer');
        } catch{}
    ''');
  }

  // 获取页面高度
  _getWebViewHeight() async {
    await (await _controller.future)?.evaluateJavascript('''
      try {
        // Invoke.postMessage([document.body.clientHeight,document.documentElement.clientHeight,document.documentElement.scrollHeight]);
        let scrollHeight = document.documentElement.scrollHeight;
        if (scrollHeight) {
          Invoke.postMessage(scrollHeight);
        }
      } catch {}
    ''');
  }

  // 获取web浏览器像素密度
  _getWebViewDevicePixelRatio() async {
    await (await _controller.future)?.evaluateJavascript('''
      try {
        Invoke.postMessage(window.devicePixelRatio);
      } catch {}
    ''');
  }

  @override
  Widget build(BuildContext context) {
    // _buildWebView();
    // return WillPopScope(
    //   onWillPop: () async {
    //     if (_canCallBack) {
    //       await _willPopCallback();
    //     } else {
    //       ExtendedNavigator.rootNavigator.pop();
    //     }
    //     return false;
    //   },
    //   child: Scaffold(
    //     appBar: _buildAppBar(),
    //     body: Container(
    //       child: Stack(
    //         children: [
    //           _isPageFinished
    //               ? Container()
    //               : Align(
    //                   alignment: Alignment.center,
    //                   child: LoadingBouncingGrid.square(
    //                     backgroundColor: Colors.blue[400],
    //                   ),
    //                 ),
    //           _buildWebView(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: _buildAppBar(),
      body: MyBody(
        showRightDragItem: _canForward,
        onLeftDragEnd: _goBackOrPopCallback,
        onRightDragEnd: _forwardCallback,
        body: _buildWebView(),
      ),
    );
  }
}
