#! /usr/bin/python3

#from multiprocessing.sharedctypes import Value
from subprocess import run
import shutil
import oschmod
import os
#from ansible.constants import DEFAULT_VAULT_ID_MATCH
#from ansible.parsing.vault import VaultLib, VaultSecret
#import yaml

#check if ansible is present on local system
ansible_exist = shutil.which( 'ansible' )
print(ansible_exist)

if ansible_exist == None:
    #print(ansible_exist.returncode)
    print("installing ansible")
    run(['pip3', 'install', 'ansible'])
else:
    pass

#create .ssh directory and change permissions:
current_directory = os.getcwd()
final_directory = os.path.join(current_directory, r'.ssh')
if not os.path.exists(final_directory):
   os.makedirs(final_directory)
oschmod.set_mode('.ssh', "700")

#generate rsa key
#ssh-keygen -f $(pwd)/id_rsa -t rsa -b 4096 -P ""
#priv = str(current_directory + '/.ssh/')
#os.chdir(priv)
#os.system("ssh-keygen -f $(pwd/id_rsa) id_rsa -t rsa -b 4096 -P ''")


#vault = VaultLib([(DEFAULT_VAULT_ID_MATCH, VaultSecret('warning'.encode()))])
#private_key_raw=(yaml.safe_load(vault.decrypt(open(str(current_directory + '/secrets.yml')).read()))["automatic_private_key"])
#print(private_key.replace(" ", "\n"))
#priv_key = (('-----BEGIN OPENSSH PRIVATE KEY----- ') + ((private_key_raw.split('-----') [2].replace(" ", "\n"))) + ('-----END OPENSSH PRIVATE KEY-----') + '\n')
#print(priv_key)
#with open('.ssh/id_rsa', 'w') as key:
#    key.write(private_key_raw)

oschmod.set_mode(".ssh/id_rsa", "400")
oschmod.set_mode(".ssh/id_rsa.pub", "600")
#os.chdir(current_directory)
#print(os.environ.get('USER', os.environ.get('USERNAME')))