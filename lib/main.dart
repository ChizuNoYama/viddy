import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viddy/core/assumptions.dart';
import 'package:viddy/pages/chat_page.dart';
import 'package:viddy/pages/home_page.dart';
import 'package:viddy/pages/login_page.dart';
import 'package:viddy/protocols/user_search_cubit.dart';
import 'package:viddy/protocols/userProtocol.dart';
import 'package:viddy/protocols/conversationProtocol.dart';

Future<void> main() async{
  await Supabase.initialize(
    url: Assumptions.SUPABASE_API_URL,
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrenpvcWNxaHVoZGJ0eXV4b3p2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE4Njk3MjAsImV4cCI6MjA0NzQ0NTcyMH0.rSuADI9UNuj96457gWEbe7pL_lguiCzzF6xf_q-Zj1Y"
  );

  // TODO: Check user status here

  runApp(
    MultiProvider(providers: [
      Provider(create: (context) => UserProtocol()),
      ProxyProvider<UserProtocol, ConversationProtocol>(update: (context, userProtocol, _) => ConversationProtocol(userProtocol)),
      BlocProvider(create: (context) => UserSearchCubit(false))
    ],
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage() // TODO: this will be later determined by the status of the user in the main() function
    );
  }
}