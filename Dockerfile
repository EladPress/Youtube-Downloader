FROM python:3.13.7-alpine
WORKDIR /app

# COPY requirements.txt .

RUN pip install --no-cache-dir yt-dlp
# RUN apt update && apt install ffmpeg -y
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 download.sh .
ENTRYPOINT ["./download.sh"]