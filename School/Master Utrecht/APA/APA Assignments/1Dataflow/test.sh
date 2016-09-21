#!/bin/bash

FILE="$(dirname "$1")/$(basename "$1" js)"
DOTFILE=$(echo $FILE)dot
PNGFILE=$(echo $FILE)png
PDFFILE=$(echo $FILE)pdf
echo "$DOTFILE"
cat "$1" | ./dist/build/main/main > "$DOTFILE"
dot "$DOTFILE" -Tpng -o "$PNGFILE"
dot "$DOTFILE" -Tpdf -o "$PDFFILE"
