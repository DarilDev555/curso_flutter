import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focus = FocusNode();

    final ontlineInputBorder = UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(20));

    final inputDecoration = InputDecoration(
        hintText: 'Escribe tu mensage',
        enabledBorder: ontlineInputBorder,
        focusedBorder: ontlineInputBorder,
        filled: true,
        suffixIcon: IconButton(
          onPressed: () {
            final textValue = textController.value.text;
            onValue(textValue);
            textController.clear();
          },
          icon: const Icon(Icons.send_outlined),
        ));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: focus,
        controller: textController,
        decoration: inputDecoration,
        onTapOutside: (event) {
          focus.unfocus();
        },
        onFieldSubmitted: (value) {
          onValue(value);
          textController.clear();
          focus.requestFocus();
        },
      ),
    );
  }
}
