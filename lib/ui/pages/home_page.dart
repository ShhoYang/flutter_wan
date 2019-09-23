import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/main_bloc.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/models/models.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/ui/widgets/article_item.dart';
import 'package:flutter_wan/ui/widgets/header_item.dart';
import 'package:flutter_wan/ui/widgets/refresh_scaffold.dart';
import 'package:flutter_wan/ui/widgets/repos_item.dart';
import 'package:flutter_wan/ui/widgets/widgets.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

bool isHomeInit = true;

class HomePage extends StatelessWidget {
  String labelId;

  HomePage({Key key, this.labelId}) : super(key: key);

  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }

    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: new Swiper(
        indicatorAlignment: AlignmentDirectional.topEnd,
        circular: true,
        interval: const Duration(seconds: 5),
        indicator: new NumberSwiperIndicator(),
        children: list.map((model) {
          return new InkWell(
            onTap: () {
              NavigatorUtils.pushWeb(context,
                  title: model.title, url: model.url);
            },
            child: new CachedNetworkImage(
              imageUrl: model.imagePath,
              fit: BoxFit.fill,
              placeholder: (context, url) => new ProgressView(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildRepos(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(
        height: 0.0,
      );
    }

    List<Widget> _children = list.map((model) {
      return new ReposItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      leftIcon: Icons.book,
      titleId: Ids.recRepos,
      onTap: () {
        NavigatorUtils.pushTabPage(context,
            labelId: Ids.titleReposTree, titleId: Ids.titleReposTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(
        height: 0.0,
      );
    }

    List<Widget> _children = list.map((model) {
      return new ArticleItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      titleColor: Colors.green,
      leftIcon: Icons.library_books,
      titleId: Ids.recWxArticle,
      onTap: () {
        NavigatorUtils.pushTabPage(context,
            labelId: Ids.titleWxArticleTree, titleId: Ids.titleWxArticleTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });

    if (isHomeInit) {
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId);
//        bloc.getHotRecItem();
        // todo
//        bloc.getVersion();
      });
    }

    return new StreamBuilder(
        stream: bloc.bannerStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BannerModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            loadStatus: Utils.getLoadStatus(snapshot.hasError, snapshot.data),
            controller: _controller,
            enablePullUp: false,
            onRefresh: ({bool isReload}) {
              return bloc.onRefresh(labelId: labelId);
            },
            child: new ListView(
              children: <Widget>[
                new StreamBuilder(builder:
                    (BuildContext context, AsyncSnapshot<ComModel> snapshot) {
                  ComModel model = bloc.hotRecModel;
                  if (model == null) {
                    return new Container(
                      height: 0.0,
                    );
                  }

                  int status = Utils.getUpdateStatus(model.version);
                  return new HeaderItem(
                    titleColor: Colors.redAccent,
                    title: status == 0 ? model.content : model.title,
                    extra: status == 0 ? 'Go' : '',
                    onTap: () {
                      if (status == 0) {
                        // todo
                      } else {
                        NavigatorUtils.launchInBrowser(model.url,
                            title: model.title);
                      }
                    },
                  );
                }),
                buildBanner(context, snapshot.data),
                new StreamBuilder(
                    stream: bloc.recReposStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildRepos(context, snapshot.data);
                    }),
                new StreamBuilder(
                    stream: bloc.recWxArticleStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildWxArticle(context, snapshot.data);
                    }),
              ],
            ),
          );
        });
  }
}

class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.black45,
        borderRadius: new BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.only(top: 10.0, right: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: new Text(
        '${++index}/$itemCount',
        style: new TextStyle(color: Colors.white70, fontSize: 11.0),
      ),
    );
  }
}
