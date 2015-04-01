#!/bin/bash

git submodule foreach git checkout master
git submodule foreach git pull
git add $(git submodule | grep -o "\+[a-f0-9]*\s[^ ]*" | grep -o "[^ ]*$")
git commit -m "Update submodules"
