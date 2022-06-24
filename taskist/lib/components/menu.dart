import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  navigationYoutube,
  navigationTwitter,
  userAgent,
  javascriptChannel,
  listCookies,
  clearCookies,
  addCookie,
  setCookie,
  removeCookie,
  search
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, Key? key, required this.func})
      : super(key: key);
  final Completer<WebViewController> controller;
  final Function(bool) func;
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _searchbarCheck = false;
  final CookieManager cookieManager = CookieManager();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: widget.controller.future,
      builder: (context, controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (value) async {
            switch (value) {
              case _MenuOptions.navigationYoutube:
                controller.data!.loadUrl('https://youtube.com');
                break;
              case _MenuOptions.navigationTwitter:
                controller.data!.loadUrl('https://twitter.com/taskist');
                break;
              case _MenuOptions.userAgent:
                final userAgent = await controller.data!
                    .runJavascriptReturningResult('navigator.userAgent');
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(userAgent)));
                break;
              case _MenuOptions.javascriptChannel:
                await controller.data!.runJavascript('''
                var req = new XMLHttpRequest();
                req.open('GET', "https://api.ipify.org/?format=json");
                req.onload = function() {
                  if (req.status == 200) {
                    SnackBar.postMessage(req.responseText);
                  } else {
                    SnackBar.postMessage("Error: " + req.status);
                  }
                }
                req.send();
                ''');
                break;
              case _MenuOptions.clearCookies:
                _onClearCookies();
                break;
              case _MenuOptions.listCookies:
                _onListCookies(controller.data!);
                break;
              case _MenuOptions.addCookie:
                _onAddCookie(controller.data!);
                break;
              case _MenuOptions.setCookie:
                _onSetCookie(controller.data!);
                break;
              case _MenuOptions.removeCookie:
                _onRemoveCookie(controller.data!);
                break;
              case _MenuOptions.search:
                setState(() {
                  _searchbarCheck = !_searchbarCheck;
                  widget.func(_searchbarCheck);
                });
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.navigationYoutube,
              child: Text('Navigate to YouTube'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.navigationTwitter,
              child: Text('Navigate to Twitter'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.userAgent,
              child: Text('Show UserAgent'),
            ),
            const PopupMenuItem(
              value: _MenuOptions.javascriptChannel,
              child: Text('Lookup IP Address'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.addCookie,
              child: Text('Add cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.setCookie,
              child: Text('Set cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.removeCookie,
              child: Text('Remove cookie'),
            ),
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.search,
              child: Text('Search 🔎'),
            )
          ],
        );
      },
    );
  }

  Future<void> _onListCookies(WebViewController controller) async {
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
      ),
    );
  }

  Future<void> _onClearCookies() async {
    final hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _onAddCookie(WebViewController controller) async {
    await controller.runJavascript('''var date = new Date();
  date.setTime(date.getTime()+(30*24*60*60*1000));
  document.cookie = "FirstName=John; expires=" + date.toGMTString();''');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie added.'),
      ),
    );
  }

  Future<void> _onSetCookie(WebViewController controller) async {
    await cookieManager.setCookie(
      const WebViewCookie(name: 'foo', value: 'bar', domain: 'flutter.dev'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie is set.'),
      ),
    );
  }

  Future<void> _onRemoveCookie(WebViewController controller) async {
    await controller.runJavascript(
        'document.cookie="FirstName=John; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie removed.'),
      ),
    );
  }
}
