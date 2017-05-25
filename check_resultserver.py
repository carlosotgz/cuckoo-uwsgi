#!/usr/bin/env python

import sys
import ConfigParser
import socket
import time

def check_tcp_port(address, port):
    s = socket.socket()
    try:
        s.connect((address, port))
        return True
    except socket.error, e:
        return False

def check_service(address, port, name):
    for attempt in range(20):
        if check_tcp_port(address, port):
            print "{0} is ready".format(name)
            return
        time.sleep(1)
    else:
        print "{0} is not available".format(name)
        sys.exit(1)

cuckoo_cfg = ConfigParser.ConfigParser()
cuckoo_cfg.read("/cuckoo/conf/cuckoo.conf")

resultserver_ip =  cuckoo_cfg.get('resultserver', 'ip')
resultserver_port =  int(cuckoo_cfg.get('resultserver', 'port'))
check_service(resultserver_ip, resultserver_port, "Result server")

sys.exit()
