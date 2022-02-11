import 'dart:convert';

import 'package:fhir/r4/r4.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'post_request.dart';
import 'put_request.dart';

class ListeningController {
  // Define our getter for our handler
  Handler get handler {
    final router = Router();

    // main post route (acts the same as put)
    router.post('/', (Request request) async {
      final requestString = await request.readAsString();
      final path = pathFromPayload(requestString);
      if (path != null) {}
      return Response.notFound('Post Request');
    });

    // You can catch all verbs and use a URL-parameter with a regular expression
    // that matches everything to catch app.
    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}

String? pathFromPayload(String requestString) {
  if (requestString.isNotEmpty) {
    final payloadData = jsonDecode(requestString)?['message']?['data'];
    if (payloadData != null) {
      final data = utf8.fuse(base64).decode(payloadData);
      final dataList = data.split('/');
      if (dataList.length > 1) {
        final shouldBeAType = dataList[dataList.length - 2];
        if (ResourceUtils.resourceTypeFromStringMap.keys
            .contains(shouldBeAType)) {
          return '$shouldBeAType/${dataList.last}';
        }
      }
    }
  }
  return null;
}
