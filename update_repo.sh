#!/bin/bash

# store the current dir
CUR_DIR=$(pwd)

echo "Pulling in latest changes for all repositories..."

# Update all git repositories in a parent directory
# Looks for all repos with a .git, to exclude non git repos
for dir in $(find . -maxdepth 2 -name .git -type d | cut -c 3- | sed 's/\/.git//' ); do
    echo "Updating $dir"

    # Go to the directory
    cd "$dir"

    git pull

    # lets get back to the CUR_DIR
    cd $CUR_DIR;
    echo ""
done

echo "Complete!"
