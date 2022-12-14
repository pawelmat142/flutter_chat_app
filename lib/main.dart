import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/conversation/conversation_settings.dart';
import 'package:flutter_chat_app/models/crypto/hive_rsa_pair.dart';
import 'package:flutter_chat_app/models/user/avatar/avatar_hive_image.dart';
import 'package:flutter_chat_app/models/user/pp_user.dart';
import 'package:flutter_chat_app/screens/data_views/conversation_view/conversation_settings_view.dart';
import 'package:flutter_chat_app/screens/data_views/user_view.dart';
import 'package:flutter_chat_app/services/get_it.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_chat_app/models/conversation/conversations.dart';
import 'package:flutter_chat_app/models/contact/contact_uids.dart';
import 'package:flutter_chat_app/models/contact/contacts.dart';
import 'package:flutter_chat_app/models/user/me.dart';
import 'package:flutter_chat_app/models/conversation/pp_message.dart';
import 'package:flutter_chat_app/models/notification/notifications.dart';
import 'package:flutter_chat_app/screens/blank_screen.dart';
import 'package:flutter_chat_app/screens/contacts_screen.dart';
import 'package:flutter_chat_app/screens/data_views/conversation_view/conversation_view.dart';
import 'package:flutter_chat_app/screens/forms/login_form_screen.dart';
import 'package:flutter_chat_app/screens/forms/register_form_screen.dart';
import 'package:flutter_chat_app/screens/notifications_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PpMessageAdapter());
  Hive.registerAdapter(ConversationSettingsAdapter());
  Hive.registerAdapter(AvatarHiveImageAdapter());
  Hive.registerAdapter(HiveRsaPairAdapter());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //TODO: DEVICE NOTIFICATIONOS FEATURE flutter_local_notifications

  //TODO: icon and unread messages counter on it

  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => Me()),
        ChangeNotifierProvider(create: (_) => ContactUids()),
        ChangeNotifierProvider(create: (_) => Contacts()),
        ChangeNotifierProvider(create: (_) => Notifications()),
        ChangeNotifierProvider(create: (_) => Conversations()),
      ],
      child: const MyApp(),
    )
  );

  await initGetIt();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chat app',
      theme: ThemeData.light(),
      navigatorKey: NavigationService.navigatorKey,
      navigatorObservers: [NavigationHistoryObserver()],
      initialRoute: BlankScreen.id,

      onGenerateRoute: (RouteSettings settings) {
        final routes = <String, WidgetBuilder> {
          ConversationView.id: (context) => ConversationView(contactUser: settings.arguments as PpUser),
          UserView.id: (context) => UserView(user: settings.arguments as PpUser),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },

      routes: {
        BlankScreen.id: (context) => const BlankScreen(),

        LoginFormScreen.id: (context) => LoginFormScreen(),
        RegisterFormScreen.id: (context) => RegisterFormScreen(),

        ContactsScreen.id: (context) => const ContactsScreen(),

        ConversationSettingsView.id: (context) => const ConversationSettingsView(),

        NotificationsScreen.id: (context) => const NotificationsScreen(),
      },
    );
  }
}