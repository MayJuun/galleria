import 'dart:developer';

import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:shelf/shelf.dart';

import '../../galleria.dart';

Future<Response> postRequestTask(String id) async {
  final credentials = await getCredentials();

  /// Create the search request for a Task
  var taskRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(getFhirUrl()),

    /// resource type
    type: R4ResourceType.Task,

    /// ID from URL request
    id: id,
  );

  /// make the request for the Task
  final taskResponse = await taskRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  /// Return an error if the Task isn't found
  if (taskResponse is! Task) {
    return printResponseFirst('The Task with ID: $id was not found'
        '${prettyJson(taskResponse.toJson())}');
  } else {
    final pastCommunicationRequest = FhirRequest.search(
      /// base fhir url
      base: Uri.parse(getFhirUrl()),

      /// resource type
      type: R4ResourceType.Communication,

      /// Reference this task
      parameters: ['based-on=${taskResponse.path}'],
    );

    final pastCommunicationResponse = await pastCommunicationRequest.request();

    if (pastCommunicationResponse is! Bundle) {
      return printResponseFirst(
          'Tried to request past Communications about the Task '
          'with ID: $id, and didn\'t return a Bundle, this is wrong');
    }

    final firstCommunicationIndex = (pastCommunicationResponse.entry
        ?.indexWhere((element) => element.resource is Communication));
    if (firstCommunicationIndex != null && firstCommunicationIndex != -1) {
      return printResponseFirst('Has already sent Communications');
    }

    /// Who is responsible for completing the Task
    final reference = taskResponse.owner?.reference;

    /// If there isn't one, return an error
    if (reference == null) {
      return printResponseFirst('The Task with ID: $id did not have an owner'
          '${prettyJson(taskResponse.toJson())}');
    }

    /// Create the search request for a Patient
    final patientRequest = FhirRequest.read(
      /// base fhir url
      base: Uri.parse(getFhirUrl()),

      /// resource type
      type: R4ResourceType.Patient,

      /// ID from URL request
      id: reference.split('/').last,
    );

    /// get the response
    final responsiblePersonResponse = await patientRequest.request(
        headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

    /// If there is no responsible person, then return an error
    if (responsiblePersonResponse is! Patient &&
        responsiblePersonResponse is! RelatedPerson) {
      return printResponseFirst('The Responsible Person with Id: '
          '${reference.split("/").last} was not found '
          '${prettyJson(taskResponse.toJson())}');
    }

    List<ContactPoint>? contactPoint;

    if (responsiblePersonResponse is Patient) {
      contactPoint = responsiblePersonResponse.telecom;
    }
    if (responsiblePersonResponse is RelatedPerson) {
      contactPoint = responsiblePersonResponse.telecom;
    }

    /// See if there is phone number to send an SMS
    var phoneIndex = contactPoint
        ?.indexWhere((element) => element.system == ContactPointSystem.sms);
    if (phoneIndex == null || phoneIndex == -1) {
      phoneIndex = contactPoint
          ?.indexWhere((element) => element.system == ContactPointSystem.sms);
    }

    /// See if there's an address to send an email
    final emailIndex = contactPoint
        ?.indexWhere((element) => element.system == ContactPointSystem.email);

    /// If there's neither, we return a not found response
    if ((phoneIndex == null || phoneIndex == -1) &&
        (emailIndex == null || emailIndex == -1)) {
      return printResponseFirst('No ability to communication with the person'
          'responsible (id: ${reference.split("/").last}) for Task $id');
    }

    /// Get the phone number
    final phoneNumber = phoneIndex != null && phoneIndex != -1
        ? contactPoint![phoneIndex].value
        : null;
    final emailAddress = emailIndex != null && emailIndex != -1
        ? contactPoint![emailIndex].value
        : null;

    final communicationRequest = CommunicationRequest(
        basedOn: [taskResponse.thisReference],
        status: Code('active'),
        category: [
          CodeableConcept(coding: [
            Coding(
                code: Code('notification'),
                system: FhirUri(
                    'http://terminology.hl7.org/CodeSystem/communication-category'))
          ])
        ],
        priority: Code('routine'),
        payload: [
          CommunicationRequestPayload(
              contentString:
                  'MayJuun has assigned you a new Task at ${DateTime.now()}, '
                  'click here to complete it: '
                  'https://cuestionario-dev-mctbmzb4uq-uk.a.run.app'
                  '?requestNumber=${taskResponse.id}.'),
        ],
        occurrenceDateTime: FhirDateTime(DateTime.now()),
        authoredOn: FhirDateTime(DateTime.now()),
        requester: taskResponse.requester,
        recipient: [
          responsiblePersonResponse.thisReference,
        ],
        sender: Reference(
            display: 'MayJuun',
            type: FhirUri('Organization'),
            reference: 'Organization/8e1108ed-9a9f-4378-a9dd-765878cf52e8'),
        medium: [
          if (emailAddress != null)
            CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/v3-ParticipationMode'),
                  code: Code('EMAILWRIT'),
                  display: 'email',
                )
              ],
              text: emailAddress,
            ),
          if (phoneNumber != null)
            CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/v3-ParticipationMode'),
                  code: Code('SMSWRIT'),
                  display: 'SMS message',
                ),
              ],
              text: phoneNumber,
            ),
        ]);

    /// Create the search request for a Patient
    final communicationRequestRequest = FhirRequest.create(
      /// base fhir url
      base: Uri.parse(getFhirUrl()),

      /// resource
      resource: communicationRequest,
    );

    final communicationRequestResponse = await communicationRequestRequest
        .request(headers: {
      'Authorization': 'Bearer ${credentials.accessToken.data}'
    });

    if (communicationRequestResponse is CommunicationRequest) {
      return printResponseFirst(
          'Successfully created CommunicationRequest for Task/$id');
    } else {
      return printResponseFirst(
          'Unable to create CommunicationRequest for Task/$id');
    }
  }
}

Response printResponseFirst(String text) {
  print(text);
  return Response.ok(text);
}
