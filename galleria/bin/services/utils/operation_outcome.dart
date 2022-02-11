import 'package:fhir/r4.dart';

OperationOutcome operationOutcome(String issue, {String? diagnostics}) =>
    OperationOutcome(
      issue: [
        OperationOutcomeIssue(
          severity: OperationOutcomeIssueSeverity.error,
          code: OperationOutcomeIssueCode.value,
          details: CodeableConcept(text: issue),
          diagnostics: diagnostics,
        ),
      ],
    );
