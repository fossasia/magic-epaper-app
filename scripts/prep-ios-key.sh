#!/bin/sh
set -e

openssl aes-256-cbc -K $ENCRYPTED_IOS_KEY -iv $ENCRYPTED_IOS_IV -in ./scripts/ios-secrets.tar.enc -out ./scripts/ios-secrets.tar -d
tar xvf ./scripts/ios-secrets.tar -C iOS/