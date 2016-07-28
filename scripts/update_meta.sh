#!/bin/bash

echo `date` >> log.txt

cd $HTMLWIDGET_GALLERY_DIR/htmlwidgetsgallery
git pull

Rscript --no-save --no-restore --verbose scripts/github_meta.R >> log.txt 2>&1

git add github_meta.json
git commit -m "Update github_meta"
git push

