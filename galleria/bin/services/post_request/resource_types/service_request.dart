import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../../../_internal/constants/pretty_json.dart';
import '../../api.dart';
import '../../../_internal/constants/scopes.dart';
import '../../utils/create_task.dart';

Future<Response> postRequestServiceRequest(String id) async {
  /// HTTP Client
  final client = http.Client();
  print('posting a service request');

  /// Get credentials for service account, must pass account credentials,
  /// proper scopes (which is really just google cloud) and then the http client
  final credentials = await obtainAccessCredentialsViaServiceAccount(
      accountCredentials, scopes, client);

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
