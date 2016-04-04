#! /usr/bin/env bash

SSH_HOST=$1;
NOTIFYER_VALUE=$( ssh $SSH_HOST 'redis-cli LPOP notifyor');
echo $NOTIFYER_VALUE;