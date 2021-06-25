# docker_workspace
## What it is?
This is software that creates a workstation on a remote server that you can connect to via ssh.
The main idea is to provide the ability to move from server to server while maintaining a familiar workspace.
Also, if there is a rootless docker on the host, it becomes possible for the employee to work with the superuser's capabilities without sudo.

For sophisticated users there is a ready-made implementation in [kubernetes](https://www.kubeflow.org).

## Quick start
* Create a private and public key pair. And upload the public key to the `keys` folder. This is needed to connect to the workspace via ssh.
Send the path to it in `PUB` the `config/config.env`.
* To execute commands from the container on the host, write down the path to this key in `HOST` in the `config/config.env`
* Specify the connection port in `PORT` in the `config/config.env`
* The `make up` command starts the workstation
* Connect using ssh. For example: `ssh -t -i ~/.ssh/id_rsa root@HOSTNAME -p PORT`. For convenience, add ssh command in `~/.bashrc`:
`alias tt='ssh -t -i ~/.ssh/id_rsa root@HOSTNAME -p PORT "cd /mnt/workspace; bash"'`

## Using
1) Configuration description will appear here soon
2) You can use my default vim setting or generate your own [there](https://vim-bootstrap.com/)

## Coming soon
* Vim setting
* Transferring all settings to dotfiles
* Ability to use kubernetes instead of docker
