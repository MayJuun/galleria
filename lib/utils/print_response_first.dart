import 'package:shelf/shelf.dart';

Response printResponseFirst(String text) {
  print(text);
  return Response.ok(text);
}
