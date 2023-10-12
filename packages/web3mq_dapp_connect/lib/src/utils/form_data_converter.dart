///
class FormDataConverter {
  ///
  static String convertJsonToFormData(Map<String, dynamic> jsonMap) {
    return mapToFormDataString(jsonMap);
  }

  ///
  static Map<String, dynamic> convertFormDataStringToMap(
      String formDataString) {
    return formDataStringToMap(formDataString);
  }

  ///
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

  static Map<String, dynamic> formDataStringToMap(String formDataString) {
    final Map<String, dynamic> formDataMap = {};
    final List<String> formDataSegments = formDataString.split('&');
    for (final String formDataSegment in formDataSegments) {
      final List<String> keyValue = formDataSegment.split('=');
      if (keyValue.length != 2) continue; // Skip if not a valid key-value pair

      final String key = Uri.decodeComponent(keyValue[0]);
      final String value = Uri.decodeComponent(keyValue[1]);
      final List<String> keySegments = key.split('[');
      dynamic currentMap = formDataMap;
      for (int i = 0; i < keySegments.length; i++) {
        final String keySegment = keySegments[i].replaceAll(']', '');
        if (keySegment.isEmpty) continue; // Skip if key segment is empty

        if (i == keySegments.length - 1) {
          if (currentMap is List) {
            if (value.isNotEmpty) {
              currentMap.add(value);
            }
          } else {
            currentMap[keySegment] = value;
          }
        } else {
          if (!currentMap.containsKey(keySegment)) {
            if (_isNumeric(keySegments[i + 1].replaceAll(']', ''))) {
              currentMap[keySegment] = [];
            } else {
              currentMap[keySegment] = {};
            }
          }
          currentMap = currentMap[keySegment];
        }
      }
    }
    return formDataMap;
  }

  static bool _isNumeric(dynamic s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
