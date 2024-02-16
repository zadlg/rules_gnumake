#!/bin/sh

set -e

buck2 docs starlark \
  --format markdown_files \
  --markdown-files-starlark-subdir "" \
  --markdown-files-destination-dir "${PWD}/docs/" \
  -- @gnumake//gnumake:rules.bzl \
     @gnumake//gnumake:toolchain_info.bzl

if ! [ "$1" = "generate" ]; then
  if ! git status; then
    echo "Documentation is out of sync."
    exit 1
  fi
fi
