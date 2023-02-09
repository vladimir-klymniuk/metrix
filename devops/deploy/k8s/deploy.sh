#!/usr/bin/env bash

# $1 - service
# $2 - environment=namespace
# $3 - image name

export $(cat devops/deploy/envs/default.env | grep -v ^# | xargs)
export $(cat devops/deploy/envs/$2.env | grep -v ^# | xargs)

export NAMESPACE=$2
export IMAGE_NAME=$3

envsubst < devops/deploy/k8s/$1.yml > devops/deploy/k8s/service.yaml

# deploy
kubectl apply -f devops/deploy/k8s/service.yaml

# debug
cat devops/deploy/k8s/service.yaml