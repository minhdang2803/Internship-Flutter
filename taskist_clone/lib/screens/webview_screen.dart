import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todoist/components/components.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controller/controllers.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({Key? key}) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final _textController = TextEditingController();
  var controller = Completer<WebViewController>();
  bool _flag = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taskist home page',
          style: Theme.of(context).textTheme.bodyMedium,
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
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    // SystemChannels.textInput.invokeMethod('TextInput.hide');
                    _textController.clear();
                  },
                  child: WebViewStack(controller: controller)))
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
        child: Row(
          children: <Widget>[
            buildTextField(),
            const SizedBox(width: 8),
            buildSearchButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildTextField() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        controller: _textController,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'Enter a keyword to find',
        ),
        style: const TextStyle(fontStyle: FontStyle.normal),
      ),
    );
  }

  Widget buildSearchButton(context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return TextButton(
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.black45),
              ),
              onPressed: () {
                controller.data!.runJavascriptReturningResult(
                    'self.find("${_textController.text}")');
              });
        } else {
          return TextButton(
              child:
                  const Text('Search', style: TextStyle(color: Colors.black45)),
              onPressed: () {});
        }
      },
    );
  }
}


//child: TextButton(