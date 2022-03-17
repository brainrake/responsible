#!/bin/sh
set -e
exec idris2 --build responsible.ipkg
# exec idris2 --codegen node --build responsible.ipkg
