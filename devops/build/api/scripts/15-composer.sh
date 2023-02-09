#!/usr/bin/env bash

if [ "$APP__ENV" == "dev" ]; then
   export COMPOSER_HOME="/root" && composer install
fi