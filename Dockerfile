FROM python:3.13.7-alpine
WORKDIR /app

# COPY requirements.txt .

RUN pip install --no-cache-dir -U "yt-dlp[default]"
# RUN apt update && apt install ffmpeg -y
RUN apk add --no-cache ffmpeg deno

COPY --chmod=755 download.sh /usr/local/bin/download
ENTRYPOINT ["download"]