#!/bin/bash

#  Because I always forget this
#  gcloud config set project [project_id]
#  gcloud auth login

projectId="acl-challenge"
projectName="acl-challenge-staging-galleria"
version="0.0.3"


gcloud config set project $projectId

cd galleria &&

# Create docker container and upload it
docker build -t $projectName .
docker build -t gcr.io/$projectId/$projectName:v$version .
docker push gcr.io/$projectId/$projectName:v$version

# return back to root directory
cd ..

# deploy on google cloud
gcloud run deploy $projectName --image gcr.io/$projectId/$projectName:v$version