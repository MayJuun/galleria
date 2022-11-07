import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:shelf/shelf.dart';

import '../../galleria.dart';

Future<Response> postRequestObservation(String id) async {
  final credentials = await getCredentials();

  /// Create the search request
  final observationRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(fhirUrl),

    /// resource type
    type: R4ResourceType.Observation,

    /// ID from URL request
    id: id,
  );

  /// get the response
  final observationResponse = await observationRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (observationResponse is Observation) {
    /// get the subject of the observation
    final subject = observationResponse.subject?.reference;

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
        final bundle = Bundle(
          type: Code('transaction'),
          entry: <BundleEntry>[
            BundleEntry(
              resource: observationResponse,
              fullUrl: observationResponse.id == null
                  ? null
                  : FhirUri('$fhirUrl/${observationResponse.path}'),
              request: BundleRequest(
                method: Code('PUT'),
                url: FhirUri(observationResponse.path),
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

        return await sendViaEmail(
          'grey.faulkenberry@mayjuun.com',
          'Look at this beautiful bundle!\n'
              '${prettyJson(bundle.toJson())}'
              'This email was created at ${DateTime.now()}',
        );
      } else {
        return Response.notFound(
            'The Subject of Observation was ${observationResponse.subject?.reference}, '
            'this was not found on the server:\n'
            '${prettyJson(observationResponse.toJson())}');
      }
    } else {
      return Response.notFound(
          'The Subject of Observation with ID: $id was not a Patient'
          '${prettyJson(observationResponse.toJson())}');
    }
  } else {
    return Response.notFound('Observation with ID: $id was not found'
        '${prettyJson(observationResponse.toJson())}');
  }
}
