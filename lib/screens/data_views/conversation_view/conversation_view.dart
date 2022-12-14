import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/conversation/conversation.dart';
import 'package:flutter_chat_app/models/user/me.dart';
import 'package:flutter_chat_app/screens/data_views/conversation_view/message_bubble.dart';
import 'package:flutter_chat_app/screens/data_views/conversation_view/conversation_mock.dart';
import 'package:flutter_chat_app/screens/data_views/conversation_view/conversation_popup_menu.dart';
import 'package:flutter_chat_app/screens/data_views/conversation_view/message_input.dart';
import 'package:flutter_chat_app/services/get_it.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:flutter_chat_app/models/user/pp_user.dart';
import 'package:flutter_chat_app/models/conversation/conversation_service.dart';
import 'package:flutter_chat_app/models/conversation/pp_message.dart';
import 'package:flutter_chat_app/services/uid.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({required this.contactUser, super.key});
  static const id = 'conversation_view';

  final PpUser contactUser;

  static navigate(PpUser contact) {
    Navigator.pushNamed(
      NavigationService.context,
      ConversationView.id,
      arguments: contact
    );
  }

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {

  final conversationService = getIt.get<ConversationService>();

  bool isMock(Box<PpMessage> box) => box.values.length == 1 && box.values.first.isMock;

  PpUser get contactUser => widget.contactUser;
  late Conversation conversation;
  late RSAPrivateKey myPrivateKey;

  @override
  void initState() {
    conversation = conversationService.conversations.getByUid(contactUser.uid)!;
    super.initState();
    conversationService.resolveUnresolvedMessages();
    myPrivateKey = Me.reference.myPrivateKey;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
          title: Text(contactUser.nickname),
          actions: [
            ConversationPopupMenu(conversation: conversation),
          ]
      ),

      body: SafeArea(
        child: Column(children: [

          //MESSAGES AREA
          Expanded(child: ValueListenableBuilder<Box<PpMessage>>(
              valueListenable: conversation.box!.listenable(),
              builder: (context, box, _) {

                if (box.values.isEmpty) return const Center(child: Text('empty!'));

                ///MOCK MESSAGES
                ///are not encrypted!
                if (isMock(box)) return MessageMock(box.values.first, contactUser);

                conversationService.markAsRead(box);

                final interfaces = box.values
                    .where((m) => m.message != '' && !m.isMock)
                    .map((m) => MessageBubbleInterface(
                      message: m.receiver == Uid.get
                          ? decrypt(m.message, myPrivateKey)
                          : m.message,
                      my: m.sender == Uid.get,
                      timestamp: m.timestamp)
                  ).toList();

                interfaces.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                int dayBefore = 0;
                for (var message in interfaces.reversed) {
                  if (message.timestamp.day != dayBefore) {
                    message.divider = true;
                    dayBefore = message.timestamp.day;
                  }
                }

                return ListView(
                  reverse: true,
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  children: interfaces.map((i) => MessageBubble(interface: i)).toList(),
                );
              })
          ),

          MessageInput(conversation: conversation),

        ]),
      ),
    );
  }
}