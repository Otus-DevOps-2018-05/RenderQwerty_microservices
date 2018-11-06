#!/bin/bash

# Add project-wide ssh keys
sed 's/^/appuser:/' ~/.ssh/appuser.pub > /tmp/appuser.pub
gcloud compute project-info add-metadata --metadata-from-file ssh-keys=/tmp/appuser.pub

# Add firewall rule for packer provisioner
gcloud compute firewall-rules create packer-ssh \
 --allow tcp:22 \
 --target-tags=packer-ssh \
 --description="Allow connections from packer provisioners" \
 --direction=INGRESS
