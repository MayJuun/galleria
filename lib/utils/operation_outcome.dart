import 'package:fhir/r4.dart';

OperationOutcome operationOutcome(String issue, {String? diagnostics}) =>
    OperationOutcome(
      issue: [
        OperationOutcomeIssue(
          severity: FhirCode('error'),
          code: FhirCode('value'),
          details: CodeableConcept(text: issue),
          diagnostics: diagnostics,
        ),
      ],
    );
