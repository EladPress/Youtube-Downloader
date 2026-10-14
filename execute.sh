URL=$1

mkdir -p res

# Put a Netscape-format cookies.txt next to this script to use YouTube Premium formats
set -- -v "$(pwd)/res:/app/res"
if [ -f cookies.txt ]; then
  set -- "$@" -v "$(pwd)/cookies.txt:/app/cookies.txt:ro"
fi

# MSYS_NO_PATHCONV stops Git Bash on Windows from mangling the -v paths
MSYS_NO_PATHCONV=1 docker run --rm "$@" eladpress/youtube-downloader "${URL}"
