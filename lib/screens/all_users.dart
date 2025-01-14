import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  Future<List<Map<String, dynamic>>> _getAllUsers() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final username = user['username'] as String?;
              final userImage = user['image_url'] as String?;

              return ListTile(
                leading: userImage != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                      )
                    : const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                title: Text(username ?? 'Unknown User'),
              );
            },
          );
        },
      ),
    );
  }
}
