import 'package:shelf/shelf.dart';

import '../../../src/twilio_flutter/twilio_flutter.dart';
import '../twilio_api.dart';

Future<Response> sendViaTwilio(String phoneNumber, String text) async {
  if (phoneNumber.startsWith('1555') || phoneNumber.startsWith('555')) {
    return Response.forbidden(
        'The number "$phoneNumber" is not a legitimate number');
  } else {
    final TwilioFlutter _twilioFlutter = TwilioFlutter(
      accountSid: Twilio.accountSid,
      authToken: Twilio.authToken,
      twilioNumber: Twilio.twilioNumber,
    );

    final dateTime = DateTime.now().toIso8601String();

    await _twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: text);
    return Response.ok('Message has been sent: $dateTime');
  }
}
