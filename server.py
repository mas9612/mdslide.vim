#!/usr/bin/env python3

# -*- coding: utf-8 -*-

from http.server import HTTPServer, SimpleHTTPRequestHandler
import sys


def main(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    server_address = ('', 8000)
    httpd = server_class(server_address, handler_class)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        sys.exit(0)


if __name__ == '__main__':
    main()
