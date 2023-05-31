import 'dart:convert';

///
class FormDataConverter {
  ///
  static String convertJsonToFormData(Map<String, dynamic> jsonMap) {
    final formData = Map<String, dynamic>.from(jsonMap)
        .map((key, value) => MapEntry(key, jsonEncode(value)));

    final formDataString = formData.entries
        .map((entry) =>
            '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}')
        .join('&');

    return formDataString;
  }
}
