#!/bin/python3
import argparse
import os

def make_vars(config):
    env_vars = {}
    doc_vars = {}
    with open(os.path.expanduser(config)) as f:
        for line in f:
            if not line.startswith('#') and line.strip():
                key, value = line.strip().split('=', 1)
                if key.endswith('_DOC'):
                    doc_vars[key] = value
                env_vars[key] = value
    return env_vars, doc_vars

def sudstitution_str(path_str, config='~/config/config.env'):
    env_vars, doc_vars = make_vars(config)
    for doc_path in doc_vars:
        path_str = path_str.replace(doc_vars[doc_path], env_vars[doc_path.replace('_DOC', '')])
    return path_str

def substitution_file(path, config='~/config/config.env', new_path=None):
    doc_file = open(os.path.expanduser(path)).read()
    env_vars, doc_vars = make_vars(config)
    for doc_path in doc_vars:
        doc_file = doc_file.replace('- '+doc_vars[doc_path], '- '+env_vars[doc_path.replace('_DOC', '')])
    if new_path is None: new_path=os.path.expanduser(path) + '.tmp'
    with open(new_path, 'w') as writer: writer.write(doc_file)
    return new_path

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Switch path from container to host.')
    parser.add_argument('--path', type=str, help='Path to mount file')
    parser.add_argument('--config', type=str, default='~/config/config.env', help='Path to config file')
    args = parser.parse_args()
    substitution_file(args.path, args.config)
