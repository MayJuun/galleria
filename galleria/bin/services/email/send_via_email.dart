import 'dart:convert';

import 'package:googleapis/gmail/v1.dart' as gMail;
import "package:googleapis_auth/auth_io.dart";
import 'package:shelf/shelf.dart';

import '../api.dart';

Future<Response> sendViaEmail(String email) async {
  String _getBase64Email(String source) => base64UrlEncode(utf8.encode(source));

  final clientCredentials = ServiceAccountCredentials.fromJson(credentials,
      impersonatedUser: 'service.account@mayjuun.com');

  final authClient = await clientViaServiceAccount(
      clientCredentials, ['https://www.googleapis.com/auth/gmail.send']);

  final gmailApi = gMail.GmailApi(authClient);

  String from = 'service.account@mayjuun.com';
  String to = email;
  String subject = 'Message from MayJuun';
  String contentType = 'text/html';
  String charset = 'utf-8';
  String contentTransferEncoding = 'base64';
  String emailContent = '<table></table>';

  await gmailApi.users.messages.send(
      gMail.Message.fromJson({
        'raw': _getBase64Email('From: $from\r\n'
            'To: $to\r\n'
            'Subject: $subject\r\n'
            'Content-Type: $contentType; charset=$charset\r\n'
            'Content-Transfer-Encoding: $contentTransferEncoding\r\n\r\n'
            '$emailContent'),
      }),
      from);

  return Response.ok('Message has been sent: ${DateTime.now()}');
}
