import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat2/screens/all_users.dart';
import 'package:flutter_chat2/screens/settings.dart';
import 'package:flutter_chat2/widgets/chat_messages.dart';
import 'package:flutter_chat2/widgets/new_message.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    final notificationSettings = await fcm.requestPermission();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.music_note,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Musics',
              ),
            ],
            onTap: (value) {
              switch (value) {
                case 0:
                  print('message');
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllUsers(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
