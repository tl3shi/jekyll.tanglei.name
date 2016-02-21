#!/bin/bash
rm -rf .deploy/*
cp -R _site/ .deploy/
cd .deploy
git add -A .
git commit -m '$1'
git push -u origin master:gh-pages --force
cd ../
