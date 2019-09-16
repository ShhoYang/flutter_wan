import 'package:flutter/cupertino.dart';
import 'package:flutter_wan/blocs/application_bloc.dart';
import 'package:flutter_wan/blocs/bloc_provider.dart';

class StatusEvent {
  String labelId;
  int status;
  int cid;

  StatusEvent(this.labelId, this.status, {this.cid});
}

class ComEvent {
  int id;
  Object data;

  ComEvent(this.id, this.data);
}

class Event {
  static void sendAppComEvent(BuildContext context, ComEvent event) {}

  static void sendAppEvent(BuildContext context, int id) {
    BlocProvider.of<ApplicationBloc>(context).sendAppEvent(id);
  }
}
