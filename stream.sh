#!/bin/bash
export START_GPIO_PIN=10
raspi-gpio set $START_GPIO_PIN pu
v4l2-ctl --set-dv-bt-timings index=33
npm start
# ffmpeg -threads 4 -re -f v4l2 -s 1280x720 -i /dev/video0 -b:v 2048k -c:v h264 -r 60 -strict experimental -preset ultrafast -ac 1 -ar 8000 -ab 32k -codec:a aac -f flv rtmp://live.justin.tv/app/live_9593497_C21Xabj7el1GkrHuG1dNb1ShV19JwH