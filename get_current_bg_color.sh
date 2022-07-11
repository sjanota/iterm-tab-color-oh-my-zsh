#!/bin/sh
#
# Query a property from the terminal, e.g. background color.
#
# XTerm Operating System Commands
#     "ESC ] Ps;Pt ST"

oldstty=$(stty -g)

# What to query?
# 11: text background
Ps=${1:-11}

# stty raw -echo min 0 time 0
stty raw -echo min 0 time 1
printf "\033]$Ps;?\033\\"
# xterm needs the sleep (or "time 1", but that is 1/10th second).
sleep 0.01
read -r answer
stty $oldstty
result=${answer#*;}
# Remove escape at the end.
echo $result | sed 's/.*\(rgb:[0-9a-f/]*\).*/\1/' > /tmp/color