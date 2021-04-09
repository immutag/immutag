#!/usr/bin/env bash

cd files/ || exit
git annex add .
git commit -m "update"
