import 'package:shelf/shelf.dart';

import '../galleria.dart';

Future<Response> sendViaTwilio(String phoneNumber, String text) async {
  if (phoneNumber.startsWith('1555') || phoneNumber.startsWith('555')) {
    return Response.ok('The number "$phoneNumber" is not a legitimate number');
  } else {
    final TwilioFlutter _twilioFlutter = TwilioFlutter(
      accountSid: clientAssets.twilio.accountSid,
      authToken: clientAssets.twilio.authToken,
      twilioNumber: clientAssets.twilio.twilioNumber,
    );

    final dateTime = DateTime.now().toIso8601String();

    await _twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: text);
    return Response.ok('Message has been sent: $dateTime');
  }
}
