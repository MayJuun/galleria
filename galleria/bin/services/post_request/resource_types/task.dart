import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../../../_internal/constants/pretty_json.dart';
import '../../api.dart';
import '../../../_internal/constants/scopes.dart';
import '../../email/send_via_email.dart';
import '../../twilio/send_via_twilio.dart';

Future<Response> postRequestTask(String id) async {
  /// HTTP Client
  final client = http.Client();

  /// Get credentials for service account, must pass account credentials,
  /// proper scopes (which is really just google cloud) and then the http client
  final credentials = await obtainAccessCredentialsViaServiceAccount(
      accountCredentials, scopes, client);

  /// Create the search request for a Task
  var taskRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(fhirUrl),

    /// resource type
    type: R4ResourceType.Task,

    /// ID from URL request
    id: Id(id),
  );

  /// make the request for the Task
  final taskResponse = await taskRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  /// Return an error if the Task isn't found
  if (taskResponse is! Task) {
    return Response.notFound('The Task with ID: $id was not found'
        '${prettyJson(taskResponse.toJson())}');
  }

  /// Who is responsible for completing the Task
  final reference = taskResponse.owner?.reference;

  /// If there isn't one, return an error
  if (reference == null) {
    return Response.notFound('The Task with ID: $id did not have an owner'
        '${prettyJson(taskResponse.toJson())}');
  }

  /// Create the search request for a Patient
  final patientRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(fhirUrl),

    /// resource type
    type: R4ResourceType.Patient,

    /// ID from URL request
    id: Id(reference.split('/').last),
  );

  /// get the response
  final responsiblePersonResponse = await patientRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  /// If there is no responsible person, then return an error
  if (responsiblePersonResponse is! Patient &&
      responsiblePersonResponse is! RelatedPerson) {
    return Response.notFound('The Responsible Person with Id: '
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

  var index = contactPoint?.indexWhere((element) => element.rank?.value == 1);
  index = (index == null || index == -1) && (contactPoint?.length ?? -1) > 0
      ? 0
      : index;

  if (index == null || index == -1) {
    return Response.notFound('The Responsible Person with Id: '
        '${reference.split("/").last} '
        '${prettyJson(taskResponse.toJson())}');
  }
  final telecom = contactPoint![index];
  print(telecom.toJson());

  if (telecom.system == ContactPointSystem.phone ||
      telecom.system == ContactPointSystem.sms) {
    if (telecom.value != null) {
      return await sendViaTwilio(
        telecom.value!,
        'MayJuun has assigned you a new Task, ID: ${taskResponse.id}. '
        'This text was created at ${DateTime.now()}',
      );
    }
  } else if (telecom.system == ContactPointSystem.email) {
    if (telecom.value != null) {
      return await sendViaEmail(
        telecom.value!,
        'MayJuun has assigned you a new Task, ID: ${taskResponse.id}. '
        'This email was created at ${DateTime.now()}',
      );
    }
  }

  return Response.ok(prettyJson(telecom.toJson()));
}
