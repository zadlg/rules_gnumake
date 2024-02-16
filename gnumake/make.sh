#!/bin/sh

set -e

_make_bin="$1"
_install_dir="$2"

shift 2

set -x

mkdir -p "${_install_dir}"

"${_make_bin}" $@ CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
