PORT=22
USER="michael@185.10.201.155"
ROOT="~/michaelpj.com/blog"
jekyll build
rsync -avze "ssh -p $PORT" --delete _site/ $USER:$ROOT
