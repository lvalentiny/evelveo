#! /bin/bash

#create virtual environment
mkdir virtual_envs
python3 -m venv virtual_envs/ansible
source virtual_envs/ansible/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install ansible
ansible-galaxy collection install ansible.posix
