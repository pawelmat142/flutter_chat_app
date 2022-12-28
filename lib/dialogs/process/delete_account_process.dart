import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/config/get_it.dart';
import 'package:flutter_chat_app/config/navigation_service.dart';
import 'package:flutter_chat_app/constants/collections.dart';
import 'package:flutter_chat_app/dialogs/process/log_process.dart';
import 'package:flutter_chat_app/models/notification/pp_notification.dart';
import 'package:flutter_chat_app/models/conversation/pp_message.dart';
import 'package:flutter_chat_app/models/conversation/conversations.dart';
import 'package:flutter_chat_app/models/provider/clear_data.dart';
import 'package:flutter_chat_app/models/contact/contact_uids.dart';
import 'package:flutter_chat_app/models/contact/contacts.dart';
import 'package:flutter_chat_app/models/user/me.dart';
import 'package:flutter_chat_app/models/notification/notifications.dart';
import 'package:flutter_chat_app/models/user/pp_user.dart';
import 'package:flutter_chat_app/models/contact/contacts_service.dart';
import 'package:flutter_chat_app/models/conversation/conversation_service.dart';
import 'package:hive/hive.dart';

///LOGIN PROCESS:
///
/// Login by form triggers sign in fireAuth and login services process:
///
///  - PpUserService login - stores current signed in user nickname
///  #first bcs anything else needs nickname
///
///  - ContactsService login - stores contacts nicknames, contacts User objects with streams,
///  streams triggers events like add/delete conversation (delete account also)
///  stores contacts user objects Stream Controllers
///
///  - ConversationService - stores conversations for each contact,
///  stores Messages collection subscription, listens to contacts events,
///  #after contacts bcs needs contacts
///
///  - PpNotificationService login - stores subscription of notifications collection,
///  login triggers operations sent by other side users as notifications (invitation, clear conversation clear)
///  #last bcs needs access to data stored by other services


///LOGOUT PROCESS:
///
/// Triggered by fireAuth listener or logout button. First logout services:
/// at the moment have no access to uid
///
///  - ConversationService - reset data about conversation,
///
///  - ContactsService - reset data about contacts,
///
///  - PpNotificationService - reset data about notifications
///
/// - PpUserService - reset data about user - set login status to firestore if have access


class DeleteAccountProcess extends LogProcess {

  final _contactsService = getIt.get<ContactsService>();
  final _conversationService = getIt.get<ConversationService>();

  late List<PpUser> _contacts;

  final Me me = Me.reference;
  final Contacts contacts = Contacts.reference;
  final ContactUids contactUids = ContactUids.reference;
  final Notifications notifications = Notifications.reference;
  final Conversations conversations = Conversations.reference;

  String get uid => me.uid;


  WriteBatch? firestoreDeleteAccountBatch;
  int batchValue = 0;

  DeleteAccountProcess() {
    firestoreDeleteAccountBatch = firestore.batch();

    process();
  }

  _batchDelete(DocumentReference ref) async {
    //  default to delete
    if (firestoreDeleteAccountBatch != null) {
      batchValue++;
      firestoreDeleteAccountBatch!.delete(ref);
      await _batchOverload();
    } else {
      throw Exception('NO BATCH!');
    }
  }

  _batchSet({required DocumentReference documentReference, required Map<
      String,
      dynamic> data}) async {
    if (firestoreDeleteAccountBatch != null) {
      batchValue++;
      firestoreDeleteAccountBatch!.set(documentReference, data);
      await _batchOverload();
    } else {
      throw Exception('NO BATCH!');
    }
  }

  _batchOverload() async {
    if (batchValue > 480) {
      log('[!!BATCH OVERLOADED!! - will be continued in another one]');
      await _batchCommit();
      firestoreDeleteAccountBatch = firestore.batch();
      batchValue = 0;
      log('CONTINUATION DELETE ACCOUNT PROCESS');
    }
  }


  _batchCommit() async {
    if (firestoreDeleteAccountBatch != null) {
      log('[START] BATCH COMMIT');
      await firestoreDeleteAccountBatch!.commit();
      log('[STOP] BATCH COMMIT');
      batchValue = 0;
    } else {
      throw Exception('NO BATCH!');
    }
  }


  process() async {
    try {
      super.setProcess('DeleteAccountProcess');
      super.setContext(me.nickname);
      log('[nickname: ${me.nickname}]');

      log('${contactUids.get.length} contact nicknames found');

      await _addDeletedAccountLogBatch();

      await _deleteHiveConversationsData();

      await _prepareBatch();

      await _batchCommit();
      //after this no access to firestore data anymore
      //only stored here remains like nickname, uid, contactUids

      final clearDataProcess = ClearData(NavigationService.context);
      await clearDataProcess.process();
      // await _resetServices();

      await save();

      super.popup.show('Delete account successful!');
    } catch (error) {
      errorHandler(error);
    }
  }

  _addDeletedAccountLogBatch() {
    final documentReference = firestore
        .collection(Collections.DELETED_ACCOUNTS).doc(me.nickname);

    final data = {'uid': uid, 'nickname': me.nickname};

    _batchSet(documentReference: documentReference, data: data);
  }


  _deleteHiveConversationsData() async {
    for (var conversation in conversations.get) {
      await conversation.box.clear();
      log('[DeleteAccountProcess] clear conversation box for ${contacts
          .getByUid(conversation.contactUid)}');
    }
    await Hive.deleteFromDisk();
  }


  _prepareBatch() async {
    log('[START] FIRESTORE BATCH PREPARATION');

    await _prepareBatchSendNotifications();

    await _prepareBatchDeleteSentMessagesToContacts();

    await _prepareBatchDeleteContacts();

    await _prepareBatchDeleteUnreadMessages();

    await _prepareBatchDeleteNotifications();

    await _prepareBatchDeleteUser();

    log('[STOP] FIRESTORE BATCH PREPARATION');
  }


  _prepareBatchSendNotifications() async {
    log(
        '[START] Prepare batch - send notifications to contacts [NOTIFICATIONS]');

    for (var contact in _contacts) {
      final data = PpNotification
          .createContactDeleted(
          sender: me.nickname,
          receiver: contact.nickname
      )
          .asMap;
      await _batchSet(
          documentReference: _contactsService.contactNotificationDocRef(
              contactUid: contact.uid),
          data: data);
      log('Notification for ${contact.nickname} prepared');
    }
    log('[STOP] Prepare batch - send notifications to contacts');
  }

  _prepareBatchDeleteSentMessagesToContacts() async {
    log('[START] Prepare batch - delete sent messages to contacts [Messages]');
    for (var contact in _contacts) {
      final contactMessagesCollectionQuerySnapshot = await _conversationService
          .contactMessagesCollectionRef(contactUid: contact.uid)
          .where(PpMessageFields.sender, isEqualTo: uid).get();
      log('${contactMessagesCollectionQuerySnapshot.docs
          .length} unread messages to delete found for ${contact.nickname}.');

      for (var doc in contactMessagesCollectionQuerySnapshot.docs) {
        await _batchDelete(doc.reference);
      }
      log('[STOP] Prepare batch - delete sent messages to contacts');
    }
  }

  _prepareBatchDeleteContacts() async {
    log('[START] Prepare batch - delete contacts [CONTACTS]');
    await _batchDelete(contactUids.documentRef);
    log('[STOP] Prepare batch - delete contacts [CONTACTS]');
  }

  _prepareBatchDeleteUnreadMessages() async {
    log('[START] Prepare batch - delete messages [Messages]');
    //sent
    final messages = await _conversationService.messagesCollectionRef.get();
    log('${messages.docs.length} messages found to delete.');
    for (var message in messages.docs) {
      await _batchDelete(message.reference);
    }
    log('[STOP] Prepare batch - delete messages [Messages]');
  }

  _prepareBatchDeleteNotifications() async {
    log('[START] Prepare batch - delete notifications [NOTIFICATIONS]');
    final notificationsCollectionQuerySnapshot = await notifications
        .collectionRef.get();
    log('${notificationsCollectionQuerySnapshot.docs
        .length} notifications found to delete.');
    for (var notification in notificationsCollectionQuerySnapshot.docs) {
      await _batchDelete(notification.reference);
    }
    log('[STOP] Prepare batch - delete notifications [NOTIFICATIONS]');
  }

  _prepareBatchDeleteUser() async {
    log('[START] Prepare batch - delete user [User][PRIVATE]');
    await _batchDelete(firestore.collection(Collections.PpUser).doc(uid));
    // await _batchDelete(firestore.collection(Collections.PpUser).doc(States.getUid).collection(Collections.PRIVATE).doc(States.getUid));
    log('[STOP] Prepare batch - delete user [User][PRIVATE]');
  }

}