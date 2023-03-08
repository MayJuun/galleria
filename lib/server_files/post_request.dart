import 'package:fhir/r4.dart';
import 'package:shelf/shelf.dart';

import '../galleria.dart';

/// How the server responds to a post request
Future<Response> postRequest(List<String> path, [Resource? resource]) async {
  /// For logging in Cloud Run
  print('postRequest -- path: $path -- resource: $resource');

  /// Allows us to easily change from full services to communications only. If,
  /// for instance in Meld, we're not storing ANY resources except communications
  /// and communicationRequests, this is the option we selectg
  if (clientAssets.communicationsOnly) {
    switch (path[0]) {
      case 'CommunicationRequest':
        return postRequestCommunicationRequest(path[1]);
      default:
        return Response.ok('The resource posted of type ${path[0]} '
            'is not currently supported.');
    }
  } else {
    /// Otherwise, depending on the type of resource that was posted, we
    /// respond differently
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
}
