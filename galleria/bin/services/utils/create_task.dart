import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import '../api.dart';
import 'operation_outcome.dart';
import 'types.dart';

Future<Resource> createTask(
  ServiceRequest serviceRequest,
  AccessCredentials credentials,
) async {
  String? planDefinitionUri;
  if (serviceRequest.instantiatesCanonical != null) {
    if (serviceRequest.instantiatesCanonical!.isNotEmpty &&
        serviceRequest.instantiatesCanonical![0]
            .toString()
            .contains('PlanDefinition')) {
      planDefinitionUri = serviceRequest.instantiatesCanonical![0].toString();
    }
  } else if (serviceRequest.instantiatesUri != null) {
    if (serviceRequest.instantiatesUri!.isNotEmpty &&
        serviceRequest.instantiatesUri![0]
            .toString()
            .contains('PlanDefinition')) {
      planDefinitionUri = serviceRequest.instantiatesUri![0].toString();
    }
  }

  /// if instantiates Uri exists and is not empty, and the first entry is a PlanDefinition
  if (planDefinitionUri != null) {
    /// Create the PlanDefinition Request
    final planDefinitionRequest = FhirRequest.read(
        base: Uri.parse(fhirUrl),
        type: R4ResourceType.PlanDefinition,
        id: Id(planDefinitionUri.split('/').last));

    /// Request the PlanDefinition
    final planDefinitionResponse = await planDefinitionRequest.request(
        headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

    /// If it's a PlanDefinition (as it should be, otherwise it's an error)
    if (planDefinitionResponse is PlanDefinition) {
      /// Create a new task
      final task = Task(
        /// The task is based on the ServiceRequest
        basedOn: [Reference(reference: serviceRequest.path())],

        /// This is a reference to whom the Task is applied to
        for_: serviceRequest.subject,

        /// Usually the same as for_, but the owner is the one who is
        /// required to complete the task (a parent, for instance, of a
        /// questionnaire for a child)
        owner: serviceRequest.subject,

        /// If there's a practitioner or organization who requested this, it goes here
        requester: serviceRequest.requester,

        /// It's an order
        intent: TaskIntent.order,

        /// We are making the task, so it has been requested, but is not yet in-progress
        status: TaskStatus.requested,
        input: [],
      );

      /// For each action in the PlanDefinition, add it to an input for Task
      for (var action
          in planDefinitionResponse.action ?? <PlanDefinitionAction>[]) {
        task.input!.add(
          TaskInput(
            type: action.definitionUri.toString().contains('Questionnaire')
                ? questionnaireType
                : action.definitionUri.toString().contains('Measure')
                    ? measureType
                    : valueSetType,
            valueUri: action.definitionUri,
          ),
        );
      }

      /// Create the Task Request
      final createRequest =
          FhirRequest.create(base: Uri.parse(fhirUrl), resource: task);

      /// Upload the Task
      final createResponse = await createRequest.request(
          headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

      return createResponse;
    } else {
      return operationOutcome('PlanDefinition was not returned from request\n'
          'ServiceRequest ID: ${serviceRequest.id}\n'
          'PlanDefinition ID: ${serviceRequest.instantiatesUri![0].toString().split('/').last}');
    }
  } else {
    return operationOutcome(
        'No PlanDefinition present in ServiceRequest ${serviceRequest.id}');
  }
}