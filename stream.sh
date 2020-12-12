#!/bin/bash
export START_GPIO_PIN=10
raspi-gpio set $START_GPIO_PIN pu
v4l2-ctl --set-edid=file=/home/pi/1080P.txt --fix-edid-checksums
sleep 30
v4l2-ctl --set-dv-bt-timings query
cd /home/pi/twitchpi
#npm start
#    -use_wallclock_as_timestamps 1 \
#git pull
#npm install
#node index.js
# ffmpeg -threads 4 -re -f v4l2 -s 1280x720 -i /dev/video0 -b:v 2048k -c:v h264 -r 60 -strict experimental -preset ultrafast -ac 1 -ar 8000 -ab 32k -codec:a aac -f flv rtmp://live.justin.tv/app/live_9593497_C21Xabj7el1GkrHuG1dNb1ShV19JwH
#raspivid -fps 30 -w 1280 -h 720 -t 0 -o - | ffmpeg \
#    -threads 4 \
#    -thread_queue_size 4096 \
#    -f alsa \
#    -ac 1 \
#    -i hw:1 \
#    -f h264 \
#    -thread_queue_size 4096 \
#    -use_wallclock_as_timestamps 1 \
#    -fflags +igndts \
#    -i - \
#    -map 0:0 \
#    -c:v copy \
#    -s 1280x720 \
#    -strict experimental \
#    -b:v 4500k \
#    -bufsize 6M \
#    -minrate 4500k \
#    -maxrate 4500k \
#    -g 50 \
#    -pix_fmt yuv420p \
#    -map 1:0 \
#    -ar 48000 \
#    -codec:a aac \
#    -f flv \
#    rtmp://live.justin.tv/app/live_9593497_C21Xabj7el1GkrHuG1dNb1ShV19JwH

ffmpeg \
    -threads 4 \
    -thread_queue_size 4096 \
    -f alsa \
    -ac 1 \
    -i hw:1 \
    -f v4l2 \
    -thread_queue_size 4096 \
    -use_wallclock_as_timestamps 1 \
    -fflags +igndts \
    -re \
    -i /dev/video0 \
    -map 0:0  \
    -c:v h264_omx \
    -s 1280x720 \
    -strict experimental \
    -b:v 4200k \
    -bufsize 6M \
    -minrate 4200k \
    -maxrate 4200k \
    -g 120 \
    -pix_fmt yuv420p \
    -map 1:0 \
    -ar 48000 \
    -codec:a aac \
    -f flv \
    rtmp://live.justin.tv/app/live_9593497_C21Xabj7el1GkrHuG1dNb1ShV19JwH
