#!/bin/bash
while getopts "m:p" opt 
do
    case "$opt" in
    "m")
        echo "add comment: $OPTARG"
        rm -rf .deploy/*
        cp -R _site/ .deploy/
        cd .deploy
        git add -A .
        git commit -m "$OPTARG"
        cd ../
        ;;
    "p")
        echo "push: $OPTARG"
        git push -u origin master:gh-pages --force
        ;;
    *)
        echo "-m \"commit msg\" -p (means push)"
        ;;
    esac
done
