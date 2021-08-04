#!/bin/bash

DOWNLOAD_FORMAT=$1
PLAYLIST_OR_CHANNEL=$2

TWO_DAYS_AGO=$(date -d "2 days ago" +'%Y%m%d')

CONFIGS_DIR="$PWD/configs"
ARCHIVES_DIR="$PWD/archives"
SOURCES_DIR="$PWD/sources"

function usage {
cat <<HELP

USAGE: $0 [option] [source] 

This is a simplified youtube-dl archival script that is intended to easily download the 
most compatible video and audio (mp4,mp3) from youtube videos, playlists, and channels.

Generates config with lists of playlists or channels as internal input. Config
generation is simple and does not involve the user almost at all.

Remember to put your sources into the sources folder in the format shown in the example files.

Where:
[option]
-h --help show this help text
-v --video download as video
-a --audio download as audio
[source]
-c download from video/audio_channels.txt
-p download from video/audio_playlists.txt


HELP
}

function create_config {

    if [ $DOWNLOAD_FORMAT = "-v" ]; then
        if [ $PLAYLIST_OR_CHANNEL = "-c" ]; then
            SOURCES_PATH="$SOURCES_DIR/video_channels.txt"
            OUTPUT_PATH='Downloads/Video/%(uploader)s/%(title)s %(resolution)s.%(ext)s'
        elif [ $PLAYLIST_OR_CHANNEL = "-p" ]; then
            SOURCES_PATH="$SOURCES_DIR/video_playlists.txt"
            OUTPUT_PATH='Downloads/Video/%(playlist_uploader)s/%(playlist_title)s/%(playlist_index)s %(title)s %(resolution)s.%(ext)s'
        fi
    elif [ $DOWNLOAD_FORMAT = "-a" ]; then
        if [ $PLAYLIST_OR_CHANNEL = "-c" ]; then
            SOURCES_PATH="$SOURCES_DIR/audio_channels.txt"
            OUTPUT_PATH='Downloads/Audio/%(uploader)s/%(title)s.%(ext)s'
        elif [ $PLAYLIST_OR_CHANNEL = "-p" ]; then
            SOURCES_PATH="$SOURCES_DIR/audio_playlists.txt"
            OUTPUT_PATH='Downloads/Audio/%(playlist_uploader)s/%(playlist_title)s/%(playlist_index)s %(title)s.%(ext)s'
        fi
    fi

        touch "$CONFIG_PATH"
        echo "#Dummy line for sed" > "$CONFIG_PATH"

        sed -i "\$a--download-archive '$ARCHIVES_PATH'" "$CONFIG_PATH"
        sed -i "\$a--datebefore '$TWO_DAYS_AGO'" "$CONFIG_PATH"
        sed -i "\$a-a '$SOURCES_PATH'" "$CONFIG_PATH"
        sed -i "\$a-o '$OUTPUT_PATH'" "$CONFIG_PATH"

        sed -i "\$a-i" "$CONFIG_PATH"
        sed -i "\$a-f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio'" "$CONFIG_PATH"
        sed -i "\$a--merge-output-format mp4" "$CONFIG_PATH"
        sed -i "\$a--write-sub" "$CONFIG_PATH"
        sed -i "\$a--all-subs" "$CONFIG_PATH"
        sed -i "\$a--convert-subs srt" "$CONFIG_PATH"
        sed -i "\$a--add-metadata" "$CONFIG_PATH"
        sed -i "\$a--write-description" "$CONFIG_PATH"
        sed -i "\$a--write-thumbnail" "$CONFIG_PATH"
        
}

function update_config_paths {

    if [ $DOWNLOAD_FORMAT = "-v" ] || [ $DOWNLOAD_FORMAT = "--video" ]; then
        CONFIG_PATH="$CONFIGS_DIR/video.conf"
        ARCHIVES_PATH="$ARCHIVES_DIR/video.txt"
    elif [ $DOWNLOAD_FORMAT = "-a" ] || [ $DOWNLOAD_FORMAT = "--audio" ]; then
        CONFIG_PATH="$CONFIGS_DIR/audio.conf"
        ARCHIVES_PATH="$ARCHIVES_DIR/audio.txt"
    fi
}

if [ $DOWNLOAD_FORMAT = "-h"]  || [ $DOWNLOAD_FORMAT = "--help" ]; then
    usage
else
    update_config_paths
    create_config
    youtube-dl --config-location "$CONFIG_PATH"
fi
