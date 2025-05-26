import '../models/api_cseiio/errors/user_register_form_is_valid_response_cseiio.dart';

class ErrorsMapper {
  static Map<String, List<String>> errorsUserRegisterFormCseiioToEntity(
    UserRegisterFormIsValidResponseCseiio errors,
  ) => {
    'userName': errors.userName,
    'email': errors.email,
    'password': errors.password,
    'paternalLastName': errors.paternalLastName,
    'maternalLastName': errors.maternalLastName,
    'gender': errors.gender,
    'electoralCode': errors.electoralCode,
    'curp': errors.curp,
    'institutionId': errors.institutionId,
  };
}
