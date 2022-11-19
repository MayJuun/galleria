import 'package:fhir/r4.dart';

final questionnaireType = CodeableConcept(coding: [
  Coding(
      code: Code('questionnaire'),
      system: FhirUri('http://hl7.org/fhir/uv/sdc/CodeSystem/temp'))
]);

final measureType = CodeableConcept(coding: [
  Coding(
      code: Code('Measure'),
      display: 'Measure',
      system: FhirUri('http://hl7.org/fhir/resource-types'))
]);

final valueSetType = CodeableConcept(coding: [
  Coding(
      code: Code('ValueSet'),
      display: 'ValueSet',
      system: FhirUri('http://hl7.org/fhir/resource-types'))
]);
