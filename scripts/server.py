#!/usr/bin/env python3

# -*- coding: utf-8 -*-

from http.server import HTTPServer, SimpleHTTPRequestHandler
import os
import sys


def main(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    document_root = '/'
    os.chdir(document_root)

    if len(sys.argv) < 2:
        print('Usage: {} plugin_base_dir'.format(sys.argv[0].strip()))
        sys.exit(1)

    mdslide_base_dir = sys.argv[1].strip()

    pid = os.getpid()
    with open('{}/plugin/mdslide_server.pid'.format(mdslide_base_dir), 'w') as f:
        f.write('{}'.format(pid))

    server_address = ('', 8000)
    httpd = server_class(server_address, handler_class)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        sys.exit(0)


if __name__ == '__main__':
    main()
