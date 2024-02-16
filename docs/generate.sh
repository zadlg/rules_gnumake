#!/bin/sh

set -e

buck2 docs starlark \
  --format markdown_files \
  --markdown-files-starlark-subdir "" \
  --markdown-files-destination-dir "${PWD}/docs/" \
  -- @gnumake//gnumake:rules.bzl \
     @gnumake//gnumake:toolchain_info.bzl

if ! [ "$1" = "generate" ]; then
  if [ -d ".git" ]; then
    if ! git diff --exit-code; then
      echo "Documentation is out of sync."
      exit 1
    fi
  elif [ -d ".sl" ]; then
    if [ -n "$(sl diff)" ]; then
      echo "Documentation is out of sync."
      exit 1
    fi
  else
    echo "Unknown vcs."
    exit 1
  fi
fi
exit 0
