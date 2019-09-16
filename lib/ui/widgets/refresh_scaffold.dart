import 'package:flutter/material.dart';
import 'package:flutter_wan/ui/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef void OnLoadMore(bool up);
typedef OnRefreshCallback = Future<void> Function({bool isReload});

class RefreshScaffold extends StatefulWidget {
  final String labelId;
  final int loadStatus;
  final RefreshController controller;
  final bool enablePullUp;
  final OnRefreshCallback onRefresh;
  final OnLoadMore onLoadMore;
  final Widget child;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  RefreshScaffold(
      {Key key,
      this.labelId,
      this.loadStatus,
      this.controller,
      this.enablePullUp: true,
      this.onRefresh,
      this.onLoadMore,
      this.child,
      this.itemCount,
      this.itemBuilder})
      : super(key: key);

  @override
  _RefreshScaffoldState createState() => _RefreshScaffoldState();
}

class _RefreshScaffoldState extends State<RefreshScaffold>
    with AutomaticKeepAliveClientMixin {
  bool isShowFloatBtn = false;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.scrollController.addListener(() {
        int offset = widget.controller.scrollController.offset.toInt();
        if (offset <= 480 && isShowFloatBtn) {
          isShowFloatBtn = false;
          setState(() {});
        } else if (offset > 480 && !isShowFloatBtn) {
          isShowFloatBtn = true;
          setState(() {});
        }
      });
    });
  }

  Widget buildFloatingActionButton() {
    if (widget.controller.scrollController == null ||
        widget.controller.scrollController.offset < 480) {
      return null;
    }

    return new FloatingActionButton(
        heroTag: widget.labelId,
        backgroundColor: Theme.of(context).primaryColor,
        child: new Icon(Icons.keyboard_arrow_up),
        onPressed: () {
          widget.controller.scrollController.animateTo(0.0,
              duration: new Duration(milliseconds: 300), curve: Curves.linear);
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new RefreshIndicator(
            child: new SmartRefresher(
              child: widget.child ??
                  new ListView.builder(
                    itemCount: widget.itemCount,
                    itemBuilder: widget.itemBuilder,
                  ),
              controller: widget.controller,
              enablePullDown: false,
              enablePullUp: widget.enablePullUp,
              enableOverScroll: false,
              onRefresh: widget.onLoadMore,
            ),
            onRefresh: widget.onRefresh,
          ),
          new StatusViews(
            widget.loadStatus,
            onTap: () {
              widget.onRefresh(isReload: true);
            },
          )
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}
