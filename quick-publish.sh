
rm -rf public
hugo -D
git add .
git commit -m "daily update"
git push
