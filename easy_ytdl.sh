#!/bin/bash

#Author: Konstantin Mishin

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

NOTE: If playlist download is intended, make sure to give the playlist ID:
For example, in the following URL: &list=PLbQ-gSLYQEc6IWgKJNOMUONgtNXdwVcDC
the playlist ID is PLuUdFsbOK_8o1BzPcXHwILC7UN0MmTo5- .

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
    elif
       [ $ACTION = "-a" ]; then
        FORMAT="Audio"
    fi


    # to-do stripping extra spaces from the destination is necessary

    if [[ $URL != *youtube* ]]; then
        DEST="$PWD/Downloads/$FORMAT/Playlist %(playlist_uploader)s \
        %(playlist_title)s "$FORMAT"/%(title)s.%(ext)s"

    # improve the next method to detect channel: it is not robust enough, 
    # and the case may trigger in a normal video if url contains either string.

    elif [[ $URL == *channel* || $URL == *user* ]]; then
        DEST="$PWD/Downloads/$FORMAT/Channel %(uploader)s \
        "$FORMAT"/%(title)s.%(ext)s"
    else
        DEST="$PWD/Downloads/$FORMAT/%(title)s.%(ext)s"
    fi
}

function download {
    form_destination
    if [ $ACTION = "-v" ]; then
        youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
        --merge-output-format mp4 --retries 30 -o "$DEST" $URL
    elif [ $ACTION = "-a" ]; then
        youtube-dl -i --extract-audio --audio-format mp3 -o "$DEST" $URL
    fi
}

if [ $ACTION = "-h" ]; then
    usage
else
    download
fi
