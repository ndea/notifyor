#!/usr/bin/env bash
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
ruby -e "require \"redis\"; require \"redis-objects\"; puts  ::Redis::List.new(\"notifyor:users\").values"