#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

if [ $# -eq 0 ]; then
  echo "No snapshot supplied -- exiting"
  exit 0
fi

zfs diff "$1" |
  cut -f2 |
  sort |
  uniq |
  while read path; do
    if [ -L "$path" ]; then
      :
    elif [ -d "$path" ]; then
      :
    else
      echo "$path"
    fi
  done

