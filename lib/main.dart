import 'package:community_chat_forum/firebase_options.dart';
import 'package:community_chat_forum/pages/home.dart';
import 'package:community_chat_forum/pages/login.dart';
import 'package:community_chat_forum/pages/add_communities.dart';
import 'package:community_chat_forum/pages/login_loading.dart';
import 'package:community_chat_forum/pages/community_groups.dart';
import 'package:community_chat_forum/pages/chat_room.dart';
import 'package:community_chat_forum/pages/create_community.dart';
import 'package:community_chat_forum/pages/create_group.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ComChat",
      initialRoute: "/login",
      routes: {
        "/": (context) => Home(),
        "/login": (context) => Login(),
        "/loading": (context) => LoadingScreen(),
        "/addcom": (context) => AddCommunites(),
        "/groups": (context) => GroupsPage(),
        "/chatroom": (context) => ChatRoom(),
        "/createCom": (context) => CreateCommunityPage(),
        "/createGroup": (context) => CreateGroupPage()
      },
    );
  }
}

