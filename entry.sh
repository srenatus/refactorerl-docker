#!/bin/bash
set -ex

load_code() {
  erlc /code/referl_repo.erl
  erl -noshell -sname user@localhost -s referl_repo
}

if [[ -f /code/referl_repo.erl ]]; then
	echo "found referl_repo.erl, compiling"
  ( sleep 2; load_code ) &
else
  echo "no /code/referl_repo.erl found"
fi

bin/referl -web2
