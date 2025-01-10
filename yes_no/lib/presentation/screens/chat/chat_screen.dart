import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no/domain/entities/message.dart';
import 'package:yes_no/presentation/providers/chat_provider.dart';
import 'package:yes_no/presentation/widgets/chat/my_message_buble.dart';
import 'package:yes_no/presentation/widgets/chat/tomas_message_buble.dart';
import 'package:yes_no/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://media.licdn.com/dms/image/v2/D4E03AQG9vivTumsTUQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1729615646699?e=1741824000&v=beta&t=AmdFYtf9vHHVlFQg9hB0Q--c2zUxvvTMpAdjb7gxUSs'),
          ),
        ),
        title: const Text('Tomas'),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.autorenew))],
      ),
      body: const _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messageList.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];
                return (message.fromWho == FromWho.his)
                    ? TomasMessageBuble(
                        message: message,
                      )
                    : MyMessageBuble(
                        message: message,
                      );
              },
            )),
            MessageFieldBox(
              onValue: (value) => chatProvider.sendMessage(value),
            )
          ],
        ),
      ),
    );
  }
}
