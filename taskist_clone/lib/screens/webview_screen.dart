import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todoist/components/components.dart';
import 'package:todoist/components/menu.dart';
import 'package:todoist/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/controllers.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({Key? key}) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  var controller = Completer<WebViewController>();
  bool _flag = false;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taskist home page',
          style: TaskistTheme.lightTextTheme.bodyMedium,
        ),
        actions: [
          NavigationControls(
            controller: controller,
          ),
          Menu(
            controller: controller,
            func: (bool callbackValue) {
              setState(() {
                _flag = callbackValue;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          buildSearchBar(),
          Expanded(child: WebViewStack(controller: controller))
        ]),
      ),
    );
  }

  Widget buildSearchBar() {
    return Visibility(
      visible: _flag,
      child: Container(
        width: double.infinity,
        color: Colors.blue,
        height: MediaQuery.of(context).size.height * 0.05,
        child: Row(children: <Widget>[
          // buildTextField(),
          const SizedBox(width: 8),
          // buildSearchButton(),
        ]),
      ),
    );
  }
}
