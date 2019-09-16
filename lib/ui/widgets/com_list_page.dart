import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/com_list_bloc.dart';
import 'package:flutter_wan/common/common.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/ui/widgets/article_item.dart';
import 'package:flutter_wan/ui/widgets/refresh_scaffold.dart';
import 'package:flutter_wan/ui/widgets/repos_item.dart';
import 'package:flutter_wan/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComListPage extends StatelessWidget {
  final String labelId;
  final int cid;

  ComListPage({Key key, this.labelId, this.cid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _controller = new RefreshController();
    final ComListBloc bloc = BlocProvider.of<ComListBloc>(context);
    bloc.comListEventStream.listen((event) {
      if (cid == event.cid) {
        _controller.sendBack(false, event.status);
      }
    });
    return new StreamBuilder(
      stream: bloc.comListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ReposModel>> snapshot) {
        int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
        if (loadStatus == LoadStatus.loading) {
          bloc.onRefresh(labelId: labelId, cid: cid);
        }

        return new RefreshScaffold(
          labelId: cid.toString(),
          loadStatus: loadStatus,
          controller: _controller,
          onRefresh: ({bool isReload}) {
            return bloc.onRefresh(labelId: labelId, cid: cid);
          },
          onLoadMore: (up) {
            bloc.onLoadMore(labelId: labelId, cid: cid);
          },
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            ReposModel model = snapshot.data[index];
            return labelId == Ids.titleReposTree
                ? new ReposItem(model)
                : new ArticleItem(model);
          },
        );
      },
    );
  }
}
