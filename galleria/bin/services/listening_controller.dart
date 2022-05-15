import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'utils/path_from_payload.dart';
import 'post_request/post_request.dart';

class ListeningController {
  ///Define our getter for our handler
  Handler get handler {
    final router = Router();

    /// main post route (acts the same as put), first gets the resource info
    /// for the new Resource. As long as that is valid, get the past from the
    /// URL, and as long as that exists, pass it onto the post function
    router.post('/', (Request request) async {
      final requestString = await request.readAsString();
      final path = pathFromPayload(requestString);
      if (path.isNotEmpty && path.length == 2) {
        await postRequest(path);
      }
      return Response.ok('Post Request made, but payload incorrect');
      // return Response.notFound('Post Request made, but payload incorrect');
    });

    ///You can catch all verbs and use a URL-parameter with a regular expression
    ///that matches everything to catch app.
    router.all('/<ignored|.*>', (Request request) {
      // return Response.notFound('Page not found');
      return Response.ok('Page not found');
    });

    return router;
  }
}
