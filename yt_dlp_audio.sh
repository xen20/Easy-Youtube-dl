#!/usr/bin/env bash

set -euo pipefail

yt-dlp --remote-components ejs:github \
    --batch-file sources/audio_playlists.txt \
    --download-archive archives/audio.txt \
    -f "bestaudio[ext=m4a]/bestaudio" \
    --embed-thumbnail --add-metadata \
    --metadata-from-title "%(artist)s - %(title)s" \
    --output "%(playlist_title)s/%(artist&{} - |)s%(title)s.%(ext)s"
