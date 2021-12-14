#!/bin/bash

if [ -n "$1" ]; then
    cd $(wslpath "$1")
fi

