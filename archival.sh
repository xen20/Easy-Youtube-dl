#!/bin/bash

DOWNLOAD_FORMAT=$1
PLAYLIST_OR_CHANNEL=$2

TWO_DAYS_AGO=$(date -d "2 days ago" +'%Y%m%d')

CONFIGS_DIR="$PWD/configs"
ARCHIVES_DIR="$PWD/archives"
SOURCES_DIR="$PWD/sources"

function update_config {
    if [ $DOWNLOAD_FORMAT = "-v" ]; then
        CONFIG_PATH="$CONFIGS_DIR/video.conf"
        ARCHIVES_PATH="$ARCHIVES_DIR/video.txt"

        sed -i '5d' "$CONFIG_PATH" && \
        sed -i "5i --download-archive '$ARCHIVES_PATH'" "$CONFIG_PATH"
        
        sed -i '9d' "$CONFIG_PATH" && \
        sed -i "9i --datebefore $TWO_DAYS_AGO" "$CONFIG_PATH"

        if [ $PLAYLIST_OR_CHANNEL = "-c" ]; then
            SOURCES_PATH="$SOURCES_DIR/video_channels.txt"
            sed -i '6d' "$CONFIG_PATH" && sed -i "6i -a '$SOURCES_PATH'" "$CONFIG_PATH"
            sed -i '2d' "$CONFIG_PATH" &&  \
            sed -i "2i -o 'Downloads/Video/%(uploader)s/%(title)s %(resolution)s.%(ext)s'" "$CONFIG_PATH"
        elif [ $PLAYLIST_OR_CHANNEL = "-p" ]; then
            SOURCES_PATH="$SOURCES_DIR/video_playlists.txt"
            sed -i '6d' "$CONFIG_PATH" && sed -i "6i -a '$SOURCES_PATH'" "$CONFIG_PATH"
            sed -i '2d' "$CONFIG_PATH" &&  \
            sed -i "2i -o 'Downloads/Video/%(playlist_uploader)s/%(playlist_title)s/%(playlist_index)s %(title)s %(resolution)s.%(ext)s'" "$CONFIG_PATH"
        fi
    elif [ $DOWNLOAD_FORMAT = "-a" ]; then
        CONFIG_PATH="$CONFIGS_DIR/audio.conf"
        ARCHIVES_PATH="$ARCHIVES_DIR/audio.txt"

        sed -i '7d' "$CONFIG_PATH" && \
        sed -i "7i --download-archive '$ARCHIVES_PATH'" "$CONFIG_PATH"
        
        sed -i '11d' "$CONFIG_PATH" && \
        sed -i "11i --datebefore $TWO_DAYS_AGO" "$CONFIG_PATH"

        if [ $PLAYLIST_OR_CHANNEL = "-c" ]; then
            SOURCES_PATH="$SOURCES_DIR/audio_channels.txt"
            sed -i '8d' "$CONFIG_PATH" && sed -i "8i -a '$SOURCES_PATH'" "$CONFIG_PATH"
            sed -i '3d' "$CONFIG_PATH" &&  \
            sed -i "3i -o 'Downloads/Audio/%(uploader)s/%(title)s.%(ext)s'" "$CONFIG_PATH"
        elif [ $PLAYLIST_OR_CHANNEL = "-p" ]; then
            SOURCES_PATH="$SOURCES_DIR/audio_playlists.txt"
            sed -i '8d' "$CONFIG_PATH" && sed -i "8i -a $SOURCES_PATH" "$CONFIG_PATH"
            sed -i '3d' "$CONFIG_PATH" && \ 
            sed -i "3i -o 'Downloads/Audio/%(playlist_uploader)s/%(playlist_title)s/%(playlist_index)s %(title)s.%(ext)s'"
        fi
    fi
}

 
update_config
youtube-dl --config-location "$CONFIG_PATH"
