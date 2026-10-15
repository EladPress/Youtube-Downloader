#!/bin/sh
# Download YouTube video as MP4

URL="$1"

# Ensure yt-dlp is installed
if ! command -v yt-dlp > /dev/null 2>&1; then
  echo "yt-dlp not found. Install with: pip install yt-dlp"
  exit 1
fi

# Without a mounted res/, the file would be lost when the container is removed
if ! grep -q " /app/res " /proc/mounts; then
  echo "ERROR: /app/res is not mounted, the download would be lost. Run via execute.sh."
  exit 1
fi

# Optional YouTube Premium cookies, mounted read-only by execute.sh.
# yt-dlp writes cookies back on exit, so work on a writable copy.
set --
if [ -f /app/cookies.txt ]; then
  cp /app/cookies.txt /tmp/cookies.txt
  set -- --cookies /tmp/cookies.txt
fi

# Best video at any codec (yt-dlp ranks Premium formats first at equal resolution),
# plus Premium 256k AAC (141) if available, else best AAC, else best audio.
# Streams are remuxed into MP4 without re-encoding; YouTube chapters are kept as MP4 chapters.
# YouTube sometimes rejects a fresh download URL with HTTP 403; a new attempt
# re-extracts new URLs and resumes the partial file.
MAX_ATTEMPTS=3
attempt=1
until yt-dlp -ic --no-cache-dir --force-ipv4 --no-playlist "$@" \
  -f "bv*+141/bv*+ba[ext=m4a]/bv*+ba/b" \
  --merge-output-format mp4 --embed-chapters \
  -o "res/%(title)s.%(ext)s" --verbose "$URL"; do
  if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
    echo "ERROR: download failed after $MAX_ATTEMPTS attempts."
    exit 1
  fi
  attempt=$((attempt + 1))
  echo "Download failed, retrying in 5s (attempt $attempt/$MAX_ATTEMPTS)..."
  sleep 5
done
