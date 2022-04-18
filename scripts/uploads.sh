#!/bin/bash

url="https://healthcare.googleapis.com/v1/projects/demos-322021/locations/us-central1/datasets/stage/fhirStores/stage/fhir"

curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json; charset=utf-8" \
    --data @./"task.json" \
        "$url" > uploadedBundle.json