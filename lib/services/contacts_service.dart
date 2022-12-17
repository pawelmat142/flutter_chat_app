import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/get_it.dart';
import 'package:flutter_chat_app/config/navigation_service.dart';
import 'package:flutter_chat_app/constants/collections.dart';
import 'package:flutter_chat_app/dialogs/popup.dart';
import 'package:flutter_chat_app/dialogs/pp_flushbar.dart';
import 'package:flutter_chat_app/models/user/pp_user.dart';
import 'package:flutter_chat_app/state/contact_nicknames.dart';
import 'package:flutter_chat_app/state/contacts.dart';
import 'package:flutter_chat_app/models/notification/pp_notification.dart';
import 'package:flutter_chat_app/screens/contacts_screen.dart';
import 'package:flutter_chat_app/services/log_service.dart';
import 'package:flutter_chat_app/state/states.dart';

class ContactsService {

  static const String contactsFieldName = 'contacts';

  final _firestore = FirebaseFirestore.instance;
  final _popup = getIt.get<Popup>();
  final _state = getIt.get<States>();
  final logService = getIt.get<LogService>();


  Contacts get contacts => _state.contacts;
  ContactNicknames get contactNicknames => _state.contactNicknames;


  StreamSubscription? _contactNicknamesListener;

  bool initialized = false;

  login() async {
    initialized = false;

    //get initial contactNicknames
    await contactNicknames.startFirestoreObserver();
    contacts.setContactNicknames(contactNicknames.get);

    //get initial contact PpUser objects
    await contacts.startFirestoreObserver();

    _startContactNicknamesListener();

    initialized = true;
  }

  logout() async {
    await _stopContactNicknamesListener();
    await contacts.clear();
    await contactNicknames.clear();
    initialized = false;
  }

  _startContactNicknamesListener() {
    final completer = Completer();
    _contactNicknamesListener ??= _state.contactNicknames.stream.listen((contactNicknames) async {
        logService.log('[ContactNicknames] state listener, lenght: ${contactNicknames.length}');
        if (contactNicknames.isNotEmpty) {
          contacts.setContactNicknames(contactNicknames);
          await contacts.resetFirestoreObserver();
        } else {
          contacts.setContactNicknames([]);
          await contacts.stopFirestoreObserver();
          contacts.setEvent([]);
        }
        if (!completer.isCompleted) completer.complete();
      });
    return completer.future;
  }

  _stopContactNicknamesListener() async {
    if (_contactNicknamesListener != null) {
      await _contactNicknamesListener!.cancel();
      _contactNicknamesListener = null;
    }
  }


  onDeleteContact(PpUser contactUser) async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _popup.show('Are you sure?', error: true,
        text: 'All data will be lost also on the other side!',
        buttons: [PopupButton('Delete', error: true, onPressed: () async {
          NavigationService.popToHome();
          Navigator.pushNamed(NavigationService.context, ContactsScreen.id);
          await _deleteContact(contactUser);
          PpFlushbar.contactDeletedNotificationForSender(nickname: contactUser.nickname, delay: 200);
        })]);
  }

  _deleteContact(PpUser contactUser) async {
    try {
      final conversation = _state.conversations.getByNickname(contactUser.nickname);
      if (conversation != null) await _state.conversations.killBoxAndDelete(conversation);
      await _sendContactDeletedNotification(contactUser);
      _state.contactNicknames.deleteOneEvent(contactUser.uid);
    } catch (error) {
      logService.error(error.toString());
    }
  }

  _sendContactDeletedNotification(PpUser contactUser) async {
    final notification = PpNotification.createContactDeleted(
        documentId: States.getUid,
        sender: _state.nickname,
        receiver: contactUser.nickname);

    await contactNotificationDocRef(contactUid: contactUser.uid).set(notification.asMap);
  }

  DocumentReference contactNotificationDocRef({required String contactUid}) => _firestore
      .collection(Collections.PpUser).doc(contactUid)
      .collection(Collections.NOTIFICATIONS).doc(States.getUid);

  getBy({required String nickname}) => contacts.getBy(nickname);

  contactExists(String contactUid) => contactNicknames.contains(contactUid);

}