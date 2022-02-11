import 'package:shelf/shelf.dart';

import 'resource_types/service_request.dart';

Future<Response> postRequest(List<String> path) async {
  switch (path[0]) {
    case 'ServiceRequest':
      return postRequestServiceRequest(path[1]);
    case 'Task':
      return Response.ok('Task');
    default:
      return Response.notFound('The resource posted of type ${path[0]} '
          'is not currently supported.');
  }
}
