#!/bin/bash
set -e
cp /resources/config/sshd_config /etc/ssh/
mkdir -m 700 $WORKSPACE/.ssh/
touch $WORKSPACE/.ssh/authorized_keys

for filename in /resources/keys/*.pub; do
    cat "$filename" >>  $WORKSPACE/.ssh/authorized_keys
done

chown -R $USERNAME:$USERNAME $WORKSPACE/.ssh

mkdir -p /var/run/sshd
sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
