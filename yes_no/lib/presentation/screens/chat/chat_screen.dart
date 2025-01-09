import 'package:flutter/material.dart';
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
      ),
      body: const _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return (index % 2 == 0)
                    ? const MyMessageBuble()
                    : const TomasMessageBuble();
              },
            )),
            const MessageFieldBox()
          ],
        ),
      ),
    );
  }
}
