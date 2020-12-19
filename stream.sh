#!/bin/bash
export START_GPIO_PIN=10
raspi-gpio set $START_GPIO_PIN pu
v4l2-ctl --set-edid=file=/home/pi/1080P.txt --fix-edid-checksums
sleep 30
v4l2-ctl --set-dv-bt-timings query
cd /home/pi/twitchpi
ffmpeg \
    -threads 4 \
    -thread_queue_size 4096 \
    -f alsa \
    -ac 1 \
    -i hw:0 \
    -thread_queue_size 4096 \
    -f alsa \
    -ac 1 \
    -i hw:1 \
    -f v4l2 \
    -thread_queue_size 4096 \
    -use_wallclock_as_timestamps 1 \
    -fflags +igndts \
    -r 60 \
    -i /dev/video0 \
    -c:v h264_omx \
    -s 1280x720 \
    -r 30 \
    -strict experimental \
    -b:v 4M \
    -preset veryfast \
    -profile:v main \
    -bufsize 8M \
    -minrate 4M \
    -maxrate 4M \
    -crf 22 \
    -x264-params "nal-hrd=cbr:keyint=120:scenecut=0" \
    -pix_fmt yuv420p \
    -filter_complex "[0:a][1:a]join=inputs=2:channel_layout=stereo[a]" \
    -map 2:v -map "[a]" \
    -ac 2 \
    -ar 48000 \
    -codec:a aac \
    -f flv \
    rtmp://live.justin.tv/app/live_9593497_C21Xabj7el1GkrHuG1dNb1ShV19JwH
