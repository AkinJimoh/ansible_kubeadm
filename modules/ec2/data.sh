#!/bin/bash

dnf install git -y
dnf install python3 -y
pip3 install ansible
pip3 install boto3
eval "$(ssh-agent -s)"
git clone https://github.com/AkinJimoh/ansible_kubeadm.git
