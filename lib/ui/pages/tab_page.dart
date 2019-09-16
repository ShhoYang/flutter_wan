import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';
import 'package:flutter_wan/blocs/com_list_bloc.dart';
import 'package:flutter_wan/blocs/tab_bloc.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/ui/widgets/com_list_page.dart';
import 'package:flutter_wan/ui/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';

class TabPage extends StatefulWidget {
  final String labelId;
  final String title;
  final String titleId;
  final TreeModel treeModel;

  TabPage({Key key, this.labelId, this.title, this.titleId, this.treeModel})
      : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<BlocProvider<ComListBloc>> _children = new List();

  @override
  Widget build(BuildContext context) {
    final TabBloc bloc = BlocProvider.of<TabBloc>(context);
    bloc.bindSystemData(widget.treeModel);

    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(
            widget?.title ?? IntlUtil.getString(context, widget.titleId)),
        centerTitle: true,
      ),
      body: new StreamBuilder(
          stream: bloc.tabTreeStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<TreeModel>> snapshot) {
            if (snapshot.data == null) {
              Observable.just(1)
                  .delay(new Duration(milliseconds: 500))
                  .listen((_) {
                bloc.getData(labelId: widget.labelId);
              });

              return new ProgressView();
            }

            _children = snapshot.data
                .map((TreeModel mode) {
                  return new BlocProvider<ComListBloc>(
                      bloc: new ComListBloc(),
                      child: new ComListPage(
                        labelId: widget.labelId,
                        cid: mode.id,
                      ));
                })
                .cast<BlocProvider<ComListBloc>>()
                .toList();
            return new DefaultTabController(
              length: snapshot.data == null ? 0 : snapshot.data.length,
              child: new Column(
                children: <Widget>[
                  new Material(
                    color: Theme.of(context).primaryColor,
                    child: new SizedBox(
                      height: 48.0,
                      width: double.infinity,
                      child: new TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: snapshot.data
                            ?.map(
                              (TreeModel model) => new Tab(text: model.name),
                            )
                            ?.toList(),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new TabBarView(children: _children),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    _children.forEach((p) {
      p.bloc.dispose();
    });
    super.dispose();
  }
}
