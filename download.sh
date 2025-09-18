#!/bin/sh
# Download YouTube video as MP4

URL="$1"

# Ensure yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
  echo "yt-dlp not found. Install with: pip install yt-dlp"
  exit 1
fi

# Download best video+audio and merge into MP4
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" -o "res/%(title)s.%(ext)s" "$URL" --verbose
