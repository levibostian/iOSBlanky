#!/bin/bash

while true; do
  read -p "Need to `pod install`? [y/n]" yn
  case $yn in
      [Yy]* ) pod install; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer [y/n]";;
  esac
done