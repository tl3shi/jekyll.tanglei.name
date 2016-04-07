#!/bin/bash
TITLE=
while getopts "t:dp" opt 
do
    case $opt in
    t)
       TITLE=$OPTARG
       ;;
    d)
        echo "new draft: $TITLE.md"
        touch "_drafts/$TITLE.md"
        echo "---\ntitle: $TITLE\nlayout: post\ncategories: [default]\ntags: [MyLife]\n---" >> "_drafts/$TITLE.md"
        ;;
    p)
        titlepre=$(date +%Y-%m-%d)
        mv _drafts/$TITLE.md _posts/$titlepre-$TITLE.md
        echo "publish post: $titlepre-$TITLE.md"
        ;;
    *)
        echo "-t \"title\" -d(new drafts) -p(publish post)"
        ;;
    esac
done
