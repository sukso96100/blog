
#!/bin/bash

set -o errexit -o nounset

echo "Pushing Changes to gh-pages branch."

rev=$(git rev-parse --short HEAD)

ls
cd _site

git init
git config user.name "sukso96100"
git config user.email "sukso96100@gmail.com"

git remote add upstream "https://$GH_TOKEN@github.com/sukso96100/blog.git"
git fetch upstream
git reset upstream/gh-pages

touch .

git add -A .
git commit -m "[TRAVIS] Site update for ${rev}"
git push -q upstream HEAD:gh-pages
echo "Done Pushing Chagnes! Check out gh-pages branch."
