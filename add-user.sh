#!/bin/bash


URL_KEY_REPO=https://github.com/mozilla-services/fx-test-pubkeys
REPO=$(basename $URL_KEY_REPO)

# TODO: add conditional for other OS
if ! grep -q "Ubuntu" /etc/lsb-release; then
    echo "Not Ubuntu --> Aborting!"
    exit
fi

rm -rf $REPO
git clone $URL_KEY_REPO
cd $REPO 

for key in *.pub; do
    user=$(basename $key .pub)
    if [[ ! -d "/home/$user" ]]; then 
        echo "ADDING USER: $user"
	adduser --disabled-password --gecos "" $user
	mkdir /home/$user/.ssh
	cp $key /home/$user/.ssh/authorized_keys
    else
        echo "USER: $user ALREADY EXISTS!"
    
    fi
done
