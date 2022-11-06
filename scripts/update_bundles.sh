#!/bin/bash

projectId="demos-322021"
dir="./"

# this pulls the values in from another script
. ./scripts/read_api.sh

# use any of the 3 endpoints below
# echo $fhirDevUrl
# echo $fhirStageUrl
# echo $fhirProdUrl

# change to correct project so you don't have to do this manually
gcloud config set project $projectId
# only needed the first time
# gcloud auth login

# dev server
curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "content-type: application/fhir+json; charset=utf-8" \
    --data @./$dir"devBundle.json" \
        "$fhirDevUrl" > devUploadedBundle.json
        
# stage server
# curl -X POST \
#     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#     -H "content-type: application/fhir+json; charset=utf-8" \
#     --data @./$dir"stageBundle.json" \
#         "$fhirStageUrl" > stageUploadedBundle.json

# prod server
# curl -X POST \
#     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#     -H "content-type: application/fhir+json; charset=utf-8" \
#     --data @./$dir"prodUploadedBundle.json" \
#         "$fhirProdUrl" > prodBundle.json