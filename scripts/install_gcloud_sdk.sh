#!/bin/bash

set -ev
curl https://sdk.cloud.google.com | bash > /dev/null
source ${HOME}/google-cloud-sdk/path.bash.inc

gcloud --quiet components list
gcloud --quiet components update
gcloud --quiet components install beta kubectl
gcloud --quiet auth activate-service-account --key-file ./k8s/secrets/gce.json
gcloud --quiet --project ${K8S_PROJECT_NAME} container clusters get-credentials ${K8S_CLUSTER_NAME} --zone ${K8S_CLUSTER_ZONE}
gcloud --quiet version
