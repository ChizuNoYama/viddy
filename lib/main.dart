import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/models/conversation.dart';
import 'package:viddy/pages/chat_page.dart';
import 'package:viddy/protocols/userProtocol.dart';

import 'protocols/conversationProtocol.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      Provider(create: (context) => UserProtocol()),
      ProxyProvider<UserProtocol, ConversationProtocol>(update: (context, userProtocol, _) => ConversationProtocol(userProtocol))
    ],
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        home: ChatPage()
    );
  }
}