///
class FormDataConverter {
  ///
  static String convertJsonToFormData(Map<String, dynamic> jsonMap) {
    return mapToFormDataString(jsonMap);
  }

  static String mapToFormDataString(dynamic data, {String parentKey = ''}) {
    if (data is List) {
      String formData = '';
      for (var i = 0; i < data.length; i++) {
        formData += mapToFormDataString(data[i], parentKey: '$parentKey[$i]');
        if (i < data.length - 1) {
          formData += '&';
        }
      }
      return formData;
    } else if (data is Map) {
      String formData = '';
      data.forEach((key, value) {
        String formDataSegment = mapToFormDataString(value,
            parentKey: parentKey.isEmpty ? key : '$parentKey[$key]');
        formData += formDataSegment;
        if (formDataSegment.isNotEmpty) {
          formData += '&';
        }
      });
      return formData;
    } else {
      return '${Uri.encodeQueryComponent(parentKey)}=${Uri.encodeQueryComponent(data.toString())}';
    }
  }
}
