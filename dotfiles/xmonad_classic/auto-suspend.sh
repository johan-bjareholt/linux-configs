#!/bin/sh
touch "$(pwd)/.auto-suspend-log"
while : ; do
  sinac -w 10
  systemctl suspend &>> "$(pwd)/.auto-suspend-log"
done
