# Using YouTube Premium formats

The downloader already supports this. You only need to provide a `cookies.txt` file.

## What Premium unlocks

- **Format 616**: "1080p Premium", an enhanced-bitrate version of the 1080p video.
- **Format 141**: 256 kbps AAC audio, double the normal 128 kbps (format 140). YouTube only offers it on some videos, mostly music.

At the same resolution, yt-dlp ranks Premium video streams above regular ones automatically. `download.sh` asks for audio format 141 first and falls back to normal AAC when it isn't offered.

## Setup

1. Install a cookie-export browser extension, such as "Get cookies.txt LOCALLY". On Windows, yt-dlp can't read Chrome's cookies directly anymore (`--cookies-from-browser chrome` fails).
2. Open a private/incognito window and sign in to YouTube with your Premium account.
3. Export the youtube.com cookies in Netscape format, and save them as `cookies.txt` in the project folder, next to `execute.sh`.
4. Close the private window **without signing out**. Signing out invalidates the cookies. The private window also stops your normal browsing from replacing the session the cookies belong to.
5. Run the downloader as usual:
   ```sh
   source execute.sh 'https://www.youtube.com/watch?v=...'
   ```

When `cookies.txt` is present, `execute.sh` mounts it read-only into the container, and `download.sh` passes it to yt-dlp.

## Checking that it works

In the output, look for:

- `Detected YouTube Premium subscription`, which means the cookies were accepted.
- `616` and/or `141` in the `[info] ...: Downloading 1 format(s): ...` line, on a video that offers them.

If the Premium subscription isn't detected, the cookies have probably expired. Export them again.

## Cautions

- `cookies.txt` gives full access to your Google account while the session is valid. Keep it private. It's excluded in `.gitignore` and `.dockerignore`, so it can't be committed or built into the image.
- YouTube can flag accounts used for automated downloading. Heavy use, like whole playlists, carries a small risk to your account.
- Premium mostly helps at 1080p and with music audio. Without Premium you still get the best regular streams, up to 4K/HDR.
