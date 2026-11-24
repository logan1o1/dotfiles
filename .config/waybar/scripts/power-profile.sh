#!/bin/zsh

mode = $(tlp-stat -m 2>/dev/null | head -1)
arrMode=("${(@s:/:)mode}")
echo $arrMode[2]

