#!/bin/bash

url='https://healthcare.googleapis.com/v1/projects/acl-challenge/locations/us/datasets/staging/fhirStores/staging-fhirstore/fhir'

curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json; charset=utf-8" \
    --data @./"patient.json" \
        "$url" > uploadedBundle.json