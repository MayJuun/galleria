import 'package:fhir/r4.dart';
import 'package:shelf/shelf.dart';

import '../../../galleria.dart';

Future<Response> postRequestCommunication(Communication communication) async {
  final emailIndex = communication.medium
      ?.indexWhere((element) => element.coding?.first.code == 'EMAILWRIT');
  final phoneIndex = communication.medium
      ?.indexWhere((element) => element.coding?.first.code == 'SMSWRIT');
  final email = emailIndex == null || emailIndex == -1
      ? null
      : communication.medium![emailIndex].text;
  final phone = phoneIndex == null || phoneIndex == -1
      ? null
      : communication.medium![phoneIndex].text;

  Response? emailResponse;
  Response? smsResponse;

  if (email != null) {
    emailResponse = await sendViaEmail(
      email,
      communication.payload?.join('\n\n') ??
          'MayJuun has a new communication to you, but '
              'it has no words. Created at ${DateTime.now()}',
    );
  }
  if (phone != null) {
    smsResponse = await sendViaTwilio(
      phone,
      communication.payload?.join('\n\n') ??
          'MayJuun has a new communication to you, but '
              'it has no words. Created at ${DateTime.now()}',
    );
  }

  if (emailResponse != null && emailResponse.statusCode > 299) {
    return emailResponse;
  } else if (smsResponse != null && smsResponse.statusCode > 299) {
    return smsResponse;
  }

  return Response.ok('Communication successfully sent.');
}
