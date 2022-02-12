import 'package:shelf/shelf.dart';
import 'package:mailer/mailer.dart';

import 'api.dart';

Future<Response> sendViaEmail(String email) async {
  // Create our message.
  final message = Message()
    ..from = Address('service.account@mayjuun.com', 'MayJuun')
    ..recipients.add(email)
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  return Response.ok('Message has been sent: ${DateTime.now()}');
}
