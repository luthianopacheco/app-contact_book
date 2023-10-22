import 'package:brasil_fields/brasil_fields.dart';

class TextFormatters {
  final text;

  TextFormatters(this.text);

  static String initialsName(String name) {
    final nameSplit = name.split(' ');
    final initials = name.substring(0, 1) + nameSplit.last.substring(0, 1);
    return initials;
  }

  static String phoneNumber(String phone) =>
      UtilBrasilFields.obterTelefone(phone);
}
