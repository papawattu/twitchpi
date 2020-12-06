#!/bin/bash
raspi-gpio set 10 pu
v4l2-ctl --set-dv-bt-timings index=33
npm start
