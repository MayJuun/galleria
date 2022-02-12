import 'package:mailer/smtp_server.dart';
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

  // final smtpServer = gmailRelaySaslXoauth2(userEmail, accessToken);

  final smtpServer = SmtpServer(
    'smtp.gmail.com',
    username: userEmail,
    password: password,
    ssl: true,
    port: 465,
  );

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e, stack) {
    print('Message not sent.');
    print(e);
    print(stack);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  return Response.ok('Message has been sent: ${DateTime.now()}');
}
