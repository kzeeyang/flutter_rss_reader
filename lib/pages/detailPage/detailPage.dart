import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/provider/provider.dart';
import 'package:flutter_rss_reader/common/values/values.dart';
import 'package:flutter_rss_reader/common/widgets/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final MRssItem item;

  const DetailPage({Key key, this.item}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isPageFinished = false;
  double _webViewHeight = 200;
  // 顶部导航
  Widget _buildAppBar() {
    return transparentAppBar(
      context: context,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
            color: AppColors.primaryText,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.share,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            Share.share('${widget.item.title} ${widget.item.link}');
          },
        ),
      ],
    );
  }

// web内容
  Widget _buildWebView() {
    return Container(
      height: _webViewHeight,
      child: WebView(
        initialUrl: '${widget.item.link}',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>[
          _invokeJavascriptChannel(context),
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          if (request.url != '${widget.item.link}') {
            toastInfo(msg: request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          _getWebViewHeight();
          setState(() {
            _isPageFinished = true;
          });
        },
        gestureNavigationEnabled: true,
      ),
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
            _webViewHeight = webHeight;
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

  //正文
  Widget _buildPageView() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildWebView(),
              ],
            ),
          ),
          _isPageFinished == true
              ? Container()
              : Align(
                  alignment: Alignment.center,
                  child: LoadingBouncingGrid.square(),
                ),
        ],
      ),
    );
  }
}
