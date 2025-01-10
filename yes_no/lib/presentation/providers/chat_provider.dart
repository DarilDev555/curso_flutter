import 'package:flutter/material.dart';
import 'package:yes_no/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final GetYesNoAnswer getYesNoAnswer = GetYesNoAnswer();

  List<Message> messageList = [
    Message(text: 'Hola', fromWho: FromWho.me),
    Message(text: 'Gameseo?', fromWho: FromWho.me),
  ];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);
    moveScrollButton();
    notifyListeners();

    if (text.endsWith('?')) {
      hisReply();
    }
  }

  Future<void> hisReply() async {
    final hisMessage = await getYesNoAnswer.getAnswer();

    messageList.add(hisMessage);
    notifyListeners();
    moveScrollButton();
  }

  Future<void> moveScrollButton() async {
    await Future.delayed(const Duration(milliseconds: 200));

    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut);
  }
}
