#!/usr/bin/env python3

# -*- coding: utf-8 -*-

from http.server import HTTPServer, SimpleHTTPRequestHandler
import os
import sys


def main(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    document_root = sys.argv[1].strip()
    os.chdir(document_root)

    server_address = ('', 8000)
    httpd = server_class(server_address, handler_class)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        sys.exit(0)


if __name__ == '__main__':
    main()
