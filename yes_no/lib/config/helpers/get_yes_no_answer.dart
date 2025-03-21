import 'package:dio/dio.dart';
import 'package:yes_no/domain/entities/message.dart';
import 'package:yes_no/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer() async {
    final responce = await _dio.get('https://yesno.wtf/api');

    final yesNoModel = YesNoModel.fromJsonMap(responce.data);

    return yesNoModel.toMessageEntity();
  }
}
