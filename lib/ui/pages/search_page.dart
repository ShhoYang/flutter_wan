import 'package:flutter/material.dart';
import 'package:flutter_wan/ui/widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: ProgressView(),
    );
  }
}
