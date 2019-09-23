import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/main_bloc.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/ui/widgets/article_item.dart';
import 'package:flutter_wan/ui/widgets/refresh_scaffold.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

bool isEventsInit = true;

class EventsPage extends StatelessWidget {
  const EventsPage({Key key, this.labelId}) : super(key: key);

  final String labelId;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("EventsPage build......");
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });

    if (isEventsInit) {
      LogUtil.e("EventsPage init......");
      isEventsInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId);
      });
    }

    return new StreamBuilder(
        stream: bloc.eventsStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ReposModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            loadStatus: Utils.getLoadStatus(snapshot.hasError, snapshot.data),
            controller: _controller,
            onRefresh: ({bool isReload}) {
              return bloc.onRefresh(labelId: labelId, isReload: isReload);
            },
            onLoadMore: (up) {
              bloc.onLoadMore(labelId: labelId);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return new ArticleItem(snapshot.data[index]);
            },
          );
        });
  }
}
