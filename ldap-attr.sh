#!/bin/sh
set -e
set -u

base="$1"
object="$2"
attr="$3"

ldapsearch -LLL -b "$base" "$object" "$attr" 2> /dev/null \
    | sed -En "s/^$attr:\s+([0-9]+)\$/\1/p"
