import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';

import 'package:shelf/shelf.dart';

import '../../../galleria.dart';

Future<Response> postRequestServiceRequest(String id) async {
  final credentials = await getCredentials();

  /// Create the search request
  final readServiceRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(fhirUrl),

    /// resource type
    type: R4ResourceType.ServiceRequest,

    /// ID from URL request
    id: Id(id),
  );

  /// get the response
  final response = await readServiceRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (response is ServiceRequest) {
    final task = await createTask(response, credentials);
    return Response.ok(prettyJson(task.toJson()));
  } else {
    return Response.notFound('The ServiceRequest with ID: $id was not found'
        '${prettyJson(response.toJson())}');
  }
}
