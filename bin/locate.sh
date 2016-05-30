#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

riddlegate_tmpdir() {
  cd $DIR/../..
  mkdir -p tmp
  cd tmp

  pwd
}

riddlegate_pidfile() {
  echo "$(riddlegate_tmpdir)/sb_api.pid"
}

riddlegate_locate() {
  pidfile=$(riddlegate_pidfile)
  if [[ -e "$pidfile" ]] && [[ $(ps -p $(cat "$pidfile") -o 'pid=' | wc -l) -gt 0 ]]; then
    cat "$pidfile"
  fi
}

riddlegate_logdir() {
  cd $DIR/../..
  [ -e log ] || mkdir -p log
  cd log

  pwd
}
