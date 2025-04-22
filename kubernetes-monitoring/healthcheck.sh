#!/bin/sh
if ! curl -f http://localhost/nginx_status >/dev/null 2>&1; then
    exit 1
fi