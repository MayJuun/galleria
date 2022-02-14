import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;

import 'services/listening_controller.dart';

void main() async {
  /// Variable for PORT
  Map<String, String> envVars = Platform.environment;
  var portEnv = envVars['PORT'];
  var PORT = portEnv == null ? 8080 : int.parse(portEnv);

  /// Instantiate Controller to Listen
  final listeningController = ListeningController();

  /// Create server
  final server =
      await shelf_io.serve(listeningController.handler, '0.0.0.0', PORT);
  server.autoCompress = true;

  /// Server on message
  print('☀️ Server running on localhost:${server.port} ☀️');
}
