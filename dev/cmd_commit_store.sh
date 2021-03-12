#!/usr/bin/env bash

cd files/ || exit
git config user.email "immutag"
git config user.name "immutag"
git annex add .
git commit -m "update"
