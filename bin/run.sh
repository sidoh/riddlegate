#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

if [ -e /home/swag_notifier ]; then
  export HOME=/home/swag_notifier
  eval "$(/home/swag_notifier/.rbenv/bin/rbenv init -)" || echo 'failed to source rbenv'
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/locate.sh
cd $DIR/..

bundle install

exec bundle exec puma 2>&1 >>$(riddlegate_logdir)/sb_api.out
