import 'package:fhir/r4.dart';

OperationOutcome operationOutcome(String issue, {String? diagnostics}) =>
    OperationOutcome(
      issue: [
        OperationOutcomeIssue(
          severity: Code('error'),
          code: Code('value'),
          details: CodeableConcept(text: issue),
          diagnostics: diagnostics,
        ),
      ],
    );
