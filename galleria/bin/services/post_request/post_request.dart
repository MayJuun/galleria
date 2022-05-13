import 'package:shelf/shelf.dart';

import '../../galleria.dart';

Future<Response> postRequest(List<String> path) async {
  switch (path[0]) {
    case 'ServiceRequest':
      return postRequestServiceRequest(path[1]);
    case 'Task':
      return postRequestTask(path[1]);
    case 'Observation':
      return postRequestObservation(path[1]);
    default:
      return Response.notFound('The resource posted of type ${path[0]} '
          'is not currently supported.');
  }
}
