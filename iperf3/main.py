#!/usr/bin/python
# -*- coding: utf-8 -*-
import logging

import requests

import iperf3
from configs import *

logging.basicConfig(format='[%(asctime)s] %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)


def get_local_ip():
    ip = requests.get('https://api.ipify.org').text
    return ip


def main():
    server = iperf3.Server()
    server.bind_address = SERVER
    server.port = PORT
    server.verbose = VERBOSE
    logger.info(f"iperf3 server: {SERVER} port: {PORT} verbose: {VERBOSE}")
    while True:
        try:
            res = server.run()
            logger.info(
                f"server:{get_local_ip()} sender:{res.sent_Mbps} receiver:{res.received_Mbps} "
                f"From client:{res.remote_host} {res.receiver_tcp_congestion}")
        except Exception as e:
            logger.error(e)


if __name__ == '__main__':
    main()
