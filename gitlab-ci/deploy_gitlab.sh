#!/bin/bash

gcloud compute addresses create gitlab_address \
    --region europe-west4-a \
    --subnet gitlab \
    --addresses 10.164.0.2

gcloud compute instances create gitlab-1 \
    --zone=europe-west4-a \
    --machine-type=n1-standard-1 \
    --private-network-ip gitlab_address \
    --subnet=gitlab \
    --tags=gitlab,http-server,https-server \
    --image-family=docker-host \
    --boot-disk-size=100GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=gitlab-1

gcloud compute instances list
