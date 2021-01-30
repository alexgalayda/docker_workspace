#!/usr/bin/python3
import os
import argparse
import yaml
from environs import Env
#from yaml import load, dump
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper

class Parser:
    def __init__(self, path='/resources/config/config.env', env=None):
        if env is None:
            self.env_list = None
        else:
            self.env_list = Env()
            self.env_list.read_env(env)
        env_vars, host_vars = self.make_vars(path)
        self.host_vars = {keys: self.expand(value) for keys, value in host_vars.items()}
        self.env_vars = {key[5:]: self.expand(env_vars[key[5:]]) for key in self.host_vars.keys()}
    
    def __repr__(self):
        return 'HOST:\n' + str(self.host_vars) + '\nWS:\n' + str(self.env_vars)

    def expand(self, path):
        path = self.setvars(path)
        path = os.path.expanduser(path)
        return os.path.expandvars(path)
    
    def make_vars(self, config='config.env'):
        env_vars = {}
        host_vars = {}
        with open(os.path.expanduser(config)) as f:
            for line in f:
                if not line.startswith('#') and line.strip():
                    key, value = line.strip().split('=', 1)
                    if key.startswith('HOST_'):
                        host_vars[key] = value
                    env_vars[key] = value
        return env_vars, host_vars

    def expand_path(self, path):
        for name, ws_path in self.env_vars.items():
            path = self.expand(path).replace(ws_path, self.host_vars['HOST_' + name])
        return path

    def setvars(self, env):
        try:
            env = self.env_list(env[2:-1])
        except Exception:
            pass
        return env

def sudstitution_argv(args, config='/resources/config/config.env'):
    mount_flag = '-v'
    parser = Parser(config)
    for i, arg in enumerate(args):
        if arg == mount_flag:
            path_workspace, path_docker = args[i+1].split(':')
            path_host = parser.expand_path(path_workspace)
            args[i+1] = ':'.join([path_host, path_docker])
    return args

def substitution_file(path, config='/resources/config/config.env', new_path=None):
    parser = Parser(config)
    path = parser.expand(path)
    with open(path) as file:
        doc_yaml = yaml.load(file, Loader=Loader)

    for service in doc_yaml['services'].values():
        if service.get('volumes'):
            volumes = service['volumes']
            for i, vol in enumerate(volumes):
                path_workspace, path_docker = vol.split(':')
                path_host = parser.expand_path(path_workspace)
                volumes[i] = ':'.join([path_host, path_docker])

    with open(new_path, 'w') as file:
        yaml.dump(doc_yaml, file)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Switch path from container to host.')
    parser.add_argument('--config', type=str, default='/resources/config/config.env', help='Path to config file')
    args = parser.parse_args()
    parser = Parser(args.config)
    print(parser)
