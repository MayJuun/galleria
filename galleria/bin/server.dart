import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;

import 'galleria.dart';

// spec: https://github.com/dart-lang/samples/blob/master/server/simple/bin/server.dart
void main() async {
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  // https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  /// Instantiate Controller to Listen
  final listeningController = ListeningController();

  // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
    listeningController.handler,
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  server.autoCompress = true;

  /// Server on message
  print('☀️ Serving at http://${server.address.host}:${server.port} ☀️');
}
