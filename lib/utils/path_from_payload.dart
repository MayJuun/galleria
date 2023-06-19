import 'dart:convert';

import 'package:fhir/r4.dart';

/// Checks on the path from the payload. It shold be passed the payload (which)
/// in our case is the body of the message. It will check to ensure it's not
/// an empty string, then will look for the data from the payload.message.data
/// field (which is 64bit encoded). So we decode all of that to make it
/// human readable, check some things to ensure it's the proper format, and
/// as long as it is, returns a list of the format, [ResourceType, Id]
List<String> pathFromPayload(String requestString) {
  if (requestString.isNotEmpty) {
    final payloadData = jsonDecode(requestString)?['message']?['data'];
    if (payloadData != null) {
      final data = utf8.fuse(base64).decode(payloadData);
      final dataList = data.split('/');
      if (dataList.length > 1) {
        final shouldBeAType = dataList[dataList.length - 2];
        if (resourceTypeFromStringMap.keys.contains(shouldBeAType)) {
          return [shouldBeAType, dataList.last];
        }
      }
    }
  }
  return [];
}
