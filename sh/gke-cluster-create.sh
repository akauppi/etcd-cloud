#!/bin/bash

NAME=cluster-123

# Creation of a Kubernetes cluster on Google Kubernetes Engine
#
gcloud container clusters create $NAME --machine-type f1-micro --num-nodes 3 --disk-size 20
