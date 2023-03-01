import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:form_validator/form_validator.dart';
import 'package:shelf/shelf.dart';

import '../../galleria.dart';

Future<Response> postRequestCommunicationRequest(String id) async {
  final credentials = await getCredentials();

  /// Create the search request
  final readCommunicationRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(getFhirUrl()),

    /// resource type
    type: R4ResourceType.CommunicationRequest,

    /// ID from URL request
    id: id,
  );

  /// get the response
  final communicationRequest = await readCommunicationRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (communicationRequest is! CommunicationRequest) {
    return printResponseFirst(
        'No CommunicationRequest was found with the given ID');
  } else {
    /// Get Email Address - if available
    String? emailAddress = _emailAddress(communicationRequest.medium);

    final emailValidator = ValidationBuilder().email().build();

    /// If we found something but it's not valid
    if (emailAddress != null && emailValidator(emailAddress) != null) {
      /// Put emailAddress back to null
      emailAddress = null;
    }

    /// Get Phone Number - if available
    String? phoneNumber = _phoneNumber(communicationRequest.medium);
    final numberValidator = ValidationBuilder().phone().build();

    /// If we found something but it's not valid
    if (phoneNumber != null && numberValidator(phoneNumber) != null) {
      /// Put phoneNumber back to null
      phoneNumber = null;
    }

    /// Pull the actual message to send
    final message = communicationRequest.payload
        ?.map((e) => e.contentString)
        .toList()
        .join('\n\n');

    /// Responses that we plan to get
    Response? emailResponse;
    Response? smsResponse;

    /// Try multiple times if needed
    // for (var i = 0; i < numberOfTries; i++) {
    /// as long as email exists AND the status code is not successful
    if (emailAddress != null && (emailResponse?.statusCode ?? 300) > 299) {
      /// try and send the email again
      emailResponse = await _emailResponse(emailAddress, message);
    }

    /// as long as phoneNumber exists AND the status code is not successful
    if (phoneNumber != null && (smsResponse?.statusCode ?? 300) > 299) {
      /// try and send the SMS message again
      // TODO: turn this back on when ready
      // smsResponse = await _smsResponse(phoneNumber, message);
    }

    /// If either phoneNumber or email exists and is still not successful
    // if ((emailAddress != null && (emailResponse?.statusCode ?? 300) > 299) ||
    //     (phoneNumber != null && (smsResponse?.statusCode ?? 300) > 299)) {
    //   /// We wait for a specified amount of time and then try again
    //   await timeoutDelay(i);
    // } else {
    //   break;
    // }
    // }

    /// Check one more time to see if we're successful, except this time see if
    /// either is successful (more parentheses than needed, but it exactly
    /// mirrors above this way)
    Communication? communication;
    if (!((emailAddress != null && (emailResponse?.statusCode ?? 300) > 299) ||
        (phoneNumber != null && (smsResponse?.statusCode ?? 300) > 299))) {
      /// As long as one is, we consider it a success, and create the communication
      communication = _communicationFromRequest(communicationRequest, true);
    } else {
      communication = _communicationFromRequest(communicationRequest, false);
    }

    /// Create the Request for a new resource
    final serverCommunicationRequest = FhirRequest.create(
      /// base fhir url
      base: Uri.parse(getFhirUrl()),

      /// resource
      resource: communication,
    );

    /// Upload the communication to the server
    await serverCommunicationRequest.request(
        headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

    /// if emailResponse is unsuccessful
    if (emailResponse != null && emailResponse.statusCode > 299) {
      /// AND smsResponse is unsuccessful
      if (smsResponse != null && smsResponse.statusCode > 299) {
        /// return the emailResponse
        return emailResponse;
      } else {
        /// Otherwise, return that SMS was successful but not email
        return printResponseFirst(
            'Communication successfully sent via SMS but NOT via email.');
      }
    } else {
      /// check if SMS was successful as well
      if (smsResponse != null && smsResponse.statusCode > 299) {
        /// Return that email was successful but not SMS
        return printResponseFirst(
            'Communication successfully sent via email but NOT via SMS.');
      } else {
        return printResponseFirst(
            'Communication successfully sent via email and SMS.');
      }
    }
  }
}

String? _emailAddress(List<CodeableConcept>? medium) {
  final emailIndex = medium
      ?.indexWhere((element) => element.coding?.first.code == 'EMAILWRIT');
  return emailIndex == null || emailIndex == -1
      ? null
      : medium![emailIndex].text;
}

String? _phoneNumber(List<CodeableConcept>? medium) {
  final phoneIndex =
      medium?.indexWhere((element) => element.coding?.first.code == 'SMSWRIT');
  return phoneIndex == null || phoneIndex == -1
      ? null
      : medium![phoneIndex].text;
}

Future<Response> _emailResponse(String email, String? message) async =>
    await sendViaEmail(
      email,
      message ??
          'MayJuun has a new communication to you, but '
              'it has no words. Created at ${DateTime.now()}',
    );

Future<Response> _smsResponse(String phone, String? message) async =>
    await sendViaTwilio(
      phone,
      message ??
          'MayJuun has a new communication to you, but '
              'it has no words. Created at ${DateTime.now()}',
    );

Communication _communicationFromRequest(
        CommunicationRequest communicationRequest, bool successful) =>
    Communication(
      basedOn: communicationRequest.basedOn,
      status: successful ? Code('in-progress') : Code('completed'),
      category: communicationRequest.category,
      priority: communicationRequest.priority,
      medium: communicationRequest.medium,
      subject: communicationRequest.subject,
      about: communicationRequest.about,
      encounter: communicationRequest.encounter,
      payload: communicationRequest.payload
          ?.map(
            (element) => CommunicationPayload(
              contentString: element.contentString,
              contentAttachment: element.contentAttachment,
              contentReference: element.contentReference,
            ),
          )
          .toList(),
      sent: FhirDateTime(DateTime.now()),
      recipient: communicationRequest.recipient,
      sender: communicationRequest.sender,
      reasonCode: communicationRequest.reasonCode,
      reasonReference: communicationRequest.reasonReference,
      note: communicationRequest.note,
    );
