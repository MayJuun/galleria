import 'package:shelf/shelf.dart';

import 'resource_types/service_request.dart';
import 'resource_types/task.dart';

Future<Response> postRequest(List<String> path) async {
  switch (path[0]) {
    case 'ServiceRequest':
      return postRequestServiceRequest(path[1]);
    case 'Task':
      return postRequestTask(path[1]);
    default:
      return Response.notFound('The resource posted of type ${path[0]} '
          'is not currently supported.');
  }
}
