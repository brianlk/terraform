#!/bin/sh

# To increase the memory limit for your Node. js application, 
# use the `--max-old-space-size` flag
export NODE_OPTIONS="--max-old-space-size=8192"
npm run start:dev
