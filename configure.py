#!/usr/bin/env python3

import os
import time
import shutil
import re

sym_created = []

def get_datetime():
    return time.strftime("%Y-%m-%d_%H-%M-%S")

def get_path():
    return os.path.dirname(os.path.realpath(__file__))

def find_corresponding_closer(code, i, is_if):
    count = 1
    for j in range(i, len(code)):
        if code[j][0] == 'if':
            count += 1
        elif code[j][0] == 'endif':
            count -= 1
        if count == 0:
            return j
        if is_if and (count == 1 and code[j][0] == 'else'):
            return j
    print("Never ending conditional statement")
    exit(1)

def astify(code):
    newc = []
    i = 0
    while i < len(code):
        c = code[i]
        if c[0] == 'place':
            newc.append(c)
        if c[0] == 'if':
            j = find_corresponding_closer(code, i+1, True)
            if code[j][0] == 'else':
                k = find_corresponding_closer(code, j+1, False)
                newc.append([c, astify(code[i+1:j]), astify(code[j+1:k])])
                i = k
            else:
                newc.append([c, astify(code[i+1:j]), []])
                i = j
        if c[0] == 'exec':
            newc.append(c)
        i += 1
    return newc


def codify(names):
    tokens = ["place", "if", "else", "exec", "endif"]
    names = [k for k in names if k.strip() != '']
    for i, n in enumerate(names):
        indices = [n.find(t) for t in tokens if n.find(t) != -1]
        if len(indices) == 0:
            print("Statement %s contains no tokens" % n)
            exit(1)
        names[i] = n[min(indices):]
    names = [c.split(' ') for c in names]
    return astify(names)

def extract_path(names):
    if type(names) is not list:
        names = names.strip().split("\n")
    for i, name in enumerate(names):
        k = re.findall(r"place ''(.*)''", name)
        if k:
            return k[0]
        k = re.findall(r"place &(.*)&", name)
        if k:
            return k[0]
        k = re.findall(r"begin-conf", name)
        if k:
            names = names[i+1:]
            break
    else:
        return False
    for i, name in enumerate(names):
        k = re.findall(r"end-conf", name)
        if k:
            names = names[:i]
            break
    names = codify(names)
    print(names)
    return False

def start_symming(path):
    if os.path.isfile(path + "/folder_config"):
        sym = os.path.expanduser(extract_path(open(path + "/folder_config").read().strip()))
        if os.path.exists(sym):
            if os.path.islink(sym):
                print("Deleting symlink " + sym)
                os.remove(sym)
            else:
                print("Backuping file " + sym)
                if not os.path.exists(backup):
                    os.makedirs(backup)
                shutil.move(sym, backup)
        print "Trying to symlink", path, "to", sym
        try: os.makedirs(os.path.dirname(sym))
        except OSError as e: pass
        os.symlink(path, sym)
        sym_created.append(sym)
        print("Symlink to " + path + " created.")
    else:
        ls =[path + "/" + k for k in os.listdir(path)]
        for name in ls:
            if os.path.isdir(name):
                start_symming(name)
            elif os.path.isfile(name):
                text = open(name).read().strip().split("\n")
                text = text[-20:]
                sym = extract_path(text)
                if sym:
                    sym = os.path.expanduser(sym)
                    if os.path.exists(sym):
                        if os.path.islink(sym):
                            print("Deleting symlink " + sym)
                            os.remove(sym)
                        else:
                            print("Backuping file " + sym)
                            if not os.path.exists(backup):
                                os.makedirs(backup)
                            shutil.move(sym, backup)
                    print "Trying to symlink", name, "to", sym
                    try: os.makedirs(os.path.dirname(sym))
                    except OSError as e: pass
                    os.symlink(name, sym)
                    sym_created.append(sym)
                    print("Symlink to " + name + " created.")
                else:
                    print("Orphaned file found at " + name)
                    exit(1)

state = open(get_path() + "/current_state").read()
cur_files = [os.path.expanduser(k) for k in state.strip().split("\n")]
backup = get_path() + "/backup/" + get_datetime()
print("Backup folder: " + backup + "/\n")


for file in cur_files:
    if os.path.islink(file):
        print("Deleting symlink " + file)
        os.remove(file)

start_symming(get_path() + "/configs")
open(get_path() + "/current_state", "w").write("\n".join(sym_created))
print("\nState successfully witten to current_state")
