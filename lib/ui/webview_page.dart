import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage(this.title,this.url, {Key key}):super(key: key);

  @override
  createState() => WebViewState();
}

class WebViewState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.share), onPressed: _share)
          ],
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        )
    );
  }


  void _share() {
    Share.share(widget.url);
  }
}
