// Future<Response> putRequest(Request request) async {
//   if (request.url.queryParameters['ServiceRequest._id'] != null) {
//     /// HTTP Client
//     final client = http.Client();

//     /// Get credentials for service account, must pass account credentials,
//     /// proper scopes (which is really just google cloud) and then the http client
//     final credentials = await obtainAccessCredentialsViaServiceAccount(
//         accountCredentials, scopes, client);

//     /// Create the search request
//     final readServiceRequest = FhirRequest.read(
//       /// base fhir url
//       base: Uri.parse(fhirUrl),

//       /// resource type
//       type: R4ResourceType.ServiceRequest,

//       /// ID from URL request
//       id: Id(request.url.queryParameters['ServiceRequest._id']),
//     );

//     /// get the response
//     final response = await readServiceRequest.request(
//         headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

//     final task = await createTask(response as ServiceRequest, credentials);

//     const jsonEncoder = JsonEncoder.withIndent('    ');
//     return Response.ok('${jsonEncoder.convert(task.toJson())}');
//   }

//   return Response.ok('No ServiceRequest Currently Available');
// }
