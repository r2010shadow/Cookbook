#re@server:  pip install fabric
#re@client:  apt-get install openssh-server / yum install
#Howto:   ln -s filename fabfile.py ; fab remote_server install_package

from getpass import getpass
from fabric.api import settings, run, env, prompt

def remote_server():
    env.hosts = ['10.10.9.143']
    env.user = prompt('Enter username: ')
    env.password = getpass('Enter password: ')

def install_package():
    run('yum install -y nc')
