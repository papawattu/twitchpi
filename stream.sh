#!/bin/bash
export START_GPIO_PIN=10
raspi-gpio set $START_GPIO_PIN pu
v4l2-ctl --set-edid=file=/home/pi/1080P.txt --fix-edid-checksums
sleep 20
v4l2-ctl --set-dv-bt-timings query
cd /home/pi/twitchpi
ffmpeg \
    -threads 4 \
    -f alsa \
    -thread_queue_size 4096 \
    -ac 1 \
    -i hw:0 \
    -f alsa \
    -thread_queue_size 4096 \
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
    -b:a 192k \
    -profile:v main \
    -bufsize 8M \
    -minrate 4M \
    -maxrate 4M \
    -pix_fmt yuv420p \
    -filter_complex "[0:a][1:a]join=inputs=2:channel_layout=stereo[a]" \
    -map 2:v -map "[a]" \
    -ac 2 \
    -ar 48000 \
    -codec:a aac \
    -f flv \
    rtmp://live.justin.tv/app/live_9593497_C21Xabj7el1GkrHuG1dNb1ShV19JwH
