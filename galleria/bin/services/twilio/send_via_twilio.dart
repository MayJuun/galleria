import 'package:shelf/shelf.dart';

import '../../../src/twilio_flutter/twilio_flutter.dart';
import 'api.dart';

Future<Response> sendViaTwilio(String phoneNumber) async {
  final TwilioFlutter _twilioFlutter = TwilioFlutter(
    accountSid: Twilio.accountSid,
    authToken: Twilio.authToken,
    twilioNumber: Twilio.twilioNumber,
  );

  final dateTime = DateTime.now().toIso8601String();

  await _twilioFlutter.sendSMS(
      toNumber: phoneNumber, messageBody: 'Hello from MayJuun! $dateTime');
  return Response.ok('Message has been sent: $dateTime');
}
