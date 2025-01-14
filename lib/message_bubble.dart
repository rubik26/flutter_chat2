import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Пузырь сообщения для отображения отдельного сообщения в чате.
class MessageBubble extends StatelessWidget {
  // Создаёт пузырь сообщения, который является первым в последовательности.
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  // Создаёт пузырь сообщения, который продолжает последовательность.
  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  // Указывает, является ли этот пузырь сообщения первым в последовательности сообщений
  // от одного и того же пользователя.
  // Изменяет пузырь сообщения для этих различных случаев - показывает изображение пользователя
  // только для первого сообщения от одного и того же пользователя и изменяет форму пузыря
  // для последующих сообщений.
  final bool isFirstInSequence;

  // Изображение пользователя, которое будет отображаться рядом с пузырем.
  // Не требуется, если сообщение не является первым в последовательности.
  final String? userImage;

  // Имя пользователя.
  // Не требуется, если сообщение не является первым в последовательности.
  final String? username;
  final String message;

  // Управляет выравниванием пузыря сообщения.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<List<Map<String, dynamic>>> _getAllUsers() async {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }

    return FutureBuilder(
        future: _getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              if (userImage != null)
                Positioned(
                  top: 15,
                  // Выравнивание изображения пользователя справа, если сообщение от меня.
                  right: isMe ? 0 : null,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userImage!,
                    ),
                    backgroundColor: theme.colorScheme.primary.withAlpha(180),
                    radius: 23,
                  ),
                ),
              Container(
                // Добавьте отступ для изображения пользователя, если оно существует.
                margin: const EdgeInsets.symmetric(horizontal: 46),
                child: Row(
                  // Сторона экрана чата, на которой должно отображаться сообщение.
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // Первые сообщения в последовательности добавляют визуальный буфер сверху.
                        if (isFirstInSequence) const SizedBox(height: 18),
                        if (username != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                              right: 13,
                            ),
                            child: Text(
                              username!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                        // "Облако" вокруг сообщения.
                        Container(
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.grey[300]
                                : theme.colorScheme.secondary.withAlpha(200),
                            // Показывает "хвостик" пузыря сообщения только если это первое
                            // сообщение в цепочке. Расположение хвостика зависит от того,
                            // является ли сообщение текущего пользователя.
                            borderRadius: BorderRadius.only(
                              topLeft: !isMe && isFirstInSequence
                                  ? Radius.zero
                                  : const Radius.circular(12),
                              topRight: isMe && isFirstInSequence
                                  ? Radius.zero
                                  : const Radius.circular(12),
                              bottomLeft: const Radius.circular(12),
                              bottomRight: const Radius.circular(12),
                            ),
                          ),
                          // Устанавливает разумные ограничения на ширину пузыря сообщения,
                          // чтобы он мог адаптироваться к количеству текста.
                          constraints: const BoxConstraints(maxWidth: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          // Отступ вокруг пузыря.
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          child: Text(
                            message,
                            style: TextStyle(
                              // Добавляет немного межстрочного интервала для улучшения
                              // внешнего вида многострочного текста.
                              height: 1.3,
                              color: isMe
                                  ? Colors.black87
                                  : theme.colorScheme.onSecondary,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
