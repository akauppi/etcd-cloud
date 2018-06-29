#!/bin/bash

NAME=cluster-123

# Deletion of a Kubernetes cluster on Google Kubernetes Engine
#
gcloud container clusters delete $NAME
