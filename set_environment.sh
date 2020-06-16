#!/bin/bash

# Usage:
# ./set_environment.sh             <---- for testing environment 
# ./set_environment.sh production  <---- for production environment 

set -eo pipefail

CICI_SET=""
ENVIRONMENT="testing"

[ "$1" = production ] &&
   CICI_SET="--set production" &&
   ENVIRONMENT="production"

echo "Setting environment to $ENVIRONMENT"

cici decrypt "$CICI_SET" --verbose
dotenv fastlane set_environment