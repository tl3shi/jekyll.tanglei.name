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
        ;;
    "p")
        echo "git push -u origin deploy:gh-pages --force"
        git push -u origin deploy:gh-pages --force
        cd ../
        ;;
    *)
        echo "-m \"commit msg\" -p (means push)"
        ;;
    esac
done
