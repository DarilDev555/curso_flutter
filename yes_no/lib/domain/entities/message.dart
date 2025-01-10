enum FromWho { me, his }

class Message {
  final String text;
  final String? imageUril;
  final FromWho fromWho;

  Message({required this.text, this.imageUril, required this.fromWho});
}
