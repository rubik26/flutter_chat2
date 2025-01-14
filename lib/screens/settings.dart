import 'package:flutter/material.dart';
import 'package:flutter_chat2/screens/settingScreens/account_settings.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void _onCardTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountSettings(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              _onCardTapped(context);
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Account',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.account_box,
                      color: Theme.of(context).colorScheme.primary,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
