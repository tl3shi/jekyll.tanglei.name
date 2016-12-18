#/bash/sh
cd /data/wwwroot/tanglei.name && git pull origin source && jekyll build && chown -R www:www _site
