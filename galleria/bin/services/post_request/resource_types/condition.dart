import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import '../../../galleria.dart';

Future<Response> postRequestCondition(String id) async {
  final credentials = await getCredentials();

  /// Create the search request
  final conditionRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(fhirUrl),

    /// resource type
    type: R4ResourceType.Condition,

    /// ID from URL request
    id: id,
  );

  /// get the response
  final conditionResponse = await conditionRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (conditionResponse is Condition) {
    print(prettyJson(conditionResponse.toJson()));

    /// get the subject of the condition
    final subject = conditionResponse.subject.reference;

    /// Ensure the subject is a patient
    if (subject != null && subject.contains('Patient')) {
      /// Create a read request for the patient.
      final patientRequest = FhirRequest.read(
        /// base fhir url
        base: Uri.parse(fhirUrl),

        /// resource type
        type: R4ResourceType.Patient,

        /// ID from subject
        id: subject.split('/').last,
      );

      /// Request the patient
      final patientResponse = await patientRequest.request(
          headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

      if (patientResponse is Patient) {
        print(prettyJson(patientResponse.toJson()));
        final bundle = Bundle(
          type: Code('transaction'),
          entry: <BundleEntry>[
            BundleEntry(
              resource: conditionResponse,
              fullUrl: conditionResponse.id == null
                  ? null
                  : FhirUri('$fhirUrl/${conditionResponse.path}'),
              request: BundleRequest(
                method: Code('PUT'),
                url: FhirUri(conditionResponse.path),
              ),
            ),
            BundleEntry(
              resource: patientResponse,
              fullUrl: patientResponse.id == null
                  ? null
                  : FhirUri('$fhirUrl/${patientResponse.path}'),
              request: BundleRequest(
                method: Code('PUT'),
                url: FhirUri(patientResponse.path),
              ),
            ),
          ],
        );
        print('about to send an email');
        await sendViaEmail(
          'grey.faulkenberry@mayjuun.com',
          'Look at this beautiful bundle!\n'
              '${prettyJson(bundle.toJson())}'
              'This email was created at ${DateTime.now()}',
        );
        await sendViaEmail(
          'sarah.zaporta@mayjuun.com',
          'Look at this beautiful bundle!\n'
              '${prettyJson(bundle.toJson())}'
              'This email was created at ${DateTime.now()}',
        );
        await sendViaEmail(
          'john.manning@mayjuun.com',
          'Look at this beautiful bundle!\n'
              '${prettyJson(bundle.toJson())}'
              'This email was created at ${DateTime.now()}',
        );
        final response = await http.post(
          Uri.parse('https://www.opencitylabs.co/notifications/condition'),
          body: prettyJson(conditionResponse.toJson()),
        );
        return Response(
          response.statusCode,
          body: response.body,
          headers: response.headers,
        );
      } else {
        return Response.badRequest(
            body:
                'The Subject of Condition was ${conditionResponse.subject.reference}, '
                'this was not found on the server:\n'
                '${prettyJson(conditionResponse.toJson())}');
      }
    } else {
      return Response.badRequest(
          body: 'The Subject of Condition with ID: $id was not a Patient'
              '${prettyJson(conditionResponse.toJson())}');
    }
  } else {
    return Response.badRequest(
        body: 'Condition with ID: $id was not found'
            '${prettyJson(conditionResponse.toJson())}');
  }
}
