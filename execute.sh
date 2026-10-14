URL=$1

mkdir -p res
docker run --rm -v "$(pwd)/res:/app/res" eladpress/youtube-downloader "${URL}"
