#!/bin/sh
set -e

ulimit -n 1024
exec "$@"
