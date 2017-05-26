#!/usr/bin/env python

import sys
import ConfigParser
import socket
import time

"""
Knock a TCP port once per second, 20 seconds at most.
"""
def check_tcp_port(address, port, name):
    for attempt in range(20):
        s = socket.socket()
        try:
            s.connect((address, port))
            print "{0} is ready".format(name)
            s.close()
            return True
        except socket.error, e:
            time.sleep(1)
    else:
        print "{0} is not available".format(name)
        sys.exit(1)

cuckoo_cfg = ConfigParser.ConfigParser()
cuckoo_cfg.read("/cuckoo/conf/cuckoo.conf")

resultserver_ip =  cuckoo_cfg.get('resultserver', 'ip')
resultserver_port =  int(cuckoo_cfg.get('resultserver', 'port'))
check_tcp_port(resultserver_ip, resultserver_port, "Result server")

sys.exit()
