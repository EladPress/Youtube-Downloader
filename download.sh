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
# Streams are remuxed into MP4 without re-encoding.
yt-dlp -ic --no-cache-dir --force-ipv4 --no-playlist "$@" \
  -f "bv*+141/bv*+ba[ext=m4a]/bv*+ba/b" \
  --merge-output-format mp4 \
  -o "res/%(title)s.%(ext)s" --verbose "$URL"
