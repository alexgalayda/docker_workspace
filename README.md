# docker_workspace
## What it is?
This is software that creates a workstation on a remote server that you can connect to via ssh.
The main idea is to provide the ability to move from server to server while maintaining a familiar workspace.
Also, if there is a rootless docker on the host, it becomes possible for the employee to work with the superuser's capabilities without sudo.

For sophisticated users there is a ready-made implementation in [kubernetes](https://www.kubeflow.org).

## Requirements
Installing Cuda:
	* [Installing the NVIDIA driver, CUDA and cuDNN](https://gist.github.com/kmhofmann/cee7c0053da8cc09d62d74a6a4c1c5e4)
	* also helpful [this](https://medium.com/@exesse/cuda-10-1-installation-on-ubuntu-18-04-lts-d04f89287130) and [this](https://www.pugetsystems.com/labs/hpc/How-to-install-CUDA-9-2-on-Ubuntu-18-04-1184/)
	* if you have diff beetween nvidia-smi and nvcc -V read [this](https://stackoverflow.com/questions/53422407/different-cuda-versions-shown-by-nvcc-and-nvidia-smi)

## Quick start
* Create a private and public key pair or use your current.
* To execute commands from the container on the host, write down the path to this key in `HOST` in the `config/config.env`
* Specify the connection port in `PORT` in the `config/config.env`
* To add drivers `cudnn-11.3-linux-*.tgz` and `NVIDIA-Linux-*.run` to `./utils`
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
