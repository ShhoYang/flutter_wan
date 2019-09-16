import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/ui/widgets/likebtn/like_button.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScaffold extends StatefulWidget {
  final String title;
  final String titleId;
  final String url;

  WebScaffold({Key key, this.title, this.titleId, this.url}) : super(key: key);

  @override
  _WebScaffoldState createState() => _WebScaffoldState();
}

class _WebScaffoldState extends State<WebScaffold> {
  void _onPopSelected(String value) {
    String _title = widget.title ?? IntlUtil.getString(context, widget.titleId);
    switch (value) {
      case 'browser':
        NavigatorUtils.launchInBrowser(widget.url, title: _title);
        break;
      case 'collection':
        break;
      case 'share':
        String _url = widget.url;
        Share.share('$_title : $_url');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title ?? IntlUtil.getString(context, widget.titleId),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: <Widget>[
          LikeButton(
            width: 56.0,
            duration: const Duration(milliseconds: 500),
          ),
          new PopupMenuButton(
              padding: EdgeInsets.all(0.0),
              onSelected: _onPopSelected,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                      value: 'browser',
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0.0),
                        dense: false,
                        title: new Container(
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              Icon(
                                Icons.language,
                                color: Colours.gray_66,
                                size: 22.0,
                              ),
                              Gaps.hGap10,
                              Text(
                                '浏览器打开',
                                style: TextStyles.listContent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    new PopupMenuItem<String>(
                      value: 'share',
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0.0),
                        dense: false,
                        title: new Container(
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: Colours.gray_66,
                                size: 22.0,
                              ),
                              Gaps.hGap10,
                              Text(
                                '分享',
                                style: TextStyles.listContent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
        ],
      ),
      body: new WebView(
        onWebViewCreated: (WebViewController webViewController) {},
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
