import 'dart:async';

import 'package:auto_route/auto_route.dart';
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

  @override
  void initState() {
    super.initState();
  }

  // 顶部导航
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        widget.item.rssName,
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: AppColors.fontMontserrat,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.primaryText,
        ),
        onPressed: () {
          ExtendedNavigator.rootNavigator.pop();
        },
      ),
      actions: <Widget>[
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
    return WebView(
      initialUrl: widget.item.link,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _controller.complete(webViewController);
      },
      javascriptChannels: <JavascriptChannel>[
        _invokeJavascriptChannel(context),
      ].toSet(),
      navigationDelegate: (NavigationRequest request) {
        print('${request.url}');

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

  //正文
  Widget _buildPageView() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    _buildWebView();
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: Stack(
          children: [
            _isPageFinished
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: LoadingBouncingGrid.square(
                      backgroundColor: Colors.blue[400],
                    ),
                  ),
            _buildWebView(),
          ],
        ),
      ),
    );
  }
}
