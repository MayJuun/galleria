#!/bin/bash

aclUrl='https://healthcare.googleapis.com/v1/projects/acl-challenge/locations/us/datasets/staging/fhirStores/staging-fhirstore/fhir'

devUrl='https://healthcare.googleapis.com/v1/projects/demos-322021/locations/us-central1/datasets/mayjuun/fhirStores/dev/fhir'


curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json; charset=utf-8" \
    --data @./"condition.json" \
        "$aclUrl" > uploadedBundle.json