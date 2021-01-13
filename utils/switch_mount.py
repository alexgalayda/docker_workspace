#!/usr/bin/python3
import os
import argparse

class Parser:
    def __init__(self, path='/resources/config/config.env'):
        env_vars, host_vars = self.make_vars(path)
        self.host_vars = {keys: self.expand(value) for keys, value in host_vars.items()}
        self.env_vars = {key[5:]: self.expand(env_vars[key[5:]]) for key in self.host_vars.keys()}
    
    def __repr__(self):
        return 'HOST:\n' + str(self.host_vars) + '\nWS:\n' + str(self.env_vars)

    def expand(self, path):
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
            path = path.replace(ws_path, self.host_vars['HOST_' + name])
        return path

def sudstitution_str(path_str, config='/resources/config/config.env'):
    parser = Parser(config)
    #env_vars, doc_vars = make_vars(config)
    #for doc_path in doc_vars:
    #    path_str = path_str.replace(doc_vars[doc_path], env_vars[doc_path.replace('_DOC', '')])
    #return path_str

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Switch path from container to host.')
    parser.add_argument('--config', type=str, default='/resources/config/config.env', help='Path to config file')
    args = parser.parse_args()
    parser = Parser(args.config)
    print(parser)
