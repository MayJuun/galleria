#!/bin/bash

url='https://healthcare.googleapis.com/v1/projects/acl-challenge/locations/us/datasets/staging/fhirStores/staging-fhirstore/fhir/Condition/a2db075b-83fe-4cea-861f-19244a4c29b7'

curl -X GET \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json; charset=utf-8" \
    "$url" > downloadedBundle.json

