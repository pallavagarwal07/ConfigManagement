#!/usr/bin/env python2

import os
import time
import shutil
import re

sym_created = []

def get_datetime():
    return time.strftime("%Y-%m-%d_%H-%M-%S")

def get_path():
    return os.path.dirname(os.path.realpath(__file__))

def extract_path(names):
    if type(names) is not list:
        names = names.strip().split("\n")
    for name in names:
        k = re.findall(r"place ''(.*)''", name)
        if k:
            return k[0]
        k = re.findall(r"place &(.*)&", name)
        if k:
            return k[0]
    return False

def start_symming(path):
    if os.path.isfile(path + "/folder_config"):
        sym = os.path.expanduser(extract_path(open(path + "/folder_config").read().strip()))
        if os.path.exists(sym):
            if os.path.islink(sym):
                print "Deleting symlink " + sym
                os.remove(sym)
            else:
                print "Backuping file " + sym
                if not os.path.exists(backup):
                    os.makedirs(backup)
                shutil.move(sym, backup)
        print "Trying to symlink", path, "to", sym
        os.symlink(path, sym)
        sym_created.append(sym)
        print "Symlink to " + path + " created."
    else:
        ls =[path + "/" + k for k in os.listdir(path)]
        for name in ls:
            if os.path.isdir(name):
                start_symming(name)
            elif os.path.isfile(name):
                text = open(name).read().strip().split("\n")
                text = text[:2] + text[-2:]
                sym = extract_path(text)
                if sym:
                    sym = os.path.expanduser(sym)
                    if os.path.exists(sym):
                        if os.path.islink(sym):
                            print "Deleting symlink " + sym
                            os.remove(sym)
                        else:
                            print "Backuping file " + sym
                            if not os.path.exists(backup):
                                os.makedirs(backup)
                            shutil.move(sym, backup)
                    print "Trying to symlink", name, "to", sym
                    os.symlink(name, sym)
                    sym_created.append(sym)
                    print "Symlink to " + name + " created."
                else:
                    print "Orphaned file found at " + name
                    exit(1)

state = open(get_path() + "/current_state").read()
cur_files = [os.path.expanduser(k) for k in state.strip().split("\n")]
backup = get_path() + "/backup/" + get_datetime()
print "Backup folder: " + backup + "/\n"


for file in cur_files:
    if os.path.islink(file):
        print "Deleting symlink " + file
        os.remove(file)

start_symming(get_path() + "/configs")
open(get_path() + "/current_state", "w").write("\n".join(sym_created))
print "\nState successfully witten to current_state"
