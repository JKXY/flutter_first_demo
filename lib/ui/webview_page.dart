import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage(this.title, this.url, {Key key}) : super(key: key);

  @override
  createState() => WebViewState();
}

class WebViewState extends State<WebViewPage> {
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.share), onPressed: _share)
          ],
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
            Visibility(
              child: LinearProgressIndicator(),
              visible: isLoading
            )
          ],
        ));
  }

  void _share() {
    Share.share(widget.url);
  }
}
