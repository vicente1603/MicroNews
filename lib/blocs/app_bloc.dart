import 'package:micro_news/blocs/notifications_bloc.dart';

import 'base_bloc.dart';

class AppBloc implements BlocBase {
  NotificationBloc _notificationBloc;

  AppBloc() {
    _notificationBloc = NotificationBloc();
  }

  Future<void> init() async {
    await _notificationBloc.init();
  }

  NotificationBloc get notificationBloc => _notificationBloc;

  @override
  void dispose() {
    _notificationBloc.dispose();
  }
}
