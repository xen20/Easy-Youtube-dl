#!/bin/bash

#Author: Konstantin Mishin

#This is a simplified youtube-dl script that is intended to download the most
#compatible video and audio (mp4,mp3) from youtube videos, playlists, and channels.
#to-do:
#1) add help with how to use the script.
#2) modify the script for more complete downloads: e.g metadata, subtitles.
#3) allow the user to configure several preset youtube-dl config files.

AUDIO_OR_VIDEO=$1
URL=$2

DATE_UN=$(date +%D)
TIME_UN=$(date +%T)

DATE_F=$(echo $DATE_UN | sed 's/\///g')
TIME_F=$(echo $TIME_UN | sed 's/://g')

DATETIME="d"$DATE_F"t"$TIME_F
DEST=''

function form_destination {
    if [ $AUDIO_OR_VIDEO = "-v" ]; then
        FORMAT="Video"
    elif
       [ $AUDIO_OR_VIDEO = "-a" ]; then
        FORMAT="Audio"
    else
        echo "Wrong file format specified"
        exit 1
    fi

    if [[ $URL != *youtube* ]]; then
        DEST="$PWD/YT_Playlist %(uploader)s %(playlist_title)s "$FORMAT"_$DATETIME/%(title)s.%(ext)s"
    elif [[ $URL = *channel* ]]; then
        DEST="$PWD/YT_Channel %(uploader)s "$FORMAT"_$DATETIME/%(title)s.%(ext)s"
    else
        DEST="%(title)s.%(ext)s"
    fi
        
}

function download {
    form_destination
    if [ $AUDIO_OR_VIDEO = "-v" ]; then
        youtube-dl -i -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' \
        --merge-output-format mp4 --retries 10 -o "$DEST" $URL
    elif [ $AUDIO_OR_VIDEO = "-a" ]; then
        youtube-dl -i --extract-audio --audio-format mp3 -o "$DEST" $URL
    fi
}

download

