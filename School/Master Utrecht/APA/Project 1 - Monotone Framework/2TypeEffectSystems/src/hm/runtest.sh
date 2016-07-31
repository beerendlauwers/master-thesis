#!/bin/bash

FILE="$1"
echo "Analyzing file \"$FILE\":"

cat "$FILE" | runghc.exe ParseHM.hs | runghc.exe Main.hs