#!/bin/bash

if ! [ -x "$(command -v pre-commit)" ]; then
    echo "You need to install the program 'pre-commit' on your machine to continue. See: https://pre-commit.com/#install"
    exit 1
fi

pre-commit run