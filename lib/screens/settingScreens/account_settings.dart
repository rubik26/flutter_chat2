import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat2/screens/auth.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    String enteredUsername = '';

    void _onChangeUsername() async {
      final isValid = _key.currentState!.validate();

      if (!isValid) {
        return;
      }

      _key.currentState!.save();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'username': enteredUsername,
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Account settings'),
      ),
      body: Column(
        children: [
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                enableSuggestions: false,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 4) {
                    return 'Please enter a valid username(at least 4 characters).';
                  }
                  return null;
                },
                onSaved: (value) {
                  enteredUsername = value!;
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _onChangeUsername,
            child: const Text('Change a username'),
          ),
          const SizedBox(
            height: 100,
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Auth(),
                ),
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 255, 45, 45),
            ),
          ),
        ],
      ),
    );
  }
}
