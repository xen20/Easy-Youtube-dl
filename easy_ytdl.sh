#!/bin/sh

# Author: Konstantin Mishin

function usage {
  cat <<HELP

USAGE: $0 [option] URL 

This is a simplified youtube-dl script that is intended to easily download the 
most compatible video and audio (mp4,mp3) from youtube videos, playlists, and 
channels.

Where:
-h show this help text
-v download as video
-a download as audio
URL - URL of youtube video, channel, or playlist

HELP
}

ACTION=$1
URL=$2

# Date and time can be used to date downloaded channels/playlists

DATE_UN=$(date +%D)
TIME_UN=$(date +%T)

DATE_F=$(echo $DATE_UN | sed 's/\///g')
TIME_F=$(echo $TIME_UN | sed 's/://g')

DATETIME="d"$DATE_F"t"$TIME_F
DEST=''

function form_destination {
  if [ $ACTION = "-v" ]; then
    FORMAT="Video"
  elif [ $ACTION = "-a" ]; then
    FORMAT="Audio"
  fi

  # Check if URL is a valid YouTube URL
  if ! echo "$URL" | grep -q "youtube.com"; then
    echo "Error: Invalid YouTube URL"
    exit 1
  fi

  # to-do stripping extra spaces from the destination is necessary

  if [ "$URL" = *"list="* ]; then
    DEST="$PWD/Downloads/$FORMAT/Playlist %(playlist_uploader)s \
    %(playlist_title)s "$FORMAT"/%(title)s.%(ext)s"
  elif [ "$URL" = *"channel"* ] || [ "$URL" = *"user"* ]; then
    DEST="$PWD/Downloads/$FORMAT/Channel %(uploader)s \
    "$FORMAT"/%(title)s.%(ext)s"
  else
    DEST="$PWD/Downloads/$FORMAT/%(title)s.%(ext)s"
  fi
}

function download {
  form_destination
  if [ $ACTION = "-v" ]; then
    if [ "$URL" = *"v="* ]; then
      yt-dlp -i --no-playlist -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
      --merge-output-format mp4 --retries 30 -o "$DEST" $URL
    else
      yt-dlp -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
      --merge-output-format mp4 --retries 30 -o "$DEST" $URL
    fi
  elif [ $ACTION = "-a" ]; then
    if [ "$URL" = *"v="* ]; then
      yt-dlp -i --no-playlist --extract-audio --audio-format mp3 -o "$DEST" $URL
    else
      yt-dlp -i --extract-audio --audio-format mp3 -o "$DEST" $URL
    fi
  fi
}

if [ $ACTION = "-h" ]; then
  usage
else
  download
fi
