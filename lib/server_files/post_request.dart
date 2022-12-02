import 'package:fhir/r4.dart';
import 'package:shelf/shelf.dart';

import '../galleria.dart';

Future<Response> postRequest(List<String> path, [Resource? resource]) async {
  print('postRequest -- path: $path -- resource: $resource');
  switch (path[0]) {
    case 'ServiceRequest':
      return postRequestServiceRequest(path[1]);
    case 'Task':
      return postRequestTask(path[1]);
    case 'Observation':
      return postRequestObservation(path[1]);
    case 'Condition':
      return postRequestCondition(path[1]);
    case 'CommunicationRequest':
      return postRequestCommunicationRequest(path[1]);
    default:
      return Response.ok('The resource posted of type ${path[0]} '
          'is not currently supported.');
  }
}
