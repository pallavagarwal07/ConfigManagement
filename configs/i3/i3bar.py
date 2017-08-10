#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import sys
import time
import os
import json
import time
import string
import thread
import subprocess as sp

arr = []
text = ''

def battery():
    dict = {}
    status = open('/sys/class/power_supply/BAT1/status').read()
    percent = open('/sys/class/power_supply/BAT1/capacity').read()

    if 'Charging' in status or 'Full' in status:
        charge = True
    else:
        charge = False

    if charge == True:
        dict['color'] = '#00ff00'
    elif int(percent) > 25:
        dict['color'] = '#ffff00'
    else:
        dict['color'] = '#ff0000'

    dict["full_text"] = '{0:^18}'.format(status.replace('\n', '') + ' ('+percent[:-1]+'%)')
    dict["name"] = 'bat'
    dict["instance"] = '0'
    return dict

def datetime():
    dict = {}
    dict['full_text'] = time.strftime('%d/%m/%y, %I:%M %p (%a)')
    dict["name"] = 'time'
    dict["instance"] = '0'
    return dict


def click_events():
    global text
    try:
        buff = ''
        while True:
            buff += raw_input()
            text = buff[0].replace(',', '') + buff[1:]
            try:
                obj = json.loads(text)
                if obj["name"] == "vol":
                    if obj["button"] == 1 and obj["x"] >= 1500 and obj["x"] <= 1605:
                        new_vol = 10*((obj["x"] - 1500)/7 + 1)
                        sp.call(["pamixer", "--allow-boost", "--set-volume", str(new_vol)])
                    if obj["button"] == 2 or obj["button"] == 3:
                        sp.call(["bash", "-c", "pavucontrol&"])
            except Exception as e:
                text = str(e)
            buff = ''
    except KeyboardInterrupt:
       sys.stdout.flush()
       pass

def sound():
    try:
        proc = sp.check_output(["pamixer", "--get-volume"]).replace("\n", "")
    except Exception as e:
        proc = "0"
    text = u"\u266b " + proc
    bar = []
    percent = int(proc)/10
    bar = [u'\u2588']*percent + [u'\u2592']*(15-percent)
    dict = {'full_text': u'{:>21}'.format(text + " " + ''.join(bar))}
    dict["name"] = "vol"
    dict["instance"] = "0"
    return dict

def bright():
    proc = float(sp.check_output(["sudo", "light"]).replace("\n", ''))
    text = u"\u2600 "+str(int(proc))+"%"
    dict = {'full_text': u'{:^7}'.format(text)}
    dict["name"] = "bright"
    dict["instance"] = "0"
    return dict

def connection(fullName, abbrv):
    ifc = sp.Popen(["ifconfig", fullName], stdout=sp.PIPE)
    ans = sp.Popen(["sed", "-En",
        r"s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"],
        stdin=ifc.stdout, stdout=sp.PIPE)
    ip = str(ans.stdout.read()).replace("\n", '')
    dict = {'name': 'wlan'}
    dict["instance"] = "0"
    if '.' in ip:
        dict["full_text"] = '{:^20}'.format( "W: "+ip )
        dict['color'] = '#44ff11'
    else:
        dict["full_text"] = '{:^20}'.format(abbrv + ": --.--.--.--" )
        dict['color'] = '#ff4411'
    return dict


def create(arr):
    # global text
    # arr.append({'full_text': str(text)})
    arr.append(connection('enp9s0', 'E'))
    arr.append(connection('wlp8s0', 'W'))
    arr.append(bright())
    arr.append(sound())
    arr.append(battery())
    arr.append(datetime())


if __name__ == '__main__':
    thread.start_new_thread(click_events, ())
    print '{ "version": 1, "click_events": true }'
    print '['
    print '[]'
    arr = []
    create(arr)
    for j in range(0, 85):
        print ',', json.dumps(arr)
    while True:
        arr = []
        create(arr)
        for j in range(0, 35):
            print ',', json.dumps(arr)
        time.sleep(1)