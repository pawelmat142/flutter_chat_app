import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/notification_tile.dart';
import 'package:flutter_chat_app/config/get_it.dart';
import 'package:flutter_chat_app/constants/styles.dart';
import 'package:flutter_chat_app/models/notification/pp_notification.dart';
import 'package:flutter_chat_app/models/notification/pp_notification_service.dart';
import 'package:flutter_chat_app/screens/forms/elements/pp_button.dart';
import 'package:flutter_chat_app/state/notifications.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  static const String id = 'notifications_screen';

  final notificationService = getIt.get<PpNotificationService>();
  Notifications get notifications => notificationService.notifications;

  List<NotificationTile> _notificationTilesMapper(AsyncSnapshot<List<PpNotification>> snapshot) {
    final data = snapshot.data ?? [];
    data.sort((a, b) => (b.isRead ? 0 : 1));
    return data.map((n) => NotificationTile(n)).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text('NOTIFICATIONS')),

      body: ListView(
        padding: const EdgeInsets.only(top: TILE_PADDING_VERTICAL*2),
        children: [
          StreamBuilder<List<PpNotification>>(
              initialData: notifications.toScreen,
              stream: notifications.toScreenStream,
              builder: (context, snapshot) {
                return snapshot.data != null && snapshot.data!.isNotEmpty

                    ? Column(children: _notificationTilesMapper(snapshot))

                    : nothingHereWidget();
              }
          ),
          removeAllButton(),

        ],
      ),
    );
  }

  removeAllButton() => Padding(
    padding: BASIC_HORIZONTAL_PADDING,
    child: PpButton(text: 'remove all', color: Colors.red, onPressed: () {
      notificationService.onRemoveAll();
  }));

  nothingHereWidget() {
    return const Center(child: Text('Nothing here'));
  }

}