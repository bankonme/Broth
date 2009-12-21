#!/bin/bash

# Removing the Audio category ensures mplayer stays in the Multimedia category
echo "17c17
< Categories=GTK;AudioVideo;Audio;Video;Player;TV;
--
> Categories=GTK;AudioVideo;Video;Player;TV;" | patch /usr/share/applications/mplayer.desktop

