import 'package:fhir/r4.dart';

final questionnaireType = CodeableConcept(coding: [
  Coding(
      code: FhirCode('questionnaire'),
      system: FhirUri('http://hl7.org/fhir/uv/sdc/CodeSystem/temp'))
]);

final measureType = CodeableConcept(coding: [
  Coding(
      code: FhirCode('Measure'),
      display: 'Measure',
      system: FhirUri('http://hl7.org/fhir/resource-types'))
]);

final valueSetType = CodeableConcept(coding: [
  Coding(
      code: FhirCode('ValueSet'),
      display: 'ValueSet',
      system: FhirUri('http://hl7.org/fhir/resource-types'))
]);
