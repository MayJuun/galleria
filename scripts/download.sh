#!/bin/bash

# this pulls the values in from another script
. ./scripts/read_api.sh

# use any of the 3 endpoints below
# $fhirDevUrl
# $fhirStageUrl
# $fhirProdUrl

projectId="demos-322021"
# only needed the first time
gcloud config set project $projectId
# gcloud auth login

#Dev Env
curl -X GET \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/fhir+json; charset=utf-8" \
    "$fhirDevUrl/Patient" > downloadedBundle.json

# Stage Env
# curl -X GET \
#     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#     -H "Content-Type: application/fhir+json; charset=utf-8" \
#     "$fhirStageUrl/Patient" > downloadedBundle.json

# Prod Env
# curl -X GET \
#     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#     -H "Content-Type: application/fhir+json; charset=utf-8" \
#     "$fhirProdUrl/Patient" > downloadedBundle.json
    
