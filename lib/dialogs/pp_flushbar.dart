import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/get_it.dart';
import 'package:flutter_chat_app/config/navigation_service.dart';
import 'package:flutter_chat_app/models/notification/pp_notification.dart';
import 'package:flutter_chat_app/models/pp_message.dart';
import 'package:flutter_chat_app/screens/contacts_screen.dart';
import 'package:flutter_chat_app/screens/data_views/notification_view.dart';
import 'package:flutter_chat_app/screens/notifications_screen.dart';
import 'package:flutter_chat_app/services/conversation_service.dart';

class PpFlushbar {

  static String get route => NavigationService.route;

  static void invitationNotification(PpNotification notification) {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'New contacts invitation',
      message: 'Tap to checkout',
      icon: const Icon(Icons.person_add, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () {
        flushbar!.dismiss();
        NotificationView.navigate(notification);
      },
    );
    flushbar.show(NavigationService.context);
  }

  static void invitationSent({PpNotification? notification, int? delay}) async {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'Invitation successfully sent!',
      message: 'Tap to checkout',
      icon: const Icon(Icons.person_add, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () {
        flushbar!.dismiss();
        if (notification != null) NotificationView.navigate(notification);
      },
    );
    if (delay != null) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    flushbar.show(NavigationService.context);
  }

  static void invitationDeleted({int? delay}) async {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'Invitation successfully deleted!',
      message: 'Tap to hide',
      icon: const Icon(Icons.person_add_disabled, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () => flushbar!.dismiss(),
    );
    if (delay != null) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    flushbar.show(NavigationService.context);
  }

  static void invitationAcceptances({List<PpNotification>? notifications, int? delay}) async {
    Flushbar? flushbar;
    final single = notifications != null && notifications.length == 1;
    flushbar = basic(
      title: single ? 'Your invitation has been accepted!' : 'Multiple invitations accepted!',
      message: 'Tap to checkout',
      icon: const Icon(Icons.person_add, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () {
        flushbar!.dismiss();
        Navigator.pop(NavigationService.context);
        if (single) {
          NotificationView.navigate(notifications.first);
        } else {
          Navigator.pushNamed(NavigationService.context, NotificationsScreen.id);
        }
      },
    );
    if (delay != null) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    flushbar.show(NavigationService.context);
  }

  static void contactDeletedNotificationForSender({required String nickname, int? delay}) async {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'Contact deleted!',
      message: nickname,
      icon: const Icon(Icons.person_add_disabled, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () => flushbar!.dismiss(),
    );
    if (delay != null) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    flushbar.show(NavigationService.context);
  }

  static void notificationDeleted() {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'Successful!',
      message: 'Notification deleted',
      icon: const Icon(Icons.comments_disabled, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () => flushbar!.dismiss(),
    );
    flushbar.show(NavigationService.context);
  }

  static void notificationsDeleted() async {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'Done!',
      message: 'All notification are deleted',
      icon: const Icon(Icons.comments_disabled, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () => flushbar!.dismiss(),
    );
    flushbar.show(NavigationService.context);
  }

  static void multipleNotifications({required int value, int? delay}) async {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'You have $value notifications!',
      message: 'Tap to checkout',
      icon: const Icon(Icons.comments_disabled, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () {
        flushbar!.dismiss();
        Navigator.pushNamed(NavigationService.context, NotificationsScreen.id);
      },
    );
    flushbar.show(NavigationService.context);
  }

  static void contactNotExists() {
    Flushbar? flushbar;
    flushbar = basic(
      title: 'Contact does not exist',
      message: 'Tap to hide',
      icon: const Icon(Icons.person_add, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () {
        flushbar!.dismiss();
      },
    );
    flushbar.show(NavigationService.context);
  }

  static void comingMessages({List<PpMessage>? messages, int? delay}) async {
    final title = messages == null || messages.length == 1
      ? 'You have new message'
      : 'You have ${messages.length} new messages';
    final contactsLength = messages != null
        ? messages.map((m) => m.sender).toSet().length
        : 0;
    Flushbar? flushbar;
    flushbar = basic(
      title: title,
      message: 'Tap to checkout',
      icon: const Icon(Icons.comments_disabled, size: 30, color: Colors.white),
      duration: const Duration(seconds: 10),
      onTap: () {
        flushbar!.dismiss();
        if (contactsLength == 1) {
          final conversationService = getIt.get<ConversationService>();
          final contactUser = conversationService.getContactUserByNickname(messages!.first.sender);
          if (contactUser != null) {
            conversationService.navigateToConversationView(contactUser);
          }
        } else {
          NavigationService.popToHome();
          Navigator.pushNamed(NavigationService.context, ContactsScreen.id);
        }
      },
    );
    flushbar.show(NavigationService.context);
  }

  static showBasic(){
    final basicFlushbar = basic();
    basicFlushbar.show(NavigationService.context);
  }

  static Flushbar basic({
    String title = 'Title',
    String? message,
    Duration duration = const Duration(seconds: 5),
    Icon? icon,
    Function? onTap,
    bool hideButtonEnable = true,
    TextButton? mainButton
  }) {
    Flushbar? flushbar;
    TextButton? mainButton;

    if (hideButtonEnable) {
      mainButton = TextButton(
        onPressed: () => flushbar!.dismiss(),
        child: const Text('HIDE')
      );
    }

    flushbar = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.only(top: 10, left: 6, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      borderRadius: BorderRadius.circular(15),
      title: title,
      message: message,
      duration: duration,
      icon: icon,
      mainButton: mainButton,
      onTap: onTap != null ? (x) => onTap() : (x){},
    );
    return flushbar;
  }
}