#!/bin/bash

gcloud compute instances create runner \
    --machine-type=n1-standard-1 \
    --preemptible \
    --tags=gitlab-runner \
    --subnet=gitlab \
    --image-family=docker-host \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=runner \
    --metadata startup-script='#! /bin/bash
curl --header "Private-Token: sKhREoPTkB7idwvLtqpZ" http://10.164.0.2/homework/config/raw/master/gitlab-runner.yml > /tmp/gitlab-runner.yml
sudo ansible-playbook /tmp/gitlab-runner.yml
EOF'
