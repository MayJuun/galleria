import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:shelf/shelf.dart';

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
    id: Id(id),
  );

  /// get the response
  final conditionResponse = await conditionRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (conditionResponse is Condition) {
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
        id: Id(subject.split('/').last),
      );

      /// Request the patient
      final patientResponse = await patientRequest.request(
          headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

      if (patientResponse is Patient) {
        final bundle = Bundle(
          type: BundleType.transaction,
          entry: <BundleEntry>[],
        );

        for (var resource in [conditionResponse, patientResponse]) {
          bundle.entry!.add(
            BundleEntry(
              resource: resource,
              fullUrl: resource.id == null
                  ? null
                  : FhirUri('$fhirUrl/${resource.path}'),
              request: BundleRequest(
                method: BundleRequestMethod.put,
                url: FhirUri(resource.path),
              ),
            ),
          );
        }
        return await sendViaEmail(
          'grey.faulkenberry@mayjuun.com',
          'Look at this beautiful bundle!\n'
              '${prettyJson(bundle.toJson())}'
              'This email was created at ${DateTime.now()}',
        );
      } else {
        return Response.notFound(
            'The Subject of Condition was ${conditionResponse.subject.reference}, '
            'this was not found on the server:\n'
            '${prettyJson(conditionResponse.toJson())}');
      }
    } else {
      return Response.notFound(
          'The Subject of Condition with ID: $id was not a Patient'
          '${prettyJson(conditionResponse.toJson())}');
    }
  } else {
    return Response.notFound('Condition with ID: $id was not found'
        '${prettyJson(conditionResponse.toJson())}');
  }
}
