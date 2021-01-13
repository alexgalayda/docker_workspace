#/bin/bash
set -e
git clone https://github.com/alexgalayda/dotfiles.git
mv ./dotfiles/.vimrc $WORKSPACE/.vimrc
rm -r dotfiles

#add env to user
. /resources/config/config.env
#cat /resources/config/config.env >> /etc/environment 
echo USERNAME=$USERNAME >> /etc/environment
echo HOST_WORKSPACE=$HOST_WORKSPACE >> /etc/environment
echo WORKSPACE=$WORKSPACE >> /etc/environment
echo HOST_STORAGE=$HOST_STORAGE >> /etc/environment
echo STORAGE=$STORAGE >> /etc/environment
