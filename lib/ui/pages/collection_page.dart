import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/collect_bloc.dart';
import 'package:flutter_wan/blocs/main_bloc.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/ui/widgets/article_item.dart';
import 'package:flutter_wan/ui/widgets/refresh_scaffold.dart';
import 'package:flutter_wan/ui/widgets/repos_item.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CollectionPage extends StatelessWidget {
  final String labelId;

  const CollectionPage({Key key, this.labelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _controller = new RefreshController();
    CollectBloc bloc = BlocProvider.of<CollectBloc>(context);
    MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
    mainBloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });
    bloc.setHomeEventSink(mainBloc.homeEventSink);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(IntlUtil.getString(context, labelId)),
        centerTitle: true,
      ),
      body: new StreamBuilder(
          stream: bloc.collectListStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<ReposModel>> snapshot) {
            int loadStatus =
                Utils.getLoadStatus(snapshot.hasError, snapshot.data);
            if (loadStatus == LoadStatus.loading) {
              bloc.onRefresh(labelId: labelId);
            }

            return new RefreshScaffold(
              labelId: labelId,
              loadStatus: loadStatus,
              controller: _controller,
              onRefresh: ({bool isReload}) {
                return bloc.onRefresh(labelId: labelId, isReload: isReload);
              },
              onLoadMore: (up) {
                bloc.onLoadMore(labelId: labelId);
              },
              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ReposModel model = snapshot.data[index];
                return ObjectUtil.isEmpty(model.envelopePic)
                    ? new ArticleItem(model)
                    : new ReposItem(model);
              },
            );
          }),
    );
  }
}
