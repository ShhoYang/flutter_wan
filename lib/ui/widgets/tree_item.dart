import 'package:flutter/material.dart';
import 'package:flutter_wan/data/protocol/models.dart';
import 'package:flutter_wan/res/colors.dart';
import 'package:flutter_wan/res/strings.dart';
import 'package:flutter_wan/res/style.dart';
import 'package:flutter_wan/utils/navigator_utils.dart';
import 'package:flutter_wan/utils/utils.dart';

class TreeItem extends StatelessWidget {
  final TreeModel model;

  const TreeItem(this.model,{Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> chip = model.children.map((TreeModel _model) {
      return Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        key: ValueKey<String>(_model.name),
        backgroundColor: Utils.getChipBgColor(_model.name),
        label: Text(
          _model.name,
          style: TextStyle(fontSize: 14.0),
        ),
      );
    }).toList();
    return new InkWell(
      onTap: () {
        NavigatorUtils.pushTabPage(context,labelId: Ids.titleSystemTree,title: model.name,treeModel: model);
      },
      child: new _ChipsTile(
        label: model.name,
        children: chip,
      ),
    );
  }
}

class _ChipsTile extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _ChipsTile({Key key, this.label, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> cardChildren = <Widget>[
      new Text(
        label,
        style: TextStyles.listTitle,
      ),
      Gaps.vGap10
    ];
    cardChildren.add(Wrap(
      children: children.map((Widget chip) {
        return Padding(
          padding: EdgeInsets.all(3.0),
          child: chip,
        );
      }).toList(),
    ));
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: cardChildren,
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border(
          bottom: new BorderSide(width: 0.33, color: Colours.divider),
        ),
      ),
    );
  }
}
