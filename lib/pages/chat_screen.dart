import 'package:chat_app/constants.dart';
import 'package:chat_app/models/messages.dart';
import 'package:chat_app/widgets/bubble_chat_receiver.dart';
import 'package:chat_app/widgets/bubble_chat_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {
  static String id = "chat screen";

  @override
  State<chatScreen> createState() =>
      _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(
        kMessagesCollections,
      );
  final TextEditingController controller =
      TextEditingController();
  final ScrollController _scrollController =
      ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage(
    String data,
    String senderId,
  ) {
    messages.add({
      kMessageText: data,
      kCreatedAt: DateTime.now(),
      kId: senderId,
    });
    controller.clear();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String senderId =
        'your_current_user_email';

    return StreamBuilder<QuerySnapshot>(
      stream:
          messages
              .orderBy(
                kCreatedAt,
                descending: true,
              )
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("there was an error"),
          );
        }

        List<Message> messagesList =
            snapshot.data!.docs.map((doc) {
              return Message.fromJson(
                doc.data()
                    as Map<String, dynamic>,
              );
            }).toList();

        if (messagesList.isNotEmpty) {
          WidgetsBinding.instance
              .addPostFrameCallback(
                (_) => _scrollToBottom(),
              );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            title: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Image.asset(kLogo, height: 30),
                const Text(
                  " Chat ",
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: "Pacifico",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9575CD),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/faf22eaf-7d73-4f8b-9dc2-c60cf5387878.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller:
                          _scrollController,
                      reverse: true,
                      itemCount:
                          messagesList.length,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final message =
                            messagesList[index];

                        if (message.id ==
                            senderId) {
                          return buildMessageBubbleSender(
                            messageText:
                                message.content,
                            showTail: true,
                          );
                        } else {
                          return buildMessageBubbleReceiver(
                            messageText:
                                message.content,
                            showTail: true,
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                controller,
                            onSubmitted: (data) {
                              if (data
                                  .isNotEmpty) {
                                _sendMessage(
                                  data,
                                  senderId,
                                );
                              }
                            },
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText:
                                  "Send Message",
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons
                                      .send_sharp,
                                  color:
                                      Colors
                                          .black,
                                ),
                                onPressed: () {
                                  if (controller
                                      .text
                                      .isNotEmpty) {
                                    _sendMessage(
                                      controller
                                          .text,
                                      senderId,
                                    );
                                  }
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      16,
                                    ),
                                borderSide:
                                    const BorderSide(
                                      color: Color(
                                        0xFFB39DDB,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons
                              .settings_voice_rounded,
                          color: const Color(
                            0xFFB39DDB,
                          ),
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
