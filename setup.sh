#! /bin/bash

#create virtual environment
python3 -m venv ansible
source ansible/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install ansible
ansible-galaxy collection install ansible.posix
