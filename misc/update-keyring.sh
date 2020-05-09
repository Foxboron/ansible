#!/bin/bash
ansible-vault decrypt files/ansible.gpg || true
tmp_home=$(mktemp -d /var/tmp/.gnupgXXXXXX)
GNUPGHOME=$tmp_home gpg --no-default-keyring  --primary-keyring ./files/ansible.gpg --auto-key-locate clear,nodefault,pka,dane $@ 
GNUPGHOME=$tmp_home gpg --no-default-keyring  --primary-keyring ./files/ansible.gpg --list-options show-only-fpr-mbox --list-keys
rm -rf $tmp_home
rm ./files/ansible.gpg\~
ansible-vault encrypt files/ansible.gpg
